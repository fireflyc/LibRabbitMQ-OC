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