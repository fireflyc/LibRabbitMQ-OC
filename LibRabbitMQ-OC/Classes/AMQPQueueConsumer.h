//
// Created by fireflyc on 15/6/11.
// Copyright (c) 2015 Telecom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMQPConsume.h"

@class BlockingQueue;


@interface AMQPQueueConsumer : NSObject <AMQPConsumerDelegate>
@property BlockingQueue *blockingQueue;

- (AMQPMessage *)popWithTimeout:(NSTimeInterval)second;
@end