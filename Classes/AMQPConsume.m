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

#import "AMQPConsume.h"
#import "AMQPCommand.h"

@interface AMQPConsume ()
@property AMQPCommand *command;
@end

@implementation AMQPConsume {

}
- (instancetype)initWithDelegate:(id)delegate {
    self = [super init];
    if (self) {
        self.command = [[AMQPCommand alloc] init];
        self.delegate = delegate;
    }
    return self;
}

- (BOOL)handlerFrame:(AMQPFrame *)frame {
    if ([self.command handlerFrame:frame]) {
        [self.command reset];
        Envelope *envelope = [[Envelope alloc] init];
        BasicDeliver *deliver = (BasicDeliver *) self.command.method;

        envelope.deliveryTag = deliver.deliveryTag;
        envelope.exchange = deliver.exchange;
        envelope.redelivered = deliver.redelivered;
        envelope.routingKey = deliver.routingKey;

        [self.delegate handleDelivery:deliver.consumerTag envelope:envelope properties:self.command.header.properties
                                 body:self.command.body];
        self.command.body = [NSMutableData new];
        return TRUE;
    }
    return FALSE;
}

- (void)handleConsumeOk:(NSString *)consumerTag {
    if ([self.delegate respondsToSelector:@selector(handleConsumeOk:)]) {
        [self.delegate handleConsumeOk:consumerTag];
    }
}

- (void)handleCancelOk:(NSString *)consumerTag {
    if ([self.delegate respondsToSelector:@selector(handleCancelOk:)]) {
        [self.delegate handleCancelOk:consumerTag];
    }
}

- (void)handleCancel:(NSString *)consumerTag {
    if ([self.delegate respondsToSelector:@selector(handleCancel:)]) {
        [self.delegate handleCancel:consumerTag];
    }
}

@end

@implementation AMQPMessage {

}
- (instancetype)initWithConsumerTag:(NSString *)consumerTag envelope:(Envelope *)envelope properties:(AMQPBasicProperties *)properties
                               body:(NSData *)body {

    self = [super init];
    if (self) {
        self.body = body;
        self.envelope = envelope;
        self.properties = properties;
        self.consumerTag = consumerTag;
    }
    return self;
}
@end;