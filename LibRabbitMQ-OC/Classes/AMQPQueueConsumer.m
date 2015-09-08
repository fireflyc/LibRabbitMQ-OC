//
// Created by fireflyc on 15/6/11.
// Copyright (c) 2015 Telecom. All rights reserved.
//

#import "AMQPQueueConsumer.h"
#import "BlockingQueue.h"


@implementation AMQPQueueConsumer {

}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.blockingQueue = [BlockingQueue new];
    }
    return self;
}


- (void)handleDelivery:(NSString *)consumerTag envelope:(Envelope *)envelope properties:(AMQPBasicProperties *)properties
                  body:(NSData *)body {
    AMQPMessage *message = [[AMQPMessage alloc] initWithConsumerTag:consumerTag envelope:envelope properties:properties
                                                               body:body];
    [self.blockingQueue push:message];
}

- (AMQPMessage *)popWithTimeout:(NSTimeInterval)second {
    return [self.blockingQueue popWithTimeout:second];
}
@end