//
// Created by fireflyc 
//

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