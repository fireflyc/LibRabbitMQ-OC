//
// Created by fireflyc on 15/5/30.
// Copyright (c) 2015 fireflyc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMQP.h"
#import "AMQPStream.h"

typedef NS_ENUM(NSInteger, AMQPFramePayloadType) {
    AMQPFramePayloadTypeMethod,
    AMQPFramePayloadTypeHeader,
    AMQPFramePayloadTypeBody
};

@interface AMQPContentHeader:NSObject
@property UInt16 classId;
@property UInt16 weight; //unused
@property AMQPBasicProperties *properties;
@property UInt64 bodySize;

- (id)initWith:(AMQPBasicProperties *)properties bodySize:(NSUInteger)bodySize;
@end


@interface AMQPFrame : NSObject
@property UInt8 frameType;
@property UInt16 channelNumber;
@property AMQPFramePayloadType payloadType;
@property UInt32 payloadSize;
@property id payload;

- (instancetype)initWithFrameType:(UInt8)frameType channelNumber:(UInt16)channelNumber
                      payloadType:(AMQPFramePayloadType)payloadType payload:(id)payload;

- (void)writeOutputStream:(AMQPOutputStream *)stream maxFrame:(UInt32)maxFrame;
@end