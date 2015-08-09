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

#import "AMQPCommand.h"


@implementation AMQPCommand {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.state = AMQPCommandStateExpectingMethod;
        self.body = [NSMutableData new];
    }
    return self;
}

- (instancetype)initWithMethod:(AMQPMethod *)method {
    return [self initWithMethod:method contentHeader:NULL contentBody:[NSMutableData new]];
}

- (instancetype)initWithMethod:(AMQPMethod *)method contentHeader:(AMQPContentHeader *)header contentBody:(NSMutableData *)body {
    self = [super init];
    if (self) {
        self.method = method;
        self.header = header;
        self.state = AMQPCommandStateExpectingMethod;
        self.body = body;
    }
    return self;
}

+ (AMQPCommand *)commandWithMethod:(AMQPMethod *)method {
    return [[AMQPCommand alloc] initWithMethod:method];
}

- (void)reset {
    self.state = AMQPCommandStateExpectingMethod;
}

- (BOOL)handlerFrame:(AMQPFrame *)frame {
    switch (self.state) {
        case AMQPCommandStateExpectingMethod:
            [self consumeMethodFrame:frame];
            break;
        case AMQPCommandStateExpectingContentHeader:
            [self consumeHeaderFrame:frame];
            break;
        case AMQPCommandStateExpectingContentBody:
            [self consumeBodyFrame:frame];
            break;
        case AMQPCommandStateExpectingComplete:
            break;
    }
    return [self isComplete];
}

- (void)consumeMethodFrame:(AMQPFrame *)frame {
    if (frame.frameType == AMQP_FRAME_METHOD) {
        self.method = frame.payload;
        self.state = [self.method hasContent] ? AMQPCommandStateExpectingContentHeader : AMQPCommandStateExpectingComplete;
    }
}

- (void)consumeHeaderFrame:(AMQPFrame *)frame {
    if (frame.frameType == AMQP_FRAME_HEADER) {
        self.header = frame.payload;
        self.remainingBodyBytes = self.header.bodySize;
        self.state = (self.remainingBodyBytes > 0) ? AMQPCommandStateExpectingContentBody : AMQPCommandStateExpectingComplete;
    }
}

- (void)consumeBodyFrame:(AMQPFrame *)frame {
    if (frame.frameType == AMQP_FRAME_BODY) {
        NSMutableData *newBody = frame.payload;
        [self.body appendData:newBody];
        self.remainingBodyBytes -= newBody.length;
        self.state = (self.remainingBodyBytes > 0) ? AMQPCommandStateExpectingContentBody : AMQPCommandStateExpectingComplete;
    }
}

- (BOOL)isComplete {
    return self.state == AMQPCommandStateExpectingComplete;
}

@end