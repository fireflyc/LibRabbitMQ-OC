//
// Created by fireflyc on 15/5/30.
// Copyright (c) 2015 fireflyc. All rights reserved.
//

#import "AMQPStream.h"
#import "AMQP.h"

NSString * const MQUnknownTypeKey = @"MQUnknownType";

@implementation AMQPOutputStream {
}
- (void)AMQPWriteUInt8:(UInt8)val {
    size_t bytes = 1;
    [self.data appendBytes:&val length:bytes];
}

- (void)AMQPWriteUInt16:(UInt16)val {
    size_t bytes = 2;
    val = htons(val);
    [self.data appendBytes:&val length:bytes];
}

- (void)AMQPWriteUInt32:(UInt32)val {
    size_t bytes = 4;
    val = htonl(val);
    [self.data appendBytes:&val length:bytes];
}

- (void)AMQPWriteUInt64:(UInt64)val {
    size_t bytes = 8;
    val = htonll(val);
    [self.data appendBytes:&val length:bytes];
}

- (void)AMQPWriteData:(NSData *)data {
    [self.data appendBytes:data.bytes length:data.length];
}

- (void)AMQPWriteProperties:(AMQPBasicProperties *)properties {
    AMQPOutputStream *tmp = [AMQPOutputStream new];
    UInt16 headerBits = 0;
    if (properties.contentType != nil) {
        headerBits |= (1 << 15);
        [tmp AMQPWriteShortStr:properties.contentType];
    }
    if (properties.contentEncoding != nil) {
        headerBits |= (1 << 14);
        [tmp AMQPWriteShortStr:properties.contentEncoding];
    }
    if (properties.headers != nil) {
        headerBits |= (1 << 13);
        [tmp AMQPWriteNSDictionary:properties.headers];
    }
    if (properties.deliveryMode != 0) {
        headerBits |= (1 << 12);
        [tmp AMQPWriteUInt8:properties.deliveryMode];
    }
    if (properties.priority != 0) {
        headerBits |= (1 << 11);
        [tmp AMQPWriteUInt8:properties.priority];
    }
    if (properties.correlationId != nil) {
        headerBits |= (1 << 10);
        [tmp AMQPWriteShortStr:properties.correlationId];
    }
    if (properties.replyTo != nil) {
        headerBits |= (1 << 9);
        [tmp AMQPWriteShortStr:properties.replyTo];
    }
    if (properties.expiration != nil) {
        headerBits |= (1 << 8);
        [tmp AMQPWriteShortStr:properties.expiration];
    }
    if (properties.messageId != nil) {
        headerBits |= (1 << 7);
        [tmp AMQPWriteShortStr:properties.messageId];
    }
    if (properties.timestamp != nil) {
        headerBits |= (1 << 6);
        [tmp AMQPWriteDate:properties.timestamp];
    }
    if (properties.type != nil) {
        headerBits |= (1 << 5);
        [tmp AMQPWriteShortStr:properties.type];
    }
    if (properties.userId != nil) {
        headerBits |= (1 << 4);
        [tmp AMQPWriteShortStr:properties.userId];
    }
    if (properties.appId != nil) {
        headerBits |= (1 << 3);
        [tmp AMQPWriteShortStr:properties.appId];
    }
    if (properties.clusterId != nil) {
        headerBits |= (1 << 2);
        [tmp AMQPWriteShortStr:properties.clusterId];
    }
    [self AMQPWriteUInt16:headerBits];
    [self AMQPWriteData:tmp.data];
}


- (void)AMQPWriteShortStr:(NSString *)val {
    if (val == nil) {
        [self AMQPWriteUInt8:0];
        return;
    }
    NSData *strData = [val dataUsingEncoding:NSUTF8StringEncoding];
    [self AMQPWriteUInt8:(UInt8) strData.length];
    [self.data appendBytes:strData.bytes length:strData.length];
}

- (void)AMQPWriteLongStr:(NSString *)val {
    if (val == nil) {
        [self AMQPWriteUInt32:0];
        return;
    }
    NSData *strData = [val dataUsingEncoding:NSUTF8StringEncoding];
    [self AMQPWriteUInt32:(UInt32) strData.length];
    [self.data appendBytes:strData.bytes length:strData.length];
}

- (void)AMQPWriteDate:(NSDate *)date {
    UInt64 times = [date timeIntervalSince1970];
    [self AMQPWriteUInt64:times];
}

- (void)AMQPWriteNSArray:(NSArray *)val {
    UInt32 size = val.count;
    AMQPOutputStream *arrayOut = [AMQPOutputStream new];
    for (id obj in val) {
        [arrayOut AMQPWriteElement:obj];
    }
    [self AMQPWriteUInt32:size];
    if (size > 0) {
        [self AMQPWriteData:arrayOut.data];
    }
}

- (void)AMQPWriteNSDictionary:(NSDictionary *)val {
    UInt32 len = 0;
    AMQPOutputStream *dictOut = [AMQPOutputStream new];
    for (NSString *key in [val allKeys]){
        [dictOut AMQPWriteShortStr:key];
        [dictOut AMQPWriteElement:val[key]];
    }
    len = dictOut.data.length;
    [self AMQPWriteUInt32:len];
    if (len > 0) {
        [self AMQPWriteData:dictOut.data];
    }
}

- (void)AMQPWriteElement:(id)obj {
    if (obj == nil || obj == [NSNull null]) {
        [self AMQPWriteUInt8:'V'];
        return;
    }
    if ([obj isKindOfClass:[NSString class]]) {
        [self AMQPWriteUInt8:'S'];
        [self AMQPWriteLongStr:obj];
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        NSNumber *number = obj;
        if ((id)number == (id)kCFBooleanTrue || (id)number == (id)kCFBooleanFalse) {
            [self AMQPWriteUInt8:'b'];
            [self AMQPWriteUInt8:number.boolValue];
            return;
        }
        CFNumberType numberType = CFNumberGetType((__bridge CFNumberRef)number);
        switch (numberType)	{
            case kCFNumberFloat32Type:
            case kCFNumberFloatType:
            case kCFNumberCGFloatType: {
                [self AMQPWriteUInt8:'f'];
                [self AMQPWriteUInt32:number.floatValue];
            }
                return;
            case kCFNumberFloat64Type:
            case kCFNumberDoubleType: {
                [self AMQPWriteUInt8:'d'];
                [self AMQPWriteUInt64:number.doubleValue];
            }
                return;
            default:
                break;
        }
        [self AMQPWriteUInt8:'l'];
        if ([number compare:@(0)] >= 0) {
            [self AMQPWriteUInt64:number.unsignedLongLongValue];
        } else {
            [self AMQPWriteUInt64:number.longLongValue];
        }
    } else if ([obj isKindOfClass:[NSDate class]]) {
        [self AMQPWriteUInt8:'T'];
        [self AMQPWriteDate:obj];
    } else if ([obj isKindOfClass:[NSData class]]) {
        [self AMQPWriteUInt8:'x'];
        [self AMQPWriteUInt32:((NSData *)obj).length];
        [self AMQPWriteData:obj];
    } else if ([obj isKindOfClass:[NSDictionary class]]) {
        [self AMQPWriteUInt8:'F'];
        [self AMQPWriteNSDictionary:obj];
    } else if ([obj isKindOfClass:[NSArray class]]) {
        [self AMQPWriteUInt8:'A'];
        [self AMQPWriteNSArray:obj];
    } else {
        NSString *reason = [NSString stringWithFormat:@"Unable to write object: %@", [obj class]];
        @throw [NSException exceptionWithName:@"AMQPWriteException" reason:reason userInfo:@{MQUnknownTypeKey: obj}];
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.data = [NSMutableData new];
    }
    return self;
}
@end

@implementation AMQPInputStream {
    size_t offset_;
}

- (UInt8)AMQPReadUInt8 {
    size_t bytes = 1;
    UInt8 val;
    memcpy(&val, (char *) self.data.bytes + offset_, bytes);
    offset_ += bytes;
    return val;
}

- (UInt16)AMQPReadUInt16 {
    size_t bytes = 2;
    UInt16 val;
    memcpy(&val, (char *) self.data.bytes + offset_, bytes);
    offset_ += bytes;
    return ntohs(val);
}

- (UInt32)AMQPReadUInt32 {
    size_t bytes = 4;
    UInt32 val;
    memcpy(&val, (char *) self.data.bytes + offset_, bytes);
    offset_ += bytes;
    return ntohl(val);
}

- (UInt64)AMQPReadUInt64 {
    size_t bytes = 8;
    UInt64 val;
    memcpy(&val, (char *) self.data.bytes + offset_, bytes);
    offset_ += bytes;
    return ntohll(val);
}

- (NSString *)AMQPReadShortStr {
    UInt8 len = [self AMQPReadUInt8];
    NSString *r = [[NSString alloc] initWithBytes:self.data.bytes + offset_ length:len encoding:NSUTF8StringEncoding];
    offset_ += len;
    return r;
}

- (NSString *)AMQPReadLongStr {
    UInt32 len = [self AMQPReadUInt32];
    NSString *r = [[NSString alloc] initWithBytes:self.data.bytes + offset_ length:len encoding:NSUTF8StringEncoding];
    offset_ += len;
    return r;
}

- (NSDate *)AMQPReadDate {
    UInt64 secs = [self AMQPReadUInt64] * 1000;
    return [NSDate dateWithTimeIntervalSince1970:secs];
}

- (NSDictionary *)AMQPReadNSDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    UInt32 len = [self AMQPReadUInt32];
    AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:[NSData dataWithBytes:self.data.bytes + offset_
                                                                                        length:len]];

    while ([inputStream hasNext]) {
        NSString *key = [inputStream AMQPReadShortStr];
        id val = [self readValueWith:inputStream];
        if (val) {
            [dictionary setValue:val forKey:key];
        }
    }
    offset_ += len;
    return dictionary;
}

- (id)readValueWith:(AMQPInputStream *)inputStream {
    UInt8 type = [inputStream AMQPReadUInt8];
    switch (type) {
        case 'S': {
            return [inputStream AMQPReadLongStr];
        }
        case 'I': {
            return @([inputStream AMQPReadUInt32]);
        }
        case 'D': {
            UInt8 scale = [inputStream AMQPReadUInt8];
            UInt32 unscaled = [inputStream AMQPReadUInt32];
            break;
        }
        case 'T': {
            UInt64 secs = [inputStream AMQPReadUInt64] * 1000;
            return [NSDate dateWithTimeIntervalSince1970:secs];
        }
        case 'F': {
            return [inputStream AMQPReadNSDictionary];
        }
        case 'A': {
            UInt32 arrayLen = [inputStream AMQPReadUInt32];
            AMQPInputStream *arrayInputStream = [[AMQPInputStream alloc] initWithData:
                    [NSData dataWithBytes:inputStream.data.bytes + offset_ length:arrayLen]];
            [inputStream AMQPReadBytesWithLen:arrayLen];
            NSMutableArray *array = [NSMutableArray new];
            while ([arrayInputStream hasNext]) {
                [array addObject:[self readValueWith:inputStream]];
            }
            return array;
        }
        case 'b': {
            return @([inputStream AMQPReadUInt8]);
        }
        case 'd': {
            return @([inputStream AMQPReadUInt64]);
        }
        case 'f': {
            return @([inputStream AMQPReadUInt32]);
        }
        case 'l': {
            return @([inputStream AMQPReadUInt64]);
        }
        case 's': {
            return @([inputStream AMQPReadUInt16]);
        }
        case 't': {
            return @([inputStream AMQPReadUInt8]);
        }
        case 'x': {
            return [inputStream AMQPReadLongStr];
        }
        case 'V': {
            break;
        }
        default: {
            break;
        }
    }
    return nil;
}

- (AMQPBasicProperties *)AMQPReadProperties {
    AMQPBasicProperties *basicProperties = [AMQPBasicProperties new];
    UInt16 headerBits = [self AMQPReadUInt16];
    BOOL contentTypePresent = (headerBits & (1 << 15)) ? TRUE : FALSE;
    BOOL contentEncodingPresent = (headerBits & (1 << 14)) ? TRUE : FALSE;
    BOOL headersPresent = (headerBits & (1 << 13)) ? TRUE : FALSE;
    BOOL deliveryModePresent = (headerBits & (1 << 12)) ? TRUE : FALSE;
    BOOL priorityPresent = (headerBits & (1 << 11)) ? TRUE : FALSE;
    BOOL correlationIdPresent = (headerBits & (1 << 10)) ? TRUE : FALSE;
    BOOL replyToPresent = (headerBits & (1 << 9)) ? TRUE : FALSE;
    BOOL expirationPresent = (headerBits & (1 << 8)) ? TRUE : FALSE;
    BOOL messageIdPresent = (headerBits & (1 << 7)) ? TRUE : FALSE;
    BOOL timestampPresent = (headerBits & (1 << 6)) ? TRUE : FALSE;
    BOOL typePresent = (headerBits & (1 << 5)) ? TRUE : FALSE;
    BOOL userIdPresent = (headerBits & (1 << 4)) ? TRUE : FALSE;
    BOOL appIdPresent = (headerBits & (1 << 3)) ? TRUE : FALSE;
    BOOL clusterIdPresent = (headerBits & (1 << 2)) ? TRUE : FALSE;

    basicProperties.contentType = contentTypePresent ? [self AMQPReadShortStr] : nil;
    basicProperties.contentEncoding = contentEncodingPresent ? [self AMQPReadShortStr] : nil;
    basicProperties.headers = headersPresent ? [self AMQPReadNSDictionary] : nil;
    basicProperties.deliveryMode = deliveryModePresent ? [self AMQPReadUInt8] : (UInt8) 0;
    basicProperties.priority = priorityPresent ? [self AMQPReadUInt8] : (UInt8) 0;
    basicProperties.correlationId = correlationIdPresent ? [self AMQPReadShortStr] : nil;
    basicProperties.replyTo = replyToPresent ? [self AMQPReadShortStr] : nil;
    basicProperties.expiration = expirationPresent ? [self AMQPReadShortStr] : nil;
    basicProperties.messageId = messageIdPresent ? [self AMQPReadShortStr] : nil;
    basicProperties.timestamp = timestampPresent ? [self AMQPReadDate] : nil;
    basicProperties.type = typePresent ? [self AMQPReadShortStr] : nil;
    basicProperties.userId = userIdPresent ? [self AMQPReadShortStr] : nil;
    basicProperties.appId = appIdPresent ? [self AMQPReadShortStr] : nil;
    basicProperties.clusterId = clusterIdPresent ? [self AMQPReadShortStr] : nil;
    return basicProperties;
}

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        self.data = data;
    }
    return self;
}

- (char *)AMQPReadBytesWithLen:(size_t)len {
    char *bytes = (char *) self.data.bytes + offset_;
    offset_ += len;
    return bytes;
}

- (void)reset {
    offset_ = 0;
}

- (void)resetToOffset:(size_t)offset {
    offset_ = offset;
}


- (BOOL)hasNext {
    return offset_ < self.data.length;
}

@end