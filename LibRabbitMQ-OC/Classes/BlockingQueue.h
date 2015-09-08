//
// Created by fireflyc on 15/6/1.
// Copyright (c) 2015 fireflyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlockingQueue : NSObject
- (instancetype)init;

- (instancetype)initWithCapacity:(NSUInteger)capacity;

- (BOOL)push:(id)val;

- (id)popWithTimeout:(NSTimeInterval)second;

- (void)clear;
@end