//
// Created by fireflyc on 15/5/31.
// Copyright (c) 2015 fireflyc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMQPConnection.h"
#import "BlockingQueue.h"
#import "AMQPCommand.h"
#import "AMQPConsume.h"

@class AMQPConnection;

@interface AMQPChannel : NSObject
- (instancetype)initWithChannel:(UInt16)channel connection:(AMQPConnection *)connection;

- (BOOL)open:(NSError **)error;

- (BOOL)close;

- (BOOL)queueDeclare:(NSString *)theName isDurable:(BOOL)durable isExclusive:(BOOL)exclusive autoDeleted:(BOOL)autoDelete
           isPassive:(BOOL)passive arguments:(NSDictionary *)arguments nowait:(BOOL)nowait queueDeclareOk:(QueueDeclareOk **)ok
               error:(NSError **)error;

- (BOOL)queueDeclare:(NSString *)queue isDurable:(BOOL)durable isExclusive:(BOOL)exclusive autoDeleted:(BOOL)deleted
           arguments:(NSDictionary *)arguments queueDeclareOk:(QueueDeclareOk **)ok error:(NSError **)error;

- (BOOL)queueDeclare:(NSString *)queue isDurable:(BOOL)durable isExclusive:(BOOL)exclusive autoDeleted:(BOOL)deleted
           arguments:(NSDictionary *)arguments error:(NSError **)error;

- (BOOL)queueDeclare:(NSString *)queue isDurable:(BOOL)durable isExclusive:(BOOL)exclusive autoDeleted:(BOOL)deleted
               error:(NSError **)error;

- (BOOL)exchangeDeclareOfType:(NSString *)theType withName:(NSString *)theName
                    isPassive:(BOOL)passive isDurable:(BOOL)durable autoDelete:(BOOL)autoDelete nowait:(BOOL)nowait
                        error:(NSError **)error;

- (BOOL)directExchangeWithName:(NSString *)theName isPassive:(BOOL)passive isDurable:(BOOL)durable
                    autoDelete:(BOOL)autoDelete error:(NSError **)error;

- (BOOL)topicExchangeWithName:(NSString *)theName isPassive:(BOOL)passive isDurable:(BOOL)durable
                   autoDelete:(BOOL)autoDelete error:(NSError **)error;

- (BOOL)fanoutExchangeWithName:(NSString *)theName isPassive:(BOOL)passive isDurable:(BOOL)durable
                    autoDelete:(BOOL)autoDelete error:(NSError **)error;

- (BOOL)exchangeWithName:(NSString *)theName error:(NSError **)error;

- (BOOL)basicPublishMessage:(NSString *)exchangeName usingRoutingKey:(NSString *)theRoutingKey body:(NSData *)body
                      error:(NSError **)error;

- (BOOL)basicPublishMessage:(NSString *)exchangeName usingRoutingKey:(NSString *)theRoutingKey properties:(AMQPBasicProperties *)properties body:(NSData *)body error:(NSError **)error;

- (NSString *)basicConsume:(NSString *)queue autoAck:(BOOL)autoAck consumerTag:(NSString *)consumerTag
                   noLocal:(BOOL)noLocal exclusive:(BOOL)exclusive arguments:(NSDictionary *)arguments
                  delegate:(id <AMQPConsumerDelegate>)delegate error:(NSError **)error;

- (NSString *)basicConsume:(NSString *)queue delegate:(id <AMQPConsumerDelegate>)delegate error:(NSError **)error;

- (NSString *)basicConsume:(NSString *)queue autoAck:(BOOL)autoAck delegate:(id <AMQPConsumerDelegate>)delegate error:(NSError **)error;

- (BOOL)basicCancel:(NSString *)consumerTag error:(NSError **)error;

- (void)basicAck:(UInt64)deliveryTag multiple:(BOOL)multiple error:(NSError **)error;

- (BOOL)basicQos:(UInt32)prefetchSize error:(NSError **)error;

- (BOOL)basicQos:(UInt32)prefetchSize prefetchCount:(UInt16)prefetchCount global:(BOOL)global error:(NSError **)error;

- (void)basicNAck:(UInt64)deliveryTag multiple:(BOOL)multiple requeue:(BOOL)requeue error:(NSError **)error;

- (AMQPCommand *)readCommandWitQueue:(BlockingQueue *)queue error:(NSError **)error;

- (BOOL)writeCommand:(AMQPCommand *)command error:(NSError **)error;

- (AMQPCommand *)rpcCommand:(AMQPCommand *)command error:(NSError **)error;

- (BOOL)writeFrame:(AMQPFrame *)frame error:(NSError **)error;

- (void)receiveFrame:(AMQPFrame *)frame;

- (void)receiveWriteOk:(long)tag;

- (void)enqueueRpc:(BlockingQueue *)blockingQueue;

- (void)nextOutstandingRpc;

- (BOOL)queueDeclareForRPC:(QueueDeclareOk **)queueDeclareOk error:(NSError **)error;

- (BOOL)queueBind:(NSString *)queue exchange:(NSString *)exchange routingKey:(NSString *)routingKey nowait:(BOOL)nowait error:(NSError **)error;

- (BOOL)queueBind:(NSString *)queue exchange:(NSString *)exchange routingKey:(NSString *)key error:(NSError **)error;

- (BOOL)queueUnbind:(NSString *)queue exchange:(NSString *)exchange routingKey:(NSString *)routingKey arguments:(NSDictionary *)arguments error:(NSError **)error;

- (BOOL)queueUnbind:(NSString *)queue exchange:(NSString *)exchange routingKey:(NSString *)key error:(NSError **)error;

- (BOOL)exchangeBind:(NSString *)destination source:(NSString *)source routingKey:(NSString *)routingKey nowait:(BOOL)nowait error:(NSError **)error;

- (BOOL)exchangeBind:(NSString *)destination source:(NSString *)source routingKey:(NSString *)routingKey error:(NSError **)error;

- (BOOL)exchangeUnbind:(NSString *)destination source:(NSString *)source routingKey:(NSString *)routingKey nowait:(BOOL)nowait error:(NSError **)error;

- (BOOL)exchangeUnbind:(NSString *)destination source:(NSString *)source routingKey:(NSString *)routingKey error:(NSError **)error;
@end