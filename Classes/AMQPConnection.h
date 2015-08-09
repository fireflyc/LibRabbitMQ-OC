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