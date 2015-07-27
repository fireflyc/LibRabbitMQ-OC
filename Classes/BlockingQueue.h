//
// Created by fireflyc 
//

#import <Foundation/Foundation.h>

@interface BlockingQueue : NSObject
- (instancetype)init;

- (instancetype)initWithCapacity:(NSUInteger)capacity;

- (BOOL)push:(id)val;

- (id)popWithTimeout:(NSTimeInterval)second;

- (void)clear;
@end