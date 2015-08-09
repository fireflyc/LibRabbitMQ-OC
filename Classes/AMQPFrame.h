/*
 * Copyright 2015 The original authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * @author fireflyc
 */

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