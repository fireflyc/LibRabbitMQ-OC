//
// Created by fireflyc on 15/5/31.
// Copyright (c) 2015 fireflyc. All rights reserved.
//
#import "AMQPChannel.h"

@implementation Envelope {

}
@end

@interface AMQPChannel ()
@property(weak) AMQPConnection *connection;
@property UInt16 channel;
@property BlockingQueue *activeQueue;
@property BlockingQueue *activeWriteQueue;
@property NSMutableDictionary *consumeDict;
@property AMQPConsume *activeConsume;
@end

@implementation AMQPChannel {

}

- (instancetype)initWithChannel:(UInt16)channel connection:(AMQPConnection *)connection {
    self = [super init];
    if (self) {
        self.channel = channel;
        self.connection = connection;
        self.activeQueue = nil;
        self.activeWriteQueue = nil;
        self.activeConsume = nil;
        self.consumeDict = [NSMutableDictionary new];
    }
    return self;
}

- (BOOL)close {
    NSError *error = nil;
    ChannelClose *channelClose = [[ChannelClose alloc] initWithReplyCode:AMQP_REPLY_SUCCESS replyText:@"close normal"
                                                                 classId:0 methodId:0];
    AMQPCommand *command = [self rpcCommand:[AMQPCommand commandWithMethod:channelClose] error:&error];
    return [self.connection checkReplyCommand:command error:&error];
}

- (BOOL)queueDeclare:(NSString *)theName isDurable:(BOOL)durable isExclusive:(BOOL)exclusive autoDeleted:(BOOL)autoDelete
           isPassive:(BOOL)passive arguments:(NSDictionary *)arguments nowait:(BOOL)nowait queueDeclareOk:(QueueDeclareOk **)ok
               error:(NSError **)error {
    QueueDeclare *queueDeclare = [[QueueDeclare alloc] initWithTicket:0 queue:theName passive:passive durable:durable
                                                            exclusive:exclusive autoDelete:autoDelete nowait:nowait
                                                            arguments:arguments];
    if (nowait) {
        [self writeCommand:[AMQPCommand commandWithMethod:queueDeclare] error:error];
        return TRUE;
    } else {
        AMQPCommand *command = [self rpcCommand:[AMQPCommand commandWithMethod:queueDeclare] error:error];
        BOOL result = [self.connection checkReplyCommand:command error:error];
        if (result && ok != NULL) {
            *ok = (QueueDeclareOk *) command.method;
        }
        return result;
    }
}

- (BOOL)queueDeclare:(NSString *)queue isDurable:(BOOL)durable isExclusive:(BOOL)exclusive autoDeleted:(BOOL)deleted
               error:(NSError **)error {
    return [self queueDeclare:queue isDurable:durable isExclusive:exclusive autoDeleted:deleted arguments:nil
                        error:error];
}

- (BOOL)queueDeclare:(NSString *)queue isDurable:(BOOL)durable isExclusive:(BOOL)exclusive autoDeleted:(BOOL)deleted
           arguments:(NSDictionary *)arguments error:(NSError **)error {
    return [self queueDeclare:queue isDurable:durable isExclusive:exclusive autoDeleted:deleted isPassive:FALSE
                    arguments:arguments nowait:FALSE queueDeclareOk:NULL error:error];
}

- (BOOL)queueDeclare:(NSString *)queue isDurable:(BOOL)durable isExclusive:(BOOL)exclusive autoDeleted:(BOOL)deleted
           arguments:(NSDictionary *)arguments queueDeclareOk:(QueueDeclareOk **)ok error:(NSError **)error {
    return [self queueDeclare:queue isDurable:durable isExclusive:exclusive autoDeleted:deleted isPassive:FALSE
                    arguments:arguments nowait:FALSE queueDeclareOk:ok error:error];
}

- (BOOL)exchangeDeclareOfType:(NSString *)theType withName:(NSString *)theName isPassive:(BOOL)passive
                    isDurable:(BOOL)durable autoDelete:(BOOL)autoDelete nowait:(BOOL)nowait error:(NSError **)error {
    ExchangeDeclare *exchangeDeclare = [[ExchangeDeclare alloc] initWithTicket:0 exchange:theName type:theType passive:passive
                                                                       durable:durable autoDelete:autoDelete internal:false
                                                                        nowait:nowait arguments:nil];
    if (nowait) {
        [self writeCommand:[AMQPCommand commandWithMethod:exchangeDeclare] error:error];
        return TRUE;
    } else {
        AMQPCommand *command = [self rpcCommand:[AMQPCommand commandWithMethod:exchangeDeclare] error:error];
        return [self.connection checkReplyCommand:command error:error];
    }
}

- (BOOL)directExchangeWithName:(NSString *)theName isPassive:(BOOL)passive isDurable:(BOOL)durable
                    autoDelete:(BOOL)autoDelete error:(NSError **)error {
    return [self exchangeDeclareOfType:@"direct" withName:theName isPassive:passive isDurable:durable autoDelete:autoDelete
                                nowait:TRUE error:error];
}

- (BOOL)topicExchangeWithName:(NSString *)theName isPassive:(BOOL)passive isDurable:(BOOL)durable autoDelete:(BOOL)
        autoDelete      error:(NSError **)error {
    return [self exchangeDeclareOfType:@"topic" withName:theName isPassive:passive isDurable:durable autoDelete:autoDelete
                                nowait:TRUE error:error];
}

- (BOOL)fanoutExchangeWithName:(NSString *)theName isPassive:(BOOL)passive isDurable:(BOOL)durable
                    autoDelete:(BOOL)autoDelete error:(NSError **)error {
    return [self exchangeDeclareOfType:@"fanout" withName:theName isPassive:passive isDurable:durable autoDelete:autoDelete
                                nowait:TRUE error:error];
}

- (BOOL)exchangeWithName:(NSString *)theName error:(NSError **)error {
    return [self directExchangeWithName:theName isPassive:FALSE isDurable:FALSE autoDelete:FALSE error:error];
}

- (BOOL)basicPublishMessage:(NSString *)exchangeName usingRoutingKey:(NSString *)theRoutingKey body:(NSData *)body
                      error:(NSError **)error {
    AMQPBasicProperties *properties = [[AMQPBasicProperties alloc] init];
    properties.contentType = @"json";
    return [self basicPublishMessage:exchangeName usingRoutingKey:theRoutingKey propertiesMessage:properties body:body
                           mandatory:FALSE immediate:FALSE error:error];
}

- (BOOL)basicPublishMessage:(NSString *)exchangeName usingRoutingKey:(NSString *)theRoutingKey
                 properties:(AMQPBasicProperties *)properties body:(NSData *)body error:(NSError **)error {
    return [self basicPublishMessage:exchangeName usingRoutingKey:theRoutingKey propertiesMessage:properties body:body
                           mandatory:FALSE immediate:FALSE error:error];
}

- (BOOL)basicPublishMessage:(NSString *)exchangeName usingRoutingKey:(NSString *)theRoutingKey
          propertiesMessage:(AMQPBasicProperties *)properties body:(NSData *)body mandatory:(BOOL)isMandatory
                  immediate:(BOOL)isImmediate error:(NSError **)error {
    if (properties == nil) {
        properties = [[AMQPBasicProperties alloc] init];
    }
    BasicPublish *basicPublish = [[BasicPublish alloc] initWithTicket:0 exchange:exchangeName routingKey:theRoutingKey
                                                            mandatory:isMandatory immediate:isImmediate];
    AMQPContentHeader *contentHeader = [[AMQPContentHeader alloc] initWith:properties bodySize:body.length];
    AMQPCommand *command = [[AMQPCommand alloc] initWithMethod:basicPublish contentHeader:contentHeader
                                                   contentBody:[NSMutableData dataWithBytes:body.bytes length:body.length]];
    return [self writeCommand:command error:error];
}

- (NSString *)basicConsume:(NSString *)queue autoAck:(BOOL)autoAck consumerTag:(NSString *)consumerTag
                   noLocal:(BOOL)noLocal exclusive:(BOOL)exclusive arguments:(NSDictionary *)arguments
                  delegate:(id)delegate error:(NSError **)error {
    BasicConsume *basicConsume = [[BasicConsume alloc] initWithTicket:0 queue:queue consumerTag:consumerTag
                                                              noLocal:noLocal noAck:autoAck exclusive:exclusive
                                                               nowait:FALSE arguments:arguments];
    AMQPCommand *command = [self rpcCommand:[AMQPCommand commandWithMethod:basicConsume] error:error];
    if (![self.connection checkReplyCommand:command error:error]) {
        return nil;
    }
    BasicConsumeOk *consumeOk = (BasicConsumeOk *) command.method;
    [self.consumeDict setValue:[[AMQPConsume alloc] initWithDelegate:delegate] forKey:consumeOk.consumerTag];
    if ([delegate respondsToSelector:@selector(handleConsumeOk:)]) {
        [delegate handleConsumeOk:consumeOk.consumerTag];
    }
    return consumeOk.consumerTag;
}

- (NSString *)basicConsume:(NSString *)queue delegate:(id <AMQPConsumerDelegate>)delegate error:(NSError **)error {
    return [self basicConsume:queue autoAck:FALSE delegate:delegate error:error];
}

- (NSString *)basicConsume:(NSString *)queue autoAck:(BOOL)autoAck delegate:(id <AMQPConsumerDelegate>)delegate
                     error:(NSError **)error {
    return [self basicConsume:queue autoAck:autoAck consumerTag:@"" delegate:delegate error:error];
}

- (NSString *)basicConsume:(NSString *)queue autoAck:(BOOL)autoAck consumerTag:(NSString *)consumerTag
                  delegate:(id <AMQPConsumerDelegate>)delegate error:(NSError **)error {
    return [self basicConsume:queue autoAck:autoAck consumerTag:consumerTag noLocal:FALSE exclusive:FALSE arguments:nil
                     delegate:delegate error:error];
}

- (void)enqueueRpc:(BlockingQueue *)blockingQueue {
    self.activeQueue = blockingQueue;
}

- (void)nextOutstandingRpc {
    self.activeQueue = nil;
}

- (void)enqueueWrite:(BlockingQueue *)blockingQueue {
    self.activeWriteQueue = blockingQueue;
}

- (void)nextOutstandingWrite {
    self.activeWriteQueue = nil;
}

- (BOOL)basicCancel:(NSString *)consumerTag error:(NSError **)error {
    BasicCancel *basicCancel = [[BasicCancel alloc] initWithConsumerTag:consumerTag nowait:FALSE];
    AMQPCommand *command = [self rpcCommand:[AMQPCommand commandWithMethod:basicCancel] error:error];
    if (command == nil) {
        return FALSE;
    }
    BasicCancelOk *cancelOk = (BasicCancelOk *) command.method;
    AMQPConsume *consume = [self.consumeDict valueForKey:cancelOk.consumerTag];
    if (consume != nil) {
        [consume handleCancelOk:consumerTag];
        [self.consumeDict removeObjectForKey:cancelOk.consumerTag];
    }
    return TRUE;
}

- (AMQPCommand *)readCommandWitQueue:(BlockingQueue *)queue error:(NSError **)error {
    AMQPCommand *command = [[AMQPCommand alloc] init];
    while (![command isComplete]) {
        AMQPFrame *replyFrame = [queue popWithTimeout:self.connection.readTimeout];
        if (replyFrame == nil) {
            *error = [self.connection AMQPErrorWith:@"Read timeout"];
            return nil;
        }
        [command handlerFrame:replyFrame];
    }
    [command reset];
    return command;
}

- (BOOL)writeCommand:(AMQPCommand *)command error:(NSError **)error {
    AMQPFrame *methodFrame = [[AMQPFrame alloc] initWithFrameType:AMQP_FRAME_METHOD channelNumber:self.channel
                                                      payloadType:AMQPFramePayloadTypeMethod payload:command.method];
    if (![self writeFrame:methodFrame error:error]) {
        return FALSE;
    }
    if ([command.method hasContent]) {
        AMQPFrame *headerFrame = [[AMQPFrame alloc] initWithFrameType:AMQP_FRAME_HEADER channelNumber:self.channel
                                                          payloadType:AMQPFramePayloadTypeHeader payload:command.header];
        if (![self writeFrame:headerFrame error:error]) {
            return FALSE;
        }

        int frameMax = (int) self.connection.maxFrame;
        NSLog(@"frameMax: %i", frameMax);
        int bodyPayloadMax = (frameMax == 0) ? (int)command.body.length : (frameMax - AMQP_FRAME_EMPTY_SIZE);

        for (int offset = 0; offset < command.body.length; offset += bodyPayloadMax) {
            int remaining = command.body.length - offset;

            int fragmentLength = (remaining < bodyPayloadMax) ? remaining
                    : bodyPayloadMax;
            NSRange range;
            range.location = (NSUInteger) offset;
            range.length = (NSUInteger) fragmentLength;
            NSData *fragmentBody = [command.body subdataWithRange:range];
            AMQPFrame *bodyFrame = [[AMQPFrame alloc] initWithFrameType:AMQP_FRAME_BODY channelNumber:self.channel
                                                            payloadType:AMQPFramePayloadTypeBody payload:fragmentBody];
            if (![self writeFrame:bodyFrame error:error]) {
                return FALSE;
            }
        }
    }
    return TRUE;
}

- (AMQPCommand *)rpcCommand:(AMQPCommand *)command error:(NSError **)error {
    BlockingQueue *blockingQueue = [BlockingQueue new];
    [self enqueueRpc:blockingQueue];
    if (![self writeCommand:command error:error]) {
        return nil;
    }
    AMQPCommand *result = [self readCommandWitQueue:blockingQueue error:error];
    [self nextOutstandingRpc];
    return result;
}

- (BOOL)writeFrame:(AMQPFrame *)frame error:(NSError **)error {
    AMQPOutputStream *outStream = [AMQPOutputStream new];
    [frame writeOutputStream:outStream maxFrame:self.connection.maxFrame];
    NSMutableData *data = outStream.data;
    BlockingQueue *blockingQueue = [BlockingQueue new];
    [self enqueueWrite:blockingQueue];
    [self.connection writeData:data tag:self.channel];
    id writeAck = [blockingQueue popWithTimeout:self.connection.writeTimeout];
    [self nextOutstandingWrite];
    return writeAck != nil;
}

- (void)receiveFrame:(AMQPFrame *)frame {
    if (frame.payloadType == AMQPFramePayloadTypeMethod) {
        AMQPMethod *method = frame.payload;
        if ([method isKindOfClass:[BasicDeliver class]]) {
            BasicDeliver *deliver = (BasicDeliver *) method;
            AMQPConsume *consume = [self.consumeDict valueForKey:deliver.consumerTag];
            if (consume != nil) {
                self.activeConsume = consume;
                [consume handlerFrame:frame];
                return;
            } else {
                //在没有收到consumeOk之前可能首先收到BasicDeliver消息,这时候dict没有对应的consumer,所以此处把消息弹回服务器
                NSError *error = nil;
                [self basicNAck:deliver.deliveryTag multiple:FALSE requeue:TRUE error:&error];
            }
        }
    }
    if (self.activeConsume != nil) {
        if ([self.activeConsume handlerFrame:frame]) {
            self.activeConsume = nil;
        }
    }
    [self.activeQueue push:frame];
}

- (void)receiveWriteOk:(long)tag {
    [self.activeWriteQueue push:@(tag)];
}

- (BOOL)open:(NSError **)error {
    ChannelOpen *channelOpen = [[ChannelOpen alloc] initWithOutOfBand:@""];
    AMQPCommand *command = [self rpcCommand:[AMQPCommand commandWithMethod:channelOpen] error:error];
    if ([self.connection checkReplyCommand:command error:error]) {
        return TRUE;
    }
    return FALSE;
}

- (BOOL)queueDeclareForRPC:(QueueDeclareOk **)queueDeclareOk error:(NSError **)error {
    if ([self queueDeclare:@"" isDurable:FALSE isExclusive:TRUE autoDeleted:TRUE arguments:NULL queueDeclareOk:queueDeclareOk
                     error:error]) {
        return TRUE;
    }
    return FALSE;
}

- (void)basicAck:(UInt64)deliveryTag multiple:(BOOL)multiple error:(NSError **)error {
    BasicAck *ack = [[BasicAck alloc] initWithDeliveryTag:deliveryTag multiple:multiple];
    [self writeCommand:[AMQPCommand commandWithMethod:ack] error:error];
}

- (void)basicNAck:(UInt64)deliveryTag multiple:(BOOL)multiple requeue:(BOOL)requeue error:(NSError **)error {
    BasicNack *nack = [[BasicNack alloc] initWithDeliveryTag:deliveryTag multiple:multiple requeue:requeue];
    [self writeCommand:[AMQPCommand commandWithMethod:nack] error:error];
}


- (BOOL)basicQos:(UInt32)prefetchSize error:(NSError **)error {
    return [self basicQos:0 prefetchCount:1 global:FALSE error:error];
}

- (BOOL)basicQos:(UInt32)prefetchSize prefetchCount:(UInt16)prefetchCount global:(BOOL)global error:(NSError **)error {
    BasicQos *qos = [[BasicQos alloc] initWithPrefetchSize:prefetchSize prefetchCount:prefetchCount global:global];
    AMQPCommand *command = [self rpcCommand:[AMQPCommand commandWithMethod:qos] error:error];
    if ([self.connection checkReplyCommand:command error:error]) {
        return TRUE;
    }
    return FALSE;
}

- (BOOL)queueBind:(NSString *)queue exchange:(NSString *)exchange routingKey:(NSString *)routingKey nowait:(BOOL)nowait
            error:(NSError **)error {
    QueueBind *queueBind = [[QueueBind alloc] initWithTicket:0 queue:queue exchange:exchange routingKey:routingKey
                                                      nowait:nowait
                                                   arguments:nil];
    if (nowait) {
        [self writeCommand:[AMQPCommand commandWithMethod:queueBind] error:error];
        return TRUE;
    }
    AMQPCommand *command = [self rpcCommand:[AMQPCommand commandWithMethod:queueBind] error:error];
    return [self.connection checkReplyCommand:command error:error];
}

- (BOOL)queueBind:(NSString *)queue exchange:(NSString *)exchange routingKey:(NSString *)key error:(NSError **)error {
    return [self queueBind:queue exchange:exchange routingKey:key nowait:FALSE error:error];
}

@end