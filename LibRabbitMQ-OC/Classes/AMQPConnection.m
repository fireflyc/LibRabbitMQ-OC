//
// Created by fireflyc on 15/5/28.
// Copyright (c) 2015 fireflyc. All rights reserved.
//

#import "AMQPConnection.h"

NSString *const AMQPLibraryErrorDomain = @"AMQPLibraryErrorDomain";

@interface AMQPConnection ()

@property UInt16 port;
@property NSString *host;
@property UInt16 heartbeat;
@property NSMutableData *readBuffer;
@property UInt16 minFrameSize;

@property dispatch_semaphore_t connectionSemaphore;
@property dispatch_source_t heartBeatTimer;
@property NSMutableDictionary *channelMap;

@property AMQPChannel *mainChannel;

@property UInt16 nextChannel;
@property UInt16 maxChannel;
@end

@implementation AMQPConnection {
}
- (instancetype)initWithHost:(NSString *)host port:(UInt16)port heartbeat:(UInt16)heartbeat
                    userName:(NSString *)userName password:(NSString *)password vHost:(NSString *)vHost
           lifecycleDelegate:(id <AMQPConnectionLifecycleDelegate>)delegate {
    self = [super init];
    if (self) {
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self
                                                 delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        //初始化变量
        self.host = host;
        self.port = port;
        self.heartbeat = heartbeat;
        self.userName = userName;
        self.password = password;
        self.vHost = vHost;
        self.lifecycleDelegate = delegate;
        self.readBuffer = [NSMutableData new];
        self.minFrameSize = AMQP_HEADER_SIZE + AMQP_FOOTER_SIZE;

        self.isLogin = TRUE;
        self.channelMap = [NSMutableDictionary new];
        self.connectionSemaphore = dispatch_semaphore_create(0);

        self.writeTimeout = 5;
        self.readTimeout = 5;
        self.maxChannel = UINT16_MAX;
        self.nextChannel = 1;
        self.maxFrame = 131072; //最小128k

        //准备心跳
        self.heartBeatTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,
                dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));

        dispatch_source_set_timer(self.heartBeatTimer, dispatch_walltime(nil, 0),
                (UInt64) (self.heartbeat * NSEC_PER_SEC), 0);
        __block AMQPConnection *weakSelf = self;
        dispatch_source_set_event_handler(self.heartBeatTimer, ^{
            if (!weakSelf.socket.isConnected) {
                NSError *error = nil;
                if (![weakSelf connectionWithTimeout:3 error:&error]) {
                    NSLog(@"Connection Error %@", error);
                }else{
                    [weakSelf.lifecycleDelegate reconnectionSuccess:weakSelf.userName :weakSelf];
                }
            }
            AMQPFrame *heartbeatFrame = [[AMQPFrame alloc] init];
            heartbeatFrame.frameType = AMQP_FRAME_HEARTBEAT;
            AMQPChannel *channel = [weakSelf.channelMap valueForKey:[NSString stringWithFormat:@"0"]];
            NSError *error;
            if (![channel writeFrame:heartbeatFrame error:&error]) {
                NSLog(@"Hearbeat fail %@", error);
            }
        });
    }
    return self;
}

- (BOOL)connectionWithTimeout:(NSTimeInterval)timeout error:(NSError **)error {
    if ([self.socket connectToHost:self.host onPort:self.port withTimeout:timeout error:error]) {
        dispatch_time_t tt = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (timeout * NSEC_PER_SEC));
        dispatch_semaphore_wait(self.connectionSemaphore, tt);
        if (!self.socket.isConnected) {
            //*error = [self.socket connectTimeoutError];
            return FALSE;
        }
        return [self loginWithError:error];
    }
    return self.socket.isConnected;
}

- (BOOL)loginWithError:(NSError **)error {
    static const uint8_t header[8] = {'A', 'M', 'Q', 'P', 0,
            AMQP_PROTOCOL_VERSION_MAJOR,
            AMQP_PROTOCOL_VERSION_MINOR,
            AMQP_PROTOCOL_VERSION_REVISION
    };
    long loginTag = 0;
    self.mainChannel = [[AMQPChannel alloc] initWithChannel:(UInt16) loginTag connection:self];
    [self.channelMap setValue:self.mainChannel forKey:[NSString stringWithFormat:@"%ld", loginTag]];
    [self.socket writeData:
                    [NSData dataWithBytes:header length:sizeof(header)]
               withTimeout:self.writeTimeout
                       tag:loginTag];

    BlockingQueue *blockingQueue = [BlockingQueue new];
    [self.mainChannel enqueueRpc:blockingQueue];
    //first read
    [self.socket readDataWithTimeout:self.readTimeout tag:loginTag];

    AMQPCommand *command = [self.mainChannel readCommandWitQueue:blockingQueue error:error];
    [self.mainChannel nextOutstandingRpc];
    [blockingQueue clear];

    if (command.method == nil) {
        *error = [self AMQPErrorWith:@"Authentication Error" code:0];
        return FALSE;
    }
    ConnectionStart *connectionStart = (ConnectionStart *) command.method;
    ConnectionStartOk *startOk = [[ConnectionStartOk alloc] init];
    startOk.response = [NSString stringWithFormat:@"\0%@%\0%@", self.userName, self.password];
    startOk.clientProperties = connectionStart.serverProperties;
    startOk.locale = connectionStart.locales;
    startOk.mechanism = @"PLAIN";
    command = [self.mainChannel rpcCommand:[AMQPCommand commandWithMethod:startOk] error:error];
    if (command.method == nil) {
        *error = [self AMQPErrorWith:@"Authentication Error" code:0];
        return FALSE;
    }
    ConnectionTune *tune = (ConnectionTune *) command.method;
    ConnectionTuneOk *tuneOk = [ConnectionTuneOk new];
    self.maxChannel = MAX(self.maxChannel, tune.channelMax);
    self.maxFrame = MIN(self.maxFrame, tune.frameMax);
    tuneOk.channelMax = self.maxChannel;
    tuneOk.frameMax = self.maxFrame;
    tuneOk.heartbeat = self.heartbeat;

    [self.mainChannel enqueueRpc:blockingQueue];
    if (![self.mainChannel writeCommand:[AMQPCommand commandWithMethod:tuneOk] error:error]) {
        *error = [self AMQPErrorWith:@"Authentication Error" code:0];
        return FALSE;
    }
    ConnectionOpen *connectionOpen = [ConnectionOpen new];
    connectionOpen.virtualHost = self.vHost;
    connectionOpen.insist = FALSE;
    if (![self.mainChannel writeCommand:[AMQPCommand commandWithMethod:connectionOpen] error:error]) {
        *error = [self AMQPErrorWith:@"Authentication Error" code:0];
        return FALSE;
    }
    command = [self.mainChannel readCommandWitQueue:blockingQueue error:error];
    [self.mainChannel nextOutstandingRpc];
    [blockingQueue clear];

    if (command.method == nil) {
        *error = [self AMQPErrorWith:@"Authentication Error" code:0];
        return FALSE;
    }
    return TRUE;
}

- (AMQPChannel *)openChannel:(NSError **)error {
    if (self.maxChannel <= self.nextChannel) {
        *error = [self AMQPErrorWith:@"Channel more than limit" code:0];
        return nil;
    }
    AMQPChannel *amqpChannel = [[AMQPChannel alloc] initWithChannel:self.nextChannel connection:self];
    NSString *channelId = [NSString stringWithFormat:@"%d", self.nextChannel];
    [self.channelMap setValue:amqpChannel forKey:channelId];
    if ([amqpChannel open:error]) {
        self.nextChannel++;
        return amqpChannel;
    }
    return nil;
}

- (NSError *)AMQPErrorWith:(NSString *)errMsg code:(UInt16)code {
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : errMsg};
    return [NSError errorWithDomain:AMQPLibraryErrorDomain code:code userInfo:userInfo];
}

- (NSError *)AMQPErrorWith:(NSString *)errMsg {
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : errMsg};
    return [NSError errorWithDomain:AMQPLibraryErrorDomain code:-1 userInfo:userInfo];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    dispatch_semaphore_signal(self.connectionSemaphore);
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    if (err.code == GCDAsyncSocketConnectTimeoutError) {
        dispatch_semaphore_signal(self.connectionSemaphore);
        return;
    }
    NSLog(@"Connection disconnect %@", err);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    [self.readBuffer appendData:data];
    if (self.readBuffer.length < self.minFrameSize) {
        return;
    }
    while (self.readBuffer.length > self.minFrameSize) {
        AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:self.readBuffer];
        AMQPFrame *frame = [AMQPFrame new];
        frame.frameType = [inputStream AMQPReadUInt8];
        frame.channelNumber = [inputStream AMQPReadUInt16];
        frame.payloadSize = [inputStream AMQPReadUInt32];
        if ((self.readBuffer.length + self.minFrameSize) < frame.payloadSize) {
            break;
        }
        AMQPChannel *channel = [self.channelMap valueForKey:[NSString stringWithFormat:@"%d", frame.channelNumber]];
        AMQPFrame *heartbeatFrame = [[AMQPFrame alloc] init];
        switch (frame.frameType) {
            case AMQP_FRAME_METHOD: {
                frame.payloadType = AMQPFramePayloadTypeMethod;
                AMQPMethod *amqpMethod = [AMQP readMethod:inputStream];
                frame.payload = amqpMethod;
                [channel receiveFrame:frame];
                break;
            }
            case AMQP_FRAME_HEADER: {
                frame.payloadType = AMQPFramePayloadTypeHeader;
                AMQPContentHeader *contentHeader = [AMQPContentHeader new];
                contentHeader.classId = [inputStream AMQPReadUInt16];
                contentHeader.weight = [inputStream AMQPReadUInt16];
                contentHeader.bodySize = [inputStream AMQPReadUInt64];
                if (contentHeader.classId == AMQP_BASIC_PROPERTIES_CLASS_ID) {//now only one
                    contentHeader.properties = [inputStream AMQPReadProperties];
                }
                frame.payload = contentHeader;
                [channel receiveFrame:frame];
                break;
            }
            case AMQP_FRAME_BODY: {
                frame.payloadType = AMQPFramePayloadTypeBody;
                NSMutableData *bodyDataPayload = [NSMutableData dataWithBytes:[inputStream AMQPReadBytesWithLen:frame.payloadSize]
                                                                       length:frame.payloadSize];
                frame.payload = bodyDataPayload;
                [channel receiveFrame:frame];
                break;
            }
            case AMQP_FRAME_HEARTBEAT: {
                heartbeatFrame.frameType = AMQP_FRAME_HEARTBEAT;
                NSError *error;
                if (![self.mainChannel writeFrame:heartbeatFrame error:&error]) {
                    NSLog(@"Hearbeat fail %@", error);
                }
                break;
            }
            default: {
                NSLog(@"Unknow frame");
                break;
            }
        }
        [inputStream AMQPReadUInt8]; //always AMQP_FRAME_END
        NSUInteger bufferLength = 0;
        if (self.readBuffer.length > (frame.payloadSize + self.minFrameSize)) {
            bufferLength = self.readBuffer.length - (frame.payloadSize + self.minFrameSize);
        }
        self.readBuffer = [NSMutableData dataWithBytes:self.readBuffer.bytes + (frame.payloadSize + self.minFrameSize)
                                                length:bufferLength];
    }
    if (self.isLogin) {
        [self.socket readDataWithTimeout:-1 buffer:[NSMutableData new] bufferOffset:0 tag:0];
    } else {
        [self.socket readDataWithTimeout:self.readTimeout buffer:[NSMutableData new] bufferOffset:0 tag:0];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    AMQPChannel *channel = [self.channelMap valueForKey:[NSString stringWithFormat:@"%ld", tag]];
    [channel receiveWriteOk:tag];
}

- (BOOL)checkReplyCommand:(AMQPCommand *)command error:(NSError **)error {
    if (command == nil || command.method == nil) {
        *error = [self AMQPErrorWith:@"Unknow error not reply"];
        return FALSE;
    }
    if (command.method != nil) {
        AMQPMethod *method = command.method;
        if ([method isKindOfClass:[ConnectionClose class]]) {
            ConnectionClose *connectionClose = (ConnectionClose *) method;
            *error = [self AMQPErrorWith:connectionClose.replyText code:connectionClose.replyCode];
            return FALSE;
        }
        if ([method isKindOfClass:[ChannelClose class]]) {
            ChannelClose *channelClose = (ChannelClose *) method;
            *error = [self AMQPErrorWith:channelClose.replyText code:channelClose.replyCode];
            return FALSE;
        }
    }
    return TRUE;
}

- (void)writeData:(NSData *)data tag:(long)tag {
    [self.socket writeData:data withTimeout:self.writeTimeout tag:tag];
}

- (void)logout {
    [self shutdownHeartbeat];
    NSError *error = NULL;
    ConnectionClose *connectionClose = [[ConnectionClose alloc] initWithReplyCode:AMQP_REPLY_SUCCESS replyText:@"OK"
                                                                          classId:0 methodId:0];
    AMQPCommand *command = [[AMQPCommand alloc] initWithMethod:connectionClose];
    [self.mainChannel rpcCommand:command error:&error];
    [self.socket disconnect];
}

- (void)shutdownHeartbeat {
    if (self.heartbeat > 0) {
        dispatch_source_cancel(self.heartBeatTimer);
    }
}

- (void)stopHeartbeat {
    if (self.heartbeat > 0) {
        dispatch_suspend(self.heartBeatTimer);
    }
}

- (void)startHeartbeat {
    if (self.heartbeat > 0) {
        dispatch_resume(self.heartBeatTimer);
    }
}
@end