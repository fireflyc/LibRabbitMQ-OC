//
// Created by fireflyc 
//

#import "AMQPFrame.h"
#import "AMQP.h"
#import "AMQPStream.h"


@implementation AMQPFrame {

}
- (instancetype)initWithFrameType:(UInt8)frameType channelNumber:(UInt16)channelNumber
                      payloadType:(AMQPFramePayloadType)payloadType payload:(id)payload {
    self = [super init];
    if (self) {
        self.frameType = frameType;
        self.channelNumber = channelNumber;
        self.payloadType = payloadType;
        self.payload = payload;
    }

    return self;
}

- (void)writeOutputStream:(AMQPOutputStream *)stream maxFrame:(UInt32)maxFrame {
    [stream AMQPWriteUInt8:self.frameType];
    [stream AMQPWriteUInt16:self.channelNumber];
    if (self.frameType == AMQP_FRAME_HEARTBEAT) {
        [stream AMQPWriteUInt32:0];
        [stream AMQPWriteUInt8:AMQP_FRAME_END];
        return;
    }
    if (self.payload == nil) {
        [stream AMQPWriteUInt32:0];
    } else {
        switch (self.payloadType) {
            case AMQPFramePayloadTypeMethod:
                [self writeMethodPayload:stream];
                break;
            case AMQPFramePayloadTypeHeader:
                [self writeHeaderPayload:stream];
                break;
            case AMQPFramePayloadTypeBody:
                [self writeDataPayload:stream maxFrame:maxFrame];
                break;
        }
    }
}

- (void)writeHeaderPayload:(AMQPOutputStream *)outputStream{
    AMQPOutputStream *payloadOutputStream = [AMQPOutputStream new];
    AMQPContentHeader *contentHeader = self.payload;
    [payloadOutputStream AMQPWriteUInt16:contentHeader.classId];
    [payloadOutputStream AMQPWriteUInt16:contentHeader.weight];
    [payloadOutputStream AMQPWriteUInt64:(UInt64) contentHeader.bodySize];
    [payloadOutputStream AMQPWriteProperties:contentHeader.properties];

    [outputStream AMQPWriteUInt32:(UInt32) payloadOutputStream.data.length];
    [outputStream AMQPWriteData:payloadOutputStream.data];
    [outputStream AMQPWriteUInt8:AMQP_FRAME_END];
}

- (void)writeDataPayload:(AMQPOutputStream *)outputStream maxFrame:(UInt32)maxFrame {
    NSMutableData *dataPayload = self.payload;
    NSUInteger maxLength = dataPayload.length;
    NSUInteger bodyPayloadMax = (maxFrame == 0) ? maxLength : maxFrame - (AMQP_HEADER_SIZE + AMQP_FOOTER_SIZE);

    for (int offset = 0; offset < maxLength; offset += bodyPayloadMax) {
        NSUInteger remaining = maxLength - offset;

        NSUInteger fragmentLength = (remaining < bodyPayloadMax) ? remaining : bodyPayloadMax;
        NSData *data = [[NSData alloc] initWithBytes:dataPayload.bytes + offset length:fragmentLength];

        [outputStream AMQPWriteUInt32:(UInt32) fragmentLength];
        [outputStream AMQPWriteData:data];
        [outputStream AMQPWriteUInt8:AMQP_FRAME_END];
    }
}

- (void)writeMethodPayload:(AMQPOutputStream *)outputStream {
    AMQPMethod *amqpMethod = self.payload;
    AMQPOutputStream *methodOutStream = [AMQPOutputStream new];
    [amqpMethod write:methodOutStream];
    NSMutableData *data = methodOutStream.data;
    [outputStream AMQPWriteUInt32:(UInt32) data.length];
    [outputStream AMQPWriteData:data];
    [outputStream AMQPWriteUInt8:AMQP_FRAME_END];
}
@end

@implementation AMQPContentHeader{

}
- (instancetype)initWith:(AMQPBasicProperties *)properties bodySize:(NSUInteger)bodySize {
    self = [super init];
    if(self){
        self.properties = properties;
        self.classId = AMQP_BASIC_PROPERTIES_CLASS_ID;
        self.weight = 0;
        self.bodySize = bodySize;
    }
    return self;
}
@end