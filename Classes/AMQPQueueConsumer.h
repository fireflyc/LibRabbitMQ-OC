//
// Created by fireflyc 
//

#import <Foundation/Foundation.h>
#import "AMQPConsume.h"

@class BlockingQueue;


@interface AMQPQueueConsumer : NSObject <AMQPConsumerDelegate>
@property BlockingQueue *blockingQueue;

- (AMQPMessage *)popWithTimeout:(NSTimeInterval)second;
@end