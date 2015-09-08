//
// Created by fireflyc on 15/6/1.
// Copyright (c) 2015 fireflyc. All rights reserved.
//

#import "BlockingQueue.h"

@interface BlockingQueue ()
@property dispatch_semaphore_t emptySemaphore;
@property NSUInteger capacity;
@property NSMutableArray *data;
@end

@implementation BlockingQueue {

}
- (instancetype)init {
    return [self initWithCapacity:1];
}

- (instancetype)initWithCapacity:(NSUInteger)capacity {
    self = [super init];
    if (self) {
        self.data = [[NSMutableArray alloc] init];
        self.capacity = capacity;
        self.emptySemaphore = dispatch_semaphore_create(0);
    }
    return self;
}

- (BOOL)push:(id)val {
    NSUInteger queueCount = [self.data count];
    if (queueCount >= self.capacity) {
        return FALSE;
    }
    [self.data addObject:val];
    if (queueCount == 0) {
        dispatch_semaphore_signal(self.emptySemaphore);
    }
    return TRUE;
}

- (id)popWithTimeout:(NSTimeInterval)second {
    if ([self.data count] == 0) {
        dispatch_time_t tt = DISPATCH_TIME_FOREVER;
        if (second > 0) {
            tt = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (second * NSEC_PER_SEC));
        }
        if (dispatch_semaphore_wait(self.emptySemaphore, tt) != 0) {
            return nil;
        }
    }
    id popObj = [self.data lastObject];
    [self.data removeLastObject];
    return popObj;
}


- (void)clear {
    [self.data removeAllObjects];
}
@end