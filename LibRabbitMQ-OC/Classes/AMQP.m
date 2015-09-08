#import <Foundation/Foundation.h>

#import "AMQP.h"


@implementation AMQPMethod{

}
- (instancetype)initWithInputStream:(AMQPInputStream *)inputStream {
    self = [super init];
    if (self){
        self.amqpMethodClassId = [inputStream AMQPReadUInt16];
        self.amqpMethodId = [inputStream AMQPReadUInt16];
    }
    return self;
}

-(void)write:(AMQPOutputStream *)outputStream{
    [outputStream AMQPWriteUInt16:self.amqpMethodClassId];
    [outputStream AMQPWriteUInt16:self.amqpMethodId];
}

-(BOOL)hasContent{
    return FALSE;
}
@end

@implementation AMQPBasicProperties{
}
@end
@implementation AMQP{
}
+ (AMQPMethod *)readMethod:(AMQPInputStream *)inputStream {
	UInt16 classId = [inputStream AMQPReadUInt16];
	UInt16 methodNumber = [inputStream AMQPReadUInt16];
	[inputStream resetToOffset:AMQP_HEADER_SIZE];
	switch(classId){
		case 10:
			switch(methodNumber){
				case 10:
					 return [[ConnectionStart alloc] initWithInputStream:inputStream];
				case 11:
					 return [[ConnectionStartOk alloc] initWithInputStream:inputStream];
				case 20:
					 return [[ConnectionSecure alloc] initWithInputStream:inputStream];
				case 21:
					 return [[ConnectionSecureOk alloc] initWithInputStream:inputStream];
				case 30:
					 return [[ConnectionTune alloc] initWithInputStream:inputStream];
				case 31:
					 return [[ConnectionTuneOk alloc] initWithInputStream:inputStream];
				case 40:
					 return [[ConnectionOpen alloc] initWithInputStream:inputStream];
				case 41:
					 return [[ConnectionOpenOk alloc] initWithInputStream:inputStream];
				case 50:
					 return [[ConnectionClose alloc] initWithInputStream:inputStream];
				case 51:
					 return [[ConnectionCloseOk alloc] initWithInputStream:inputStream];
				case 60:
					 return [[ConnectionBlocked alloc] initWithInputStream:inputStream];
				case 61:
					 return [[ConnectionUnblocked alloc] initWithInputStream:inputStream];
				default:break;
			}
			default:break;
		}
	switch(classId){
		case 20:
			switch(methodNumber){
				case 10:
					 return [[ChannelOpen alloc] initWithInputStream:inputStream];
				case 11:
					 return [[ChannelOpenOk alloc] initWithInputStream:inputStream];
				case 20:
					 return [[ChannelFlow alloc] initWithInputStream:inputStream];
				case 21:
					 return [[ChannelFlowOk alloc] initWithInputStream:inputStream];
				case 40:
					 return [[ChannelClose alloc] initWithInputStream:inputStream];
				case 41:
					 return [[ChannelCloseOk alloc] initWithInputStream:inputStream];
				default:break;
			}
			default:break;
		}
	switch(classId){
		case 30:
			switch(methodNumber){
				case 10:
					 return [[AccessRequest alloc] initWithInputStream:inputStream];
				case 11:
					 return [[AccessRequestOk alloc] initWithInputStream:inputStream];
				default:break;
			}
			default:break;
		}
	switch(classId){
		case 40:
			switch(methodNumber){
				case 10:
					 return [[ExchangeDeclare alloc] initWithInputStream:inputStream];
				case 11:
					 return [[ExchangeDeclareOk alloc] initWithInputStream:inputStream];
				case 20:
					 return [[ExchangeDelete alloc] initWithInputStream:inputStream];
				case 21:
					 return [[ExchangeDeleteOk alloc] initWithInputStream:inputStream];
				case 30:
					 return [[ExchangeBind alloc] initWithInputStream:inputStream];
				case 31:
					 return [[ExchangeBindOk alloc] initWithInputStream:inputStream];
				case 40:
					 return [[ExchangeUnbind alloc] initWithInputStream:inputStream];
				case 51:
					 return [[ExchangeUnbindOk alloc] initWithInputStream:inputStream];
				default:break;
			}
			default:break;
		}
	switch(classId){
		case 50:
			switch(methodNumber){
				case 10:
					 return [[QueueDeclare alloc] initWithInputStream:inputStream];
				case 11:
					 return [[QueueDeclareOk alloc] initWithInputStream:inputStream];
				case 20:
					 return [[QueueBind alloc] initWithInputStream:inputStream];
				case 21:
					 return [[QueueBindOk alloc] initWithInputStream:inputStream];
				case 30:
					 return [[QueuePurge alloc] initWithInputStream:inputStream];
				case 31:
					 return [[QueuePurgeOk alloc] initWithInputStream:inputStream];
				case 40:
					 return [[QueueDelete alloc] initWithInputStream:inputStream];
				case 41:
					 return [[QueueDeleteOk alloc] initWithInputStream:inputStream];
				case 50:
					 return [[QueueUnbind alloc] initWithInputStream:inputStream];
				case 51:
					 return [[QueueUnbindOk alloc] initWithInputStream:inputStream];
				default:break;
			}
			default:break;
		}
	switch(classId){
		case 60:
			switch(methodNumber){
				case 10:
					 return [[BasicQos alloc] initWithInputStream:inputStream];
				case 11:
					 return [[BasicQosOk alloc] initWithInputStream:inputStream];
				case 20:
					 return [[BasicConsume alloc] initWithInputStream:inputStream];
				case 21:
					 return [[BasicConsumeOk alloc] initWithInputStream:inputStream];
				case 30:
					 return [[BasicCancel alloc] initWithInputStream:inputStream];
				case 31:
					 return [[BasicCancelOk alloc] initWithInputStream:inputStream];
				case 40:
					 return [[BasicPublish alloc] initWithInputStream:inputStream];
				case 50:
					 return [[BasicReturn alloc] initWithInputStream:inputStream];
				case 60:
					 return [[BasicDeliver alloc] initWithInputStream:inputStream];
				case 70:
					 return [[BasicGet alloc] initWithInputStream:inputStream];
				case 71:
					 return [[BasicGetOk alloc] initWithInputStream:inputStream];
				case 72:
					 return [[BasicGetEmpty alloc] initWithInputStream:inputStream];
				case 80:
					 return [[BasicAck alloc] initWithInputStream:inputStream];
				case 90:
					 return [[BasicReject alloc] initWithInputStream:inputStream];
				case 100:
					 return [[BasicRecoverAsync alloc] initWithInputStream:inputStream];
				case 110:
					 return [[BasicRecover alloc] initWithInputStream:inputStream];
				case 111:
					 return [[BasicRecoverOk alloc] initWithInputStream:inputStream];
				case 120:
					 return [[BasicNack alloc] initWithInputStream:inputStream];
				default:break;
			}
			default:break;
		}
	switch(classId){
		case 90:
			switch(methodNumber){
				case 10:
					 return [[TxSelect alloc] initWithInputStream:inputStream];
				case 11:
					 return [[TxSelectOk alloc] initWithInputStream:inputStream];
				case 20:
					 return [[TxCommit alloc] initWithInputStream:inputStream];
				case 21:
					 return [[TxCommitOk alloc] initWithInputStream:inputStream];
				case 30:
					 return [[TxRollback alloc] initWithInputStream:inputStream];
				case 31:
					 return [[TxRollbackOk alloc] initWithInputStream:inputStream];
				default:break;
			}
			default:break;
		}
	switch(classId){
		case 85:
			switch(methodNumber){
				case 10:
					 return [[ConfirmSelect alloc] initWithInputStream:inputStream];
				case 11:
					 return [[ConfirmSelectOk alloc] initWithInputStream:inputStream];
				default:break;
			}
			default:break;
		}
	return NULL;
};
@end
@implementation ConnectionStart{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 10;
		self.amqpMethodId = 10;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.versionMajor = [inputStream AMQPReadUInt8];
		self.versionMinor = [inputStream AMQPReadUInt8];
		self.serverProperties = [inputStream AMQPReadNSDictionary];
		self.mechanisms = [inputStream AMQPReadLongStr];
		self.locales = [inputStream AMQPReadLongStr];
	}
	return self;
}

- (instancetype)initWithVersionMajor:(UInt8)versionMajor versionMinor:(UInt8)versionMinor serverProperties:(NSDictionary *)serverProperties mechanisms:(NSString *)mechanisms locales:(NSString *)locales {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 10;
		self.amqpMethodId = 10;
		self.versionMajor = versionMajor;
		self.versionMinor = versionMinor;
		self.serverProperties = serverProperties;
		self.mechanisms = mechanisms;
		self.locales = locales;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteUInt8:self.versionMajor];
	[outputStream AMQPWriteUInt8:self.versionMinor];
	[outputStream AMQPWriteNSDictionary:self.serverProperties];
	[outputStream AMQPWriteLongStr:self.mechanisms];
	[outputStream AMQPWriteLongStr:self.locales];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation ConnectionStartOk{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 10;
		self.amqpMethodId = 11;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.clientProperties = [inputStream AMQPReadNSDictionary];
		self.mechanism = [inputStream AMQPReadShortStr];
		self.response = [inputStream AMQPReadLongStr];
		self.locale = [inputStream AMQPReadShortStr];
	}
	return self;
}

- (instancetype)initWithClientProperties:(NSDictionary *)clientProperties mechanism:(NSString *)mechanism response:(NSString *)response locale:(NSString *)locale {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 10;
		self.amqpMethodId = 11;
		self.clientProperties = clientProperties;
		self.mechanism = mechanism;
		self.response = response;
		self.locale = locale;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteNSDictionary:self.clientProperties];
	[outputStream AMQPWriteShortStr:self.mechanism];
	[outputStream AMQPWriteLongStr:self.response];
	[outputStream AMQPWriteShortStr:self.locale];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation ConnectionSecure{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 10;
		self.amqpMethodId = 20;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.challenge = [inputStream AMQPReadLongStr];
	}
	return self;
}

- (instancetype)initWithChallenge:(NSString *)challenge {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 10;
		self.amqpMethodId = 20;
		self.challenge = challenge;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteLongStr:self.challenge];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation ConnectionSecureOk{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 10;
		self.amqpMethodId = 21;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.response = [inputStream AMQPReadLongStr];
	}
	return self;
}

- (instancetype)initWithResponse:(NSString *)response {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 10;
		self.amqpMethodId = 21;
		self.response = response;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteLongStr:self.response];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation ConnectionTune{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 10;
		self.amqpMethodId = 30;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.channelMax = [inputStream AMQPReadUInt16];
		self.frameMax = [inputStream AMQPReadUInt32];
		self.heartbeat = [inputStream AMQPReadUInt16];
	}
	return self;
}

- (instancetype)initWithChannelMax:(UInt16)channelMax frameMax:(UInt32)frameMax heartbeat:(UInt16)heartbeat {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 10;
		self.amqpMethodId = 30;
		self.channelMax = channelMax;
		self.frameMax = frameMax;
		self.heartbeat = heartbeat;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteUInt16:self.channelMax];
	[outputStream AMQPWriteUInt32:self.frameMax];
	[outputStream AMQPWriteUInt16:self.heartbeat];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation ConnectionTuneOk{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 10;
		self.amqpMethodId = 31;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.channelMax = [inputStream AMQPReadUInt16];
		self.frameMax = [inputStream AMQPReadUInt32];
		self.heartbeat = [inputStream AMQPReadUInt16];
	}
	return self;
}

- (instancetype)initWithChannelMax:(UInt16)channelMax frameMax:(UInt32)frameMax heartbeat:(UInt16)heartbeat {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 10;
		self.amqpMethodId = 31;
		self.channelMax = channelMax;
		self.frameMax = frameMax;
		self.heartbeat = heartbeat;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteUInt16:self.channelMax];
	[outputStream AMQPWriteUInt32:self.frameMax];
	[outputStream AMQPWriteUInt16:self.heartbeat];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation ConnectionOpen{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 10;
		self.amqpMethodId = 40;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.virtualHost = [inputStream AMQPReadShortStr];
		self.capabilities = [inputStream AMQPReadShortStr];
		UInt8 bits = [inputStream AMQPReadUInt8];
		self.insist = (bits & (1 << 0)) ? TRUE : FALSE;
	}
	return self;
}

- (instancetype)initWithVirtualHost:(NSString *)virtualHost capabilities:(NSString *)capabilities insist:(BOOL)insist {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 10;
		self.amqpMethodId = 40;
		self.virtualHost = virtualHost;
		self.capabilities = capabilities;
		self.insist = insist;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteShortStr:self.virtualHost];
	[outputStream AMQPWriteShortStr:self.capabilities];
	UInt8 bits = 0;
	if(self.insist) bits |= (1<<0);
	[outputStream AMQPWriteUInt8:bits];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation ConnectionOpenOk{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 10;
		self.amqpMethodId = 41;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.knownHosts = [inputStream AMQPReadShortStr];
	}
	return self;
}

- (instancetype)initWithKnownHosts:(NSString *)knownHosts {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 10;
		self.amqpMethodId = 41;
		self.knownHosts = knownHosts;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteShortStr:self.knownHosts];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation ConnectionClose{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 10;
		self.amqpMethodId = 50;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.replyCode = [inputStream AMQPReadUInt16];
		self.replyText = [inputStream AMQPReadShortStr];
		self.classId = [inputStream AMQPReadUInt16];
		self.methodId = [inputStream AMQPReadUInt16];
	}
	return self;
}

- (instancetype)initWithReplyCode:(UInt16)replyCode replyText:(NSString *)replyText classId:(UInt16)classId methodId:(UInt16)methodId {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 10;
		self.amqpMethodId = 50;
		self.replyCode = replyCode;
		self.replyText = replyText;
		self.classId = classId;
		self.methodId = methodId;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteUInt16:self.replyCode];
	[outputStream AMQPWriteShortStr:self.replyText];
	[outputStream AMQPWriteUInt16:self.classId];
	[outputStream AMQPWriteUInt16:self.methodId];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation ConnectionCloseOk{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 10;
		self.amqpMethodId = 51;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
	}
	return self;
}

-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation ConnectionBlocked{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 10;
		self.amqpMethodId = 60;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.reason = [inputStream AMQPReadShortStr];
	}
	return self;
}

- (instancetype)initWithReason:(NSString *)reason {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 10;
		self.amqpMethodId = 60;
		self.reason = reason;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteShortStr:self.reason];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation ConnectionUnblocked{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 10;
		self.amqpMethodId = 61;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
	}
	return self;
}

-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation ChannelOpen{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 20;
		self.amqpMethodId = 10;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.outOfBand = [inputStream AMQPReadShortStr];
	}
	return self;
}

- (instancetype)initWithOutOfBand:(NSString *)outOfBand {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 20;
		self.amqpMethodId = 10;
		self.outOfBand = outOfBand;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteShortStr:self.outOfBand];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation ChannelOpenOk{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 20;
		self.amqpMethodId = 11;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.channelId = [inputStream AMQPReadLongStr];
	}
	return self;
}

- (instancetype)initWithChannelId:(NSString *)channelId {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 20;
		self.amqpMethodId = 11;
		self.channelId = channelId;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteLongStr:self.channelId];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation ChannelFlow{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 20;
		self.amqpMethodId = 20;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		UInt8 bits = [inputStream AMQPReadUInt8];
		self.active = (bits & (1 << 0)) ? TRUE : FALSE;
	}
	return self;
}

- (instancetype)initWithActive:(BOOL)active {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 20;
		self.amqpMethodId = 20;
		self.active = active;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	UInt8 bits = 0;
	if(self.active) bits |= (1<<0);
	[outputStream AMQPWriteUInt8:bits];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation ChannelFlowOk{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 20;
		self.amqpMethodId = 21;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		UInt8 bits = [inputStream AMQPReadUInt8];
		self.active = (bits & (1 << 0)) ? TRUE : FALSE;
	}
	return self;
}

- (instancetype)initWithActive:(BOOL)active {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 20;
		self.amqpMethodId = 21;
		self.active = active;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	UInt8 bits = 0;
	if(self.active) bits |= (1<<0);
	[outputStream AMQPWriteUInt8:bits];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation ChannelClose{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 20;
		self.amqpMethodId = 40;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.replyCode = [inputStream AMQPReadUInt16];
		self.replyText = [inputStream AMQPReadShortStr];
		self.classId = [inputStream AMQPReadUInt16];
		self.methodId = [inputStream AMQPReadUInt16];
	}
	return self;
}

- (instancetype)initWithReplyCode:(UInt16)replyCode replyText:(NSString *)replyText classId:(UInt16)classId methodId:(UInt16)methodId {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 20;
		self.amqpMethodId = 40;
		self.replyCode = replyCode;
		self.replyText = replyText;
		self.classId = classId;
		self.methodId = methodId;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteUInt16:self.replyCode];
	[outputStream AMQPWriteShortStr:self.replyText];
	[outputStream AMQPWriteUInt16:self.classId];
	[outputStream AMQPWriteUInt16:self.methodId];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation ChannelCloseOk{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 20;
		self.amqpMethodId = 41;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
	}
	return self;
}

-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation AccessRequest{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 30;
		self.amqpMethodId = 10;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.realm = [inputStream AMQPReadShortStr];
		UInt8 bits = [inputStream AMQPReadUInt8];
		self.exclusive = (bits & (1 << 0)) ? TRUE : FALSE;
		self.passive = (bits & (1 << 1)) ? TRUE : FALSE;
		self.active = (bits & (1 << 2)) ? TRUE : FALSE;
		self.write = (bits & (1 << 3)) ? TRUE : FALSE;
		self.read = (bits & (1 << 4)) ? TRUE : FALSE;
	}
	return self;
}

- (instancetype)initWithRealm:(NSString *)realm exclusive:(BOOL)exclusive passive:(BOOL)passive active:(BOOL)active write:(BOOL)write read:(BOOL)read {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 30;
		self.amqpMethodId = 10;
		self.realm = realm;
		self.exclusive = exclusive;
		self.passive = passive;
		self.active = active;
		self.write = write;
		self.read = read;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteShortStr:self.realm];
	UInt8 bits = 0;
	if(self.exclusive) bits |= (1<<0);
	if(self.passive) bits |= (1<<1);
	if(self.active) bits |= (1<<2);
	if(self.write) bits |= (1<<3);
	if(self.read) bits |= (1<<4);
	[outputStream AMQPWriteUInt8:bits];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation AccessRequestOk{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 30;
		self.amqpMethodId = 11;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.ticket = [inputStream AMQPReadUInt16];
	}
	return self;
}

- (instancetype)initWithTicket:(UInt16)ticket {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 30;
		self.amqpMethodId = 11;
		self.ticket = ticket;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteUInt16:self.ticket];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation ExchangeDeclare{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 40;
		self.amqpMethodId = 10;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.ticket = [inputStream AMQPReadUInt16];
		self.exchange = [inputStream AMQPReadShortStr];
		self.type = [inputStream AMQPReadShortStr];
		UInt8 bits = [inputStream AMQPReadUInt8];
		self.passive = (bits & (1 << 0)) ? TRUE : FALSE;
		self.durable = (bits & (1 << 1)) ? TRUE : FALSE;
		self.autoDelete = (bits & (1 << 2)) ? TRUE : FALSE;
		self.internal = (bits & (1 << 3)) ? TRUE : FALSE;
		self.nowait = (bits & (1 << 4)) ? TRUE : FALSE;
		self.arguments = [inputStream AMQPReadNSDictionary];
	}
	return self;
}

- (instancetype)initWithTicket:(UInt16)ticket exchange:(NSString *)exchange type:(NSString *)type passive:(BOOL)passive durable:(BOOL)durable autoDelete:(BOOL)autoDelete internal:(BOOL)internal nowait:(BOOL)nowait arguments:(NSDictionary *)arguments {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 40;
		self.amqpMethodId = 10;
		self.ticket = ticket;
		self.exchange = exchange;
		self.type = type;
		self.passive = passive;
		self.durable = durable;
		self.autoDelete = autoDelete;
		self.internal = internal;
		self.nowait = nowait;
		self.arguments = arguments;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteUInt16:self.ticket];
	[outputStream AMQPWriteShortStr:self.exchange];
	[outputStream AMQPWriteShortStr:self.type];
	UInt8 bits = 0;
	if(self.passive) bits |= (1<<0);
	if(self.durable) bits |= (1<<1);
	if(self.autoDelete) bits |= (1<<2);
	if(self.internal) bits |= (1<<3);
	if(self.nowait) bits |= (1<<4);
	[outputStream AMQPWriteUInt8:bits];
	[outputStream AMQPWriteNSDictionary:self.arguments];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation ExchangeDeclareOk{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 40;
		self.amqpMethodId = 11;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
	}
	return self;
}

-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation ExchangeDelete{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 40;
		self.amqpMethodId = 20;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.ticket = [inputStream AMQPReadUInt16];
		self.exchange = [inputStream AMQPReadShortStr];
		UInt8 bits = [inputStream AMQPReadUInt8];
		self.ifUnused = (bits & (1 << 0)) ? TRUE : FALSE;
		self.nowait = (bits & (1 << 1)) ? TRUE : FALSE;
	}
	return self;
}

- (instancetype)initWithTicket:(UInt16)ticket exchange:(NSString *)exchange ifUnused:(BOOL)ifUnused nowait:(BOOL)nowait {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 40;
		self.amqpMethodId = 20;
		self.ticket = ticket;
		self.exchange = exchange;
		self.ifUnused = ifUnused;
		self.nowait = nowait;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteUInt16:self.ticket];
	[outputStream AMQPWriteShortStr:self.exchange];
	UInt8 bits = 0;
	if(self.ifUnused) bits |= (1<<0);
	if(self.nowait) bits |= (1<<1);
	[outputStream AMQPWriteUInt8:bits];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation ExchangeDeleteOk{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 40;
		self.amqpMethodId = 21;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
	}
	return self;
}

-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation ExchangeBind{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 40;
		self.amqpMethodId = 30;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.ticket = [inputStream AMQPReadUInt16];
		self.destination = [inputStream AMQPReadShortStr];
		self.source = [inputStream AMQPReadShortStr];
		self.routingKey = [inputStream AMQPReadShortStr];
		UInt8 bits = [inputStream AMQPReadUInt8];
		self.nowait = (bits & (1 << 0)) ? TRUE : FALSE;
		self.arguments = [inputStream AMQPReadNSDictionary];
	}
	return self;
}

- (instancetype)initWithTicket:(UInt16)ticket destination:(NSString *)destination source:(NSString *)source routingKey:(NSString *)routingKey nowait:(BOOL)nowait arguments:(NSDictionary *)arguments {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 40;
		self.amqpMethodId = 30;
		self.ticket = ticket;
		self.destination = destination;
		self.source = source;
		self.routingKey = routingKey;
		self.nowait = nowait;
		self.arguments = arguments;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteUInt16:self.ticket];
	[outputStream AMQPWriteShortStr:self.destination];
	[outputStream AMQPWriteShortStr:self.source];
	[outputStream AMQPWriteShortStr:self.routingKey];
	UInt8 bits = 0;
	if(self.nowait) bits |= (1<<0);
	[outputStream AMQPWriteUInt8:bits];
	[outputStream AMQPWriteNSDictionary:self.arguments];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation ExchangeBindOk{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 40;
		self.amqpMethodId = 31;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
	}
	return self;
}

-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation ExchangeUnbind{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 40;
		self.amqpMethodId = 40;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.ticket = [inputStream AMQPReadUInt16];
		self.destination = [inputStream AMQPReadShortStr];
		self.source = [inputStream AMQPReadShortStr];
		self.routingKey = [inputStream AMQPReadShortStr];
		UInt8 bits = [inputStream AMQPReadUInt8];
		self.nowait = (bits & (1 << 0)) ? TRUE : FALSE;
		self.arguments = [inputStream AMQPReadNSDictionary];
	}
	return self;
}

- (instancetype)initWithTicket:(UInt16)ticket destination:(NSString *)destination source:(NSString *)source routingKey:(NSString *)routingKey nowait:(BOOL)nowait arguments:(NSDictionary *)arguments {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 40;
		self.amqpMethodId = 40;
		self.ticket = ticket;
		self.destination = destination;
		self.source = source;
		self.routingKey = routingKey;
		self.nowait = nowait;
		self.arguments = arguments;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteUInt16:self.ticket];
	[outputStream AMQPWriteShortStr:self.destination];
	[outputStream AMQPWriteShortStr:self.source];
	[outputStream AMQPWriteShortStr:self.routingKey];
	UInt8 bits = 0;
	if(self.nowait) bits |= (1<<0);
	[outputStream AMQPWriteUInt8:bits];
	[outputStream AMQPWriteNSDictionary:self.arguments];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation ExchangeUnbindOk{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 40;
		self.amqpMethodId = 51;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
	}
	return self;
}

-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation QueueDeclare{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 50;
		self.amqpMethodId = 10;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.ticket = [inputStream AMQPReadUInt16];
		self.queue = [inputStream AMQPReadShortStr];
		UInt8 bits = [inputStream AMQPReadUInt8];
		self.passive = (bits & (1 << 0)) ? TRUE : FALSE;
		self.durable = (bits & (1 << 1)) ? TRUE : FALSE;
		self.exclusive = (bits & (1 << 2)) ? TRUE : FALSE;
		self.autoDelete = (bits & (1 << 3)) ? TRUE : FALSE;
		self.nowait = (bits & (1 << 4)) ? TRUE : FALSE;
		self.arguments = [inputStream AMQPReadNSDictionary];
	}
	return self;
}

- (instancetype)initWithTicket:(UInt16)ticket queue:(NSString *)queue passive:(BOOL)passive durable:(BOOL)durable exclusive:(BOOL)exclusive autoDelete:(BOOL)autoDelete nowait:(BOOL)nowait arguments:(NSDictionary *)arguments {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 50;
		self.amqpMethodId = 10;
		self.ticket = ticket;
		self.queue = queue;
		self.passive = passive;
		self.durable = durable;
		self.exclusive = exclusive;
		self.autoDelete = autoDelete;
		self.nowait = nowait;
		self.arguments = arguments;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteUInt16:self.ticket];
	[outputStream AMQPWriteShortStr:self.queue];
	UInt8 bits = 0;
	if(self.passive) bits |= (1<<0);
	if(self.durable) bits |= (1<<1);
	if(self.exclusive) bits |= (1<<2);
	if(self.autoDelete) bits |= (1<<3);
	if(self.nowait) bits |= (1<<4);
	[outputStream AMQPWriteUInt8:bits];
	[outputStream AMQPWriteNSDictionary:self.arguments];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation QueueDeclareOk{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 50;
		self.amqpMethodId = 11;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.queue = [inputStream AMQPReadShortStr];
		self.messageCount = [inputStream AMQPReadUInt32];
		self.consumerCount = [inputStream AMQPReadUInt32];
	}
	return self;
}

- (instancetype)initWithQueue:(NSString *)queue messageCount:(UInt32)messageCount consumerCount:(UInt32)consumerCount {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 50;
		self.amqpMethodId = 11;
		self.queue = queue;
		self.messageCount = messageCount;
		self.consumerCount = consumerCount;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteShortStr:self.queue];
	[outputStream AMQPWriteUInt32:self.messageCount];
	[outputStream AMQPWriteUInt32:self.consumerCount];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation QueueBind{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 50;
		self.amqpMethodId = 20;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.ticket = [inputStream AMQPReadUInt16];
		self.queue = [inputStream AMQPReadShortStr];
		self.exchange = [inputStream AMQPReadShortStr];
		self.routingKey = [inputStream AMQPReadShortStr];
		UInt8 bits = [inputStream AMQPReadUInt8];
		self.nowait = (bits & (1 << 0)) ? TRUE : FALSE;
		self.arguments = [inputStream AMQPReadNSDictionary];
	}
	return self;
}

- (instancetype)initWithTicket:(UInt16)ticket queue:(NSString *)queue exchange:(NSString *)exchange routingKey:(NSString *)routingKey nowait:(BOOL)nowait arguments:(NSDictionary *)arguments {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 50;
		self.amqpMethodId = 20;
		self.ticket = ticket;
		self.queue = queue;
		self.exchange = exchange;
		self.routingKey = routingKey;
		self.nowait = nowait;
		self.arguments = arguments;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteUInt16:self.ticket];
	[outputStream AMQPWriteShortStr:self.queue];
	[outputStream AMQPWriteShortStr:self.exchange];
	[outputStream AMQPWriteShortStr:self.routingKey];
	UInt8 bits = 0;
	if(self.nowait) bits |= (1<<0);
	[outputStream AMQPWriteUInt8:bits];
	[outputStream AMQPWriteNSDictionary:self.arguments];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation QueueBindOk{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 50;
		self.amqpMethodId = 21;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
	}
	return self;
}

-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation QueuePurge{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 50;
		self.amqpMethodId = 30;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.ticket = [inputStream AMQPReadUInt16];
		self.queue = [inputStream AMQPReadShortStr];
		UInt8 bits = [inputStream AMQPReadUInt8];
		self.nowait = (bits & (1 << 0)) ? TRUE : FALSE;
	}
	return self;
}

- (instancetype)initWithTicket:(UInt16)ticket queue:(NSString *)queue nowait:(BOOL)nowait {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 50;
		self.amqpMethodId = 30;
		self.ticket = ticket;
		self.queue = queue;
		self.nowait = nowait;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteUInt16:self.ticket];
	[outputStream AMQPWriteShortStr:self.queue];
	UInt8 bits = 0;
	if(self.nowait) bits |= (1<<0);
	[outputStream AMQPWriteUInt8:bits];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation QueuePurgeOk{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 50;
		self.amqpMethodId = 31;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.messageCount = [inputStream AMQPReadUInt32];
	}
	return self;
}

- (instancetype)initWithMessageCount:(UInt32)messageCount {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 50;
		self.amqpMethodId = 31;
		self.messageCount = messageCount;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteUInt32:self.messageCount];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation QueueDelete{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 50;
		self.amqpMethodId = 40;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.ticket = [inputStream AMQPReadUInt16];
		self.queue = [inputStream AMQPReadShortStr];
		UInt8 bits = [inputStream AMQPReadUInt8];
		self.ifUnused = (bits & (1 << 0)) ? TRUE : FALSE;
		self.ifEmpty = (bits & (1 << 1)) ? TRUE : FALSE;
		self.nowait = (bits & (1 << 2)) ? TRUE : FALSE;
	}
	return self;
}

- (instancetype)initWithTicket:(UInt16)ticket queue:(NSString *)queue ifUnused:(BOOL)ifUnused ifEmpty:(BOOL)ifEmpty nowait:(BOOL)nowait {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 50;
		self.amqpMethodId = 40;
		self.ticket = ticket;
		self.queue = queue;
		self.ifUnused = ifUnused;
		self.ifEmpty = ifEmpty;
		self.nowait = nowait;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteUInt16:self.ticket];
	[outputStream AMQPWriteShortStr:self.queue];
	UInt8 bits = 0;
	if(self.ifUnused) bits |= (1<<0);
	if(self.ifEmpty) bits |= (1<<1);
	if(self.nowait) bits |= (1<<2);
	[outputStream AMQPWriteUInt8:bits];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation QueueDeleteOk{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 50;
		self.amqpMethodId = 41;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.messageCount = [inputStream AMQPReadUInt32];
	}
	return self;
}

- (instancetype)initWithMessageCount:(UInt32)messageCount {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 50;
		self.amqpMethodId = 41;
		self.messageCount = messageCount;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteUInt32:self.messageCount];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation QueueUnbind{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 50;
		self.amqpMethodId = 50;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.ticket = [inputStream AMQPReadUInt16];
		self.queue = [inputStream AMQPReadShortStr];
		self.exchange = [inputStream AMQPReadShortStr];
		self.routingKey = [inputStream AMQPReadShortStr];
		self.arguments = [inputStream AMQPReadNSDictionary];
	}
	return self;
}

- (instancetype)initWithTicket:(UInt16)ticket queue:(NSString *)queue exchange:(NSString *)exchange routingKey:(NSString *)routingKey arguments:(NSDictionary *)arguments {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 50;
		self.amqpMethodId = 50;
		self.ticket = ticket;
		self.queue = queue;
		self.exchange = exchange;
		self.routingKey = routingKey;
		self.arguments = arguments;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteUInt16:self.ticket];
	[outputStream AMQPWriteShortStr:self.queue];
	[outputStream AMQPWriteShortStr:self.exchange];
	[outputStream AMQPWriteShortStr:self.routingKey];
	[outputStream AMQPWriteNSDictionary:self.arguments];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation QueueUnbindOk{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 50;
		self.amqpMethodId = 51;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
	}
	return self;
}

-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation BasicQos{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 10;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.prefetchSize = [inputStream AMQPReadUInt32];
		self.prefetchCount = [inputStream AMQPReadUInt16];
		UInt8 bits = [inputStream AMQPReadUInt8];
		self.global = (bits & (1 << 0)) ? TRUE : FALSE;
	}
	return self;
}

- (instancetype)initWithPrefetchSize:(UInt32)prefetchSize prefetchCount:(UInt16)prefetchCount global:(BOOL)global {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 10;
		self.prefetchSize = prefetchSize;
		self.prefetchCount = prefetchCount;
		self.global = global;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteUInt32:self.prefetchSize];
	[outputStream AMQPWriteUInt16:self.prefetchCount];
	UInt8 bits = 0;
	if(self.global) bits |= (1<<0);
	[outputStream AMQPWriteUInt8:bits];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation BasicQosOk{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 11;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
	}
	return self;
}

-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation BasicConsume{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 20;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.ticket = [inputStream AMQPReadUInt16];
		self.queue = [inputStream AMQPReadShortStr];
		self.consumerTag = [inputStream AMQPReadShortStr];
		UInt8 bits = [inputStream AMQPReadUInt8];
		self.noLocal = (bits & (1 << 0)) ? TRUE : FALSE;
		self.noAck = (bits & (1 << 1)) ? TRUE : FALSE;
		self.exclusive = (bits & (1 << 2)) ? TRUE : FALSE;
		self.nowait = (bits & (1 << 3)) ? TRUE : FALSE;
		self.arguments = [inputStream AMQPReadNSDictionary];
	}
	return self;
}

- (instancetype)initWithTicket:(UInt16)ticket queue:(NSString *)queue consumerTag:(NSString *)consumerTag noLocal:(BOOL)noLocal noAck:(BOOL)noAck exclusive:(BOOL)exclusive nowait:(BOOL)nowait arguments:(NSDictionary *)arguments {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 20;
		self.ticket = ticket;
		self.queue = queue;
		self.consumerTag = consumerTag;
		self.noLocal = noLocal;
		self.noAck = noAck;
		self.exclusive = exclusive;
		self.nowait = nowait;
		self.arguments = arguments;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteUInt16:self.ticket];
	[outputStream AMQPWriteShortStr:self.queue];
	[outputStream AMQPWriteShortStr:self.consumerTag];
	UInt8 bits = 0;
	if(self.noLocal) bits |= (1<<0);
	if(self.noAck) bits |= (1<<1);
	if(self.exclusive) bits |= (1<<2);
	if(self.nowait) bits |= (1<<3);
	[outputStream AMQPWriteUInt8:bits];
	[outputStream AMQPWriteNSDictionary:self.arguments];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation BasicConsumeOk{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 21;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.consumerTag = [inputStream AMQPReadShortStr];
	}
	return self;
}

- (instancetype)initWithConsumerTag:(NSString *)consumerTag {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 21;
		self.consumerTag = consumerTag;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteShortStr:self.consumerTag];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation BasicCancel{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 30;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.consumerTag = [inputStream AMQPReadShortStr];
		UInt8 bits = [inputStream AMQPReadUInt8];
		self.nowait = (bits & (1 << 0)) ? TRUE : FALSE;
	}
	return self;
}

- (instancetype)initWithConsumerTag:(NSString *)consumerTag nowait:(BOOL)nowait {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 30;
		self.consumerTag = consumerTag;
		self.nowait = nowait;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteShortStr:self.consumerTag];
	UInt8 bits = 0;
	if(self.nowait) bits |= (1<<0);
	[outputStream AMQPWriteUInt8:bits];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation BasicCancelOk{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 31;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.consumerTag = [inputStream AMQPReadShortStr];
	}
	return self;
}

- (instancetype)initWithConsumerTag:(NSString *)consumerTag {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 31;
		self.consumerTag = consumerTag;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteShortStr:self.consumerTag];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation BasicPublish{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 40;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.ticket = [inputStream AMQPReadUInt16];
		self.exchange = [inputStream AMQPReadShortStr];
		self.routingKey = [inputStream AMQPReadShortStr];
		UInt8 bits = [inputStream AMQPReadUInt8];
		self.mandatory = (bits & (1 << 0)) ? TRUE : FALSE;
		self.immediate = (bits & (1 << 1)) ? TRUE : FALSE;
	}
	return self;
}

- (instancetype)initWithTicket:(UInt16)ticket exchange:(NSString *)exchange routingKey:(NSString *)routingKey mandatory:(BOOL)mandatory immediate:(BOOL)immediate {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 40;
		self.ticket = ticket;
		self.exchange = exchange;
		self.routingKey = routingKey;
		self.mandatory = mandatory;
		self.immediate = immediate;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteUInt16:self.ticket];
	[outputStream AMQPWriteShortStr:self.exchange];
	[outputStream AMQPWriteShortStr:self.routingKey];
	UInt8 bits = 0;
	if(self.mandatory) bits |= (1<<0);
	if(self.immediate) bits |= (1<<1);
	[outputStream AMQPWriteUInt8:bits];
}

-(BOOL)hasContent{
	return TRUE;
}
@end

@implementation BasicReturn{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 50;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.replyCode = [inputStream AMQPReadUInt16];
		self.replyText = [inputStream AMQPReadShortStr];
		self.exchange = [inputStream AMQPReadShortStr];
		self.routingKey = [inputStream AMQPReadShortStr];
	}
	return self;
}

- (instancetype)initWithReplyCode:(UInt16)replyCode replyText:(NSString *)replyText exchange:(NSString *)exchange routingKey:(NSString *)routingKey {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 50;
		self.replyCode = replyCode;
		self.replyText = replyText;
		self.exchange = exchange;
		self.routingKey = routingKey;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteUInt16:self.replyCode];
	[outputStream AMQPWriteShortStr:self.replyText];
	[outputStream AMQPWriteShortStr:self.exchange];
	[outputStream AMQPWriteShortStr:self.routingKey];
}

-(BOOL)hasContent{
	return TRUE;
}
@end

@implementation BasicDeliver{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 60;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.consumerTag = [inputStream AMQPReadShortStr];
		self.deliveryTag = [inputStream AMQPReadUInt64];
		UInt8 bits = [inputStream AMQPReadUInt8];
		self.redelivered = (bits & (1 << 0)) ? TRUE : FALSE;
		self.exchange = [inputStream AMQPReadShortStr];
		self.routingKey = [inputStream AMQPReadShortStr];
	}
	return self;
}

- (instancetype)initWithConsumerTag:(NSString *)consumerTag deliveryTag:(UInt64)deliveryTag redelivered:(BOOL)redelivered exchange:(NSString *)exchange routingKey:(NSString *)routingKey {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 60;
		self.consumerTag = consumerTag;
		self.deliveryTag = deliveryTag;
		self.redelivered = redelivered;
		self.exchange = exchange;
		self.routingKey = routingKey;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteShortStr:self.consumerTag];
	[outputStream AMQPWriteUInt64:self.deliveryTag];
	UInt8 bits = 0;
	if(self.redelivered) bits |= (1<<0);
	[outputStream AMQPWriteUInt8:bits];
	[outputStream AMQPWriteShortStr:self.exchange];
	[outputStream AMQPWriteShortStr:self.routingKey];
}

-(BOOL)hasContent{
	return TRUE;
}
@end

@implementation BasicGet{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 70;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.ticket = [inputStream AMQPReadUInt16];
		self.queue = [inputStream AMQPReadShortStr];
		UInt8 bits = [inputStream AMQPReadUInt8];
		self.noAck = (bits & (1 << 0)) ? TRUE : FALSE;
	}
	return self;
}

- (instancetype)initWithTicket:(UInt16)ticket queue:(NSString *)queue noAck:(BOOL)noAck {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 70;
		self.ticket = ticket;
		self.queue = queue;
		self.noAck = noAck;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteUInt16:self.ticket];
	[outputStream AMQPWriteShortStr:self.queue];
	UInt8 bits = 0;
	if(self.noAck) bits |= (1<<0);
	[outputStream AMQPWriteUInt8:bits];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation BasicGetOk{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 71;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.deliveryTag = [inputStream AMQPReadUInt64];
		UInt8 bits = [inputStream AMQPReadUInt8];
		self.redelivered = (bits & (1 << 0)) ? TRUE : FALSE;
		self.exchange = [inputStream AMQPReadShortStr];
		self.routingKey = [inputStream AMQPReadShortStr];
		self.messageCount = [inputStream AMQPReadUInt32];
	}
	return self;
}

- (instancetype)initWithDeliveryTag:(UInt64)deliveryTag redelivered:(BOOL)redelivered exchange:(NSString *)exchange routingKey:(NSString *)routingKey messageCount:(UInt32)messageCount {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 71;
		self.deliveryTag = deliveryTag;
		self.redelivered = redelivered;
		self.exchange = exchange;
		self.routingKey = routingKey;
		self.messageCount = messageCount;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteUInt64:self.deliveryTag];
	UInt8 bits = 0;
	if(self.redelivered) bits |= (1<<0);
	[outputStream AMQPWriteUInt8:bits];
	[outputStream AMQPWriteShortStr:self.exchange];
	[outputStream AMQPWriteShortStr:self.routingKey];
	[outputStream AMQPWriteUInt32:self.messageCount];
}

-(BOOL)hasContent{
	return TRUE;
}
@end

@implementation BasicGetEmpty{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 72;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.clusterId = [inputStream AMQPReadShortStr];
	}
	return self;
}

- (instancetype)initWithClusterId:(NSString *)clusterId {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 72;
		self.clusterId = clusterId;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteShortStr:self.clusterId];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation BasicAck{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 80;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.deliveryTag = [inputStream AMQPReadUInt64];
		UInt8 bits = [inputStream AMQPReadUInt8];
		self.multiple = (bits & (1 << 0)) ? TRUE : FALSE;
	}
	return self;
}

- (instancetype)initWithDeliveryTag:(UInt64)deliveryTag multiple:(BOOL)multiple {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 80;
		self.deliveryTag = deliveryTag;
		self.multiple = multiple;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteUInt64:self.deliveryTag];
	UInt8 bits = 0;
	if(self.multiple) bits |= (1<<0);
	[outputStream AMQPWriteUInt8:bits];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation BasicReject{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 90;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.deliveryTag = [inputStream AMQPReadUInt64];
		UInt8 bits = [inputStream AMQPReadUInt8];
		self.requeue = (bits & (1 << 0)) ? TRUE : FALSE;
	}
	return self;
}

- (instancetype)initWithDeliveryTag:(UInt64)deliveryTag requeue:(BOOL)requeue {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 90;
		self.deliveryTag = deliveryTag;
		self.requeue = requeue;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteUInt64:self.deliveryTag];
	UInt8 bits = 0;
	if(self.requeue) bits |= (1<<0);
	[outputStream AMQPWriteUInt8:bits];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation BasicRecoverAsync{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 100;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		UInt8 bits = [inputStream AMQPReadUInt8];
		self.requeue = (bits & (1 << 0)) ? TRUE : FALSE;
	}
	return self;
}

- (instancetype)initWithRequeue:(BOOL)requeue {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 100;
		self.requeue = requeue;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	UInt8 bits = 0;
	if(self.requeue) bits |= (1<<0);
	[outputStream AMQPWriteUInt8:bits];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation BasicRecover{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 110;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		UInt8 bits = [inputStream AMQPReadUInt8];
		self.requeue = (bits & (1 << 0)) ? TRUE : FALSE;
	}
	return self;
}

- (instancetype)initWithRequeue:(BOOL)requeue {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 110;
		self.requeue = requeue;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	UInt8 bits = 0;
	if(self.requeue) bits |= (1<<0);
	[outputStream AMQPWriteUInt8:bits];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation BasicRecoverOk{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 111;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
	}
	return self;
}

-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation BasicNack{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 120;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		self.deliveryTag = [inputStream AMQPReadUInt64];
		UInt8 bits = [inputStream AMQPReadUInt8];
		self.multiple = (bits & (1 << 0)) ? TRUE : FALSE;
		self.requeue = (bits & (1 << 1)) ? TRUE : FALSE;
	}
	return self;
}

- (instancetype)initWithDeliveryTag:(UInt64)deliveryTag multiple:(BOOL)multiple requeue:(BOOL)requeue {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 60;
		self.amqpMethodId = 120;
		self.deliveryTag = deliveryTag;
		self.multiple = multiple;
		self.requeue = requeue;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	[outputStream AMQPWriteUInt64:self.deliveryTag];
	UInt8 bits = 0;
	if(self.multiple) bits |= (1<<0);
	if(self.requeue) bits |= (1<<1);
	[outputStream AMQPWriteUInt8:bits];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation TxSelect{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 90;
		self.amqpMethodId = 10;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
	}
	return self;
}

-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation TxSelectOk{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 90;
		self.amqpMethodId = 11;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
	}
	return self;
}

-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation TxCommit{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 90;
		self.amqpMethodId = 20;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
	}
	return self;
}

-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation TxCommitOk{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 90;
		self.amqpMethodId = 21;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
	}
	return self;
}

-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation TxRollback{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 90;
		self.amqpMethodId = 30;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
	}
	return self;
}

-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation TxRollbackOk{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 90;
		self.amqpMethodId = 31;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
	}
	return self;
}

-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation ConfirmSelect{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 85;
		self.amqpMethodId = 10;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
		UInt8 bits = [inputStream AMQPReadUInt8];
		self.nowait = (bits & (1 << 0)) ? TRUE : FALSE;
	}
	return self;
}

- (instancetype)initWithNowait:(BOOL)nowait {
	self = [super init];
	if (self){
		self.amqpMethodClassId = 85;
		self.amqpMethodId = 10;
		self.nowait = nowait;

	}
	return self;
}
-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
	UInt8 bits = 0;
	if(self.nowait) bits |= (1<<0);
	[outputStream AMQPWriteUInt8:bits];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

@implementation ConfirmSelectOk{

}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.amqpMethodClassId = 85;
		self.amqpMethodId = 11;
	}
	return self;
}

-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{
	self = [super initWithInputStream:inputStream];
	if (self){
	}
	return self;
}

-(void)write:(AMQPOutputStream *)outputStream{
	[super write:outputStream];
}

-(BOOL)hasContent{
	return FALSE;
}
@end

