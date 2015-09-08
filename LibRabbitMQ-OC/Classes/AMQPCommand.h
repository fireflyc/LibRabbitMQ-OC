//
// Created by fireflyc on 15/6/4.
// Copyright (c) 2015 fireflyc. All rights reserved.
//

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