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

@interface Envelope : NSObject
@property UInt64 deliveryTag;
@property BOOL redelivered;
@property NSString *exchange;
@property NSString *routingKey;
@end

@interface AMQPMessage:NSObject
@property NSString *consumerTag;
@property NSData *body;
@property Envelope *envelope;
@property AMQPBasicProperties *properties;
- (instancetype)initWithConsumerTag:(NSString *)consumerTag envelope:(Envelope *)envelope properties:(AMQPBasicProperties *)properties
                 body:(NSData *)body ;

@end

@protocol AMQPConsumerDelegate
- (void)handleDelivery:(NSString *)consumerTag envelope:(Envelope *)envelope properties:(AMQPBasicProperties *)properties
                  body:(NSData *)body;

@optional
- (void)handleConsumeOk:(NSString *)consumerTag;

- (void)handleCancelOk:(NSString *)consumerTag;

- (void)handleCancel:(NSString *)consumerTag;

@end

@interface AMQPConsume : NSObject
- (instancetype)initWithDelegate:(id)delegate;

@property id delegate;

- (BOOL)handlerFrame:(AMQPFrame *)frame;

- (void)handleConsumeOk:(NSString *)consumerTag;

- (void)handleCancelOk:(NSString *)consumerTag;

- (void)handleCancel:(NSString *)consumerTag;
@end