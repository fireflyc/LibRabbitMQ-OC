//
// Created by fireflyc on 15/6/5.
// Copyright (c) 2015 fireflyc. All rights reserved.
//

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