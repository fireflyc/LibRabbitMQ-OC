//
// Created by fireflyc on 15/5/28.
// Copyright (c) 2015 fireflyc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMQP.h"
#import "AMQPFrame.h"
#import "AMQPStream.h"
#import "AMQPChannel.h"
#import "AMQPCommand.h"
#import "GCDAsyncSocket.h"

@class AMQPConnection;
@class AMQPChannel;

@protocol AMQPConnectionLifecycleDelegate
- (void)reconnectionSuccess:(NSString *)userName :(AMQPConnection *)connection;
@end

@interface AMQPConnection : NSObject <GCDAsyncSocketDelegate>
@property GCDAsyncSocket *socket;
@property NSTimeInterval writeTimeout;
@property NSTimeInterval readTimeout;
@property UInt32 maxFrame;
@property BOOL isLogin;
@property(nonatomic, strong) NSString *vHost;
@property(nonatomic, strong) NSString *password;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, weak) id <AMQPConnectionLifecycleDelegate> lifecycleDelegate;

- (instancetype)initWithHost:(NSString *)host port:(UInt16)port heartbeat:(UInt16)heartbeat
                    userName:(NSString *)userName password:(NSString *)password vHost:(NSString *)vHost
           lifecycleDelegate:(id <AMQPConnectionLifecycleDelegate>)lifecycleDelegate;

- (BOOL)connectionWithTimeout:(NSTimeInterval)timeout error:(NSError **)error;

- (AMQPChannel *)openChannel:(NSError **)error;

- (NSError *)AMQPErrorWith:(NSString *)errMsg code:(UInt16)code;

- (NSError *)AMQPErrorWith:(NSString *)errMsg;

- (BOOL)checkReplyCommand:(AMQPCommand *)command error:(NSError **)error;

- (void)writeData:(NSData *)data tag:(long)tag;

- (void)logout;

- (void)stopHeartbeat;

- (void)startHeartbeat;

- (void)shutdownHeartbeat;
@end