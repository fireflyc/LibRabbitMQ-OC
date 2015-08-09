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

@class AMQPBasicProperties;


@interface AMQPOutputStream : NSObject

- (void)AMQPWriteUInt8:(UInt8)val;

- (void)AMQPWriteUInt16:(UInt16)val;

- (void)AMQPWriteUInt32:(UInt32)val;

- (void)AMQPWriteUInt64:(UInt64)val;

- (void)AMQPWriteShortStr:(NSString *)val;

- (void)AMQPWriteLongStr:(NSString *)val;

- (void)AMQPWriteNSDictionary:(NSDictionary *)val;

- (void)AMQPWriteData:(NSData *)data;

- (void)AMQPWriteProperties:(AMQPBasicProperties *)properties;

- (instancetype)init;

@property NSMutableData *data;

- (void)AMQPWriteDate:(NSDate *)date;
@end

@interface AMQPInputStream : NSObject
- (UInt8)AMQPReadUInt8;

- (UInt16)AMQPReadUInt16;

- (UInt32)AMQPReadUInt32;

- (UInt64)AMQPReadUInt64;

- (NSString *)AMQPReadShortStr;

- (NSString *)AMQPReadLongStr;

- (NSDate *)AMQPReadDate;

- (NSDictionary *)AMQPReadNSDictionary;

- (AMQPBasicProperties *)AMQPReadProperties;

- (instancetype)initWithData:(NSData *)data;

- (char *)AMQPReadBytesWithLen:(size_t)len;

- (void)reset;

- (void)resetToOffset:(size_t)offset;

@property NSData *data;
@end