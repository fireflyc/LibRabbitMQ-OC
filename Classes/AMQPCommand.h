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
#import "AMQPFrame.h"

@class AMQPContentHeader;

typedef NS_ENUM(NSInteger, AMQPCommandState) {
    AMQPCommandStateExpectingMethod,
    AMQPCommandStateExpectingContentHeader,
    AMQPCommandStateExpectingContentBody,
    AMQPCommandStateExpectingComplete
};

@interface AMQPCommand : NSObject
- (instancetype)init;

- (instancetype)initWithMethod:(AMQPMethod *)method;

- (instancetype)initWithMethod:(AMQPMethod *)method contentHeader:(AMQPContentHeader *)content contentBody:(NSMutableData *)body;

- (BOOL)handlerFrame:(AMQPFrame *)frame;

- (void)reset;

+ (AMQPCommand *)commandWithMethod:(AMQPMethod *)open;

- (void)consumeMethodFrame:(AMQPFrame *)frame;

- (void)consumeHeaderFrame:(AMQPFrame *)frame;

- (void)consumeBodyFrame:(AMQPFrame *)frame;

- (BOOL)isComplete;

@property AMQPMethod *method;
@property AMQPContentHeader *header;
@property NSMutableData *body;
@property UInt64 remainingBodyBytes;

@property AMQPCommandState state;
@end