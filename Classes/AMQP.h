#import <Foundation/Foundation.h>
#import "AMQPStream.h" 

#define AMQP_PROTOCOL_VERSION_MAJOR 0
#define AMQP_PROTOCOL_VERSION_MINOR 9
#define AMQP_PROTOCOL_VERSION_REVISION 1

#define AMQP_HEADER_SIZE 7
#define AMQP_FOOTER_SIZE 1

#define AMQP_FRAME_METHOD 1
#define AMQP_FRAME_HEADER 2
#define AMQP_FRAME_BODY 3
#define AMQP_FRAME_HEARTBEAT 8
#define AMQP_FRAME_MIN_SIZE 4096
#define AMQP_FRAME_END 206
#define AMQP_REPLY_SUCCESS 200
#define AMQP_CONTENT_TOO_LARGE 311
#define AMQP_NO_ROUTE 312
#define AMQP_NO_CONSUMERS 313
#define AMQP_ACCESS_REFUSED 403
#define AMQP_NOT_FOUND 404
#define AMQP_RESOURCE_LOCKED 405
#define AMQP_PRECONDITION_FAILED 406
#define AMQP_CONNECTION_FORCED 320
#define AMQP_INVALID_PATH 402
#define AMQP_FRAME_ERROR 501
#define AMQP_SYNTAX_ERROR 502
#define AMQP_COMMAND_INVALID 503
#define AMQP_CHANNEL_ERROR 504
#define AMQP_UNEXPECTED_FRAME 505
#define AMQP_RESOURCE_ERROR 506
#define AMQP_NOT_ALLOWED 530
#define AMQP_NOT_IMPLEMENTED 540
#define AMQP_INTERNAL_ERROR 541
#define AMQP_BASIC_PROPERTIES_CLASS_ID 60

@interface AMQPMethod:NSObject
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
-(void)write:(AMQPOutputStream *)outputStream;
-(BOOL)hasContent;

@property UInt16 amqpMethodClassId;
@property UInt16 amqpMethodId;
@end

@interface AMQP:NSObject
+(AMQPMethod *)readMethod:(AMQPInputStream *)inputStream;
@end

@interface AMQPBasicProperties:NSObject
@property NSString * contentType;
@property NSString * contentEncoding;
@property NSDictionary * headers;
@property UInt8 deliveryMode;
@property UInt8 priority;
@property NSString * correlationId;
@property NSString * replyTo;
@property NSString * expiration;
@property NSString * messageId;
@property NSDate * timestamp;
@property NSString * type;
@property NSString * userId;
@property NSString * appId;
@property NSString * clusterId;
@end

@interface ConnectionStart : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithVersionMajor:(UInt8)versionMajor versionMinor:(UInt8)versionMinor serverProperties:(NSDictionary *)serverProperties mechanisms:(NSString *)mechanisms locales:(NSString *)locales ;
-(void)write:(AMQPOutputStream *)outputStream;
@property UInt8 versionMajor;
@property UInt8 versionMinor;
@property NSDictionary * serverProperties;
@property NSString * mechanisms;
@property NSString * locales;
@end

@interface ConnectionStartOk : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithClientProperties:(NSDictionary *)clientProperties mechanism:(NSString *)mechanism response:(NSString *)response locale:(NSString *)locale ;
-(void)write:(AMQPOutputStream *)outputStream;
@property NSDictionary * clientProperties;
@property NSString * mechanism;
@property NSString * response;
@property NSString * locale;
@end

@interface ConnectionSecure : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithChallenge:(NSString *)challenge ;
-(void)write:(AMQPOutputStream *)outputStream;
@property NSString * challenge;
@end

@interface ConnectionSecureOk : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithResponse:(NSString *)response ;
-(void)write:(AMQPOutputStream *)outputStream;
@property NSString * response;
@end

@interface ConnectionTune : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithChannelMax:(UInt16)channelMax frameMax:(UInt32)frameMax heartbeat:(UInt16)heartbeat ;
-(void)write:(AMQPOutputStream *)outputStream;
@property UInt16 channelMax;
@property UInt32 frameMax;
@property UInt16 heartbeat;
@end

@interface ConnectionTuneOk : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithChannelMax:(UInt16)channelMax frameMax:(UInt32)frameMax heartbeat:(UInt16)heartbeat ;
-(void)write:(AMQPOutputStream *)outputStream;
@property UInt16 channelMax;
@property UInt32 frameMax;
@property UInt16 heartbeat;
@end

@interface ConnectionOpen : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithVirtualHost:(NSString *)virtualHost capabilities:(NSString *)capabilities insist:(BOOL)insist ;
-(void)write:(AMQPOutputStream *)outputStream;
@property NSString * virtualHost;
@property NSString * capabilities;
@property BOOL insist;
@end

@interface ConnectionOpenOk : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithKnownHosts:(NSString *)knownHosts ;
-(void)write:(AMQPOutputStream *)outputStream;
@property NSString * knownHosts;
@end

@interface ConnectionClose : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithReplyCode:(UInt16)replyCode replyText:(NSString *)replyText classId:(UInt16)classId methodId:(UInt16)methodId ;
-(void)write:(AMQPOutputStream *)outputStream;
@property UInt16 replyCode;
@property NSString * replyText;
@property UInt16 classId;
@property UInt16 methodId;
@end

@interface ConnectionCloseOk : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
-(void)write:(AMQPOutputStream *)outputStream;
@end

@interface ConnectionBlocked : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithReason:(NSString *)reason ;
-(void)write:(AMQPOutputStream *)outputStream;
@property NSString * reason;
@end

@interface ConnectionUnblocked : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
-(void)write:(AMQPOutputStream *)outputStream;
@end

@interface ChannelOpen : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithOutOfBand:(NSString *)outOfBand ;
-(void)write:(AMQPOutputStream *)outputStream;
@property NSString * outOfBand;
@end

@interface ChannelOpenOk : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithChannelId:(NSString *)channelId ;
-(void)write:(AMQPOutputStream *)outputStream;
@property NSString * channelId;
@end

@interface ChannelFlow : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithActive:(BOOL)active ;
-(void)write:(AMQPOutputStream *)outputStream;
@property BOOL active;
@end

@interface ChannelFlowOk : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithActive:(BOOL)active ;
-(void)write:(AMQPOutputStream *)outputStream;
@property BOOL active;
@end

@interface ChannelClose : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithReplyCode:(UInt16)replyCode replyText:(NSString *)replyText classId:(UInt16)classId methodId:(UInt16)methodId ;
-(void)write:(AMQPOutputStream *)outputStream;
@property UInt16 replyCode;
@property NSString * replyText;
@property UInt16 classId;
@property UInt16 methodId;
@end

@interface ChannelCloseOk : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
-(void)write:(AMQPOutputStream *)outputStream;
@end

@interface AccessRequest : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithRealm:(NSString *)realm exclusive:(BOOL)exclusive passive:(BOOL)passive active:(BOOL)active write:(BOOL)write read:(BOOL)read ;
-(void)write:(AMQPOutputStream *)outputStream;
@property NSString * realm;
@property BOOL exclusive;
@property BOOL passive;
@property BOOL active;
@property BOOL write;
@property BOOL read;
@end

@interface AccessRequestOk : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithTicket:(UInt16)ticket ;
-(void)write:(AMQPOutputStream *)outputStream;
@property UInt16 ticket;
@end

@interface ExchangeDeclare : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithTicket:(UInt16)ticket exchange:(NSString *)exchange type:(NSString *)type passive:(BOOL)passive durable:(BOOL)durable autoDelete:(BOOL)autoDelete internal:(BOOL)internal nowait:(BOOL)nowait arguments:(NSDictionary *)arguments ;
-(void)write:(AMQPOutputStream *)outputStream;
@property UInt16 ticket;
@property NSString * exchange;
@property NSString * type;
@property BOOL passive;
@property BOOL durable;
@property BOOL autoDelete;
@property BOOL internal;
@property BOOL nowait;
@property NSDictionary * arguments;
@end

@interface ExchangeDeclareOk : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
-(void)write:(AMQPOutputStream *)outputStream;
@end

@interface ExchangeDelete : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithTicket:(UInt16)ticket exchange:(NSString *)exchange ifUnused:(BOOL)ifUnused nowait:(BOOL)nowait ;
-(void)write:(AMQPOutputStream *)outputStream;
@property UInt16 ticket;
@property NSString * exchange;
@property BOOL ifUnused;
@property BOOL nowait;
@end

@interface ExchangeDeleteOk : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
-(void)write:(AMQPOutputStream *)outputStream;
@end

@interface ExchangeBind : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithTicket:(UInt16)ticket destination:(NSString *)destination source:(NSString *)source routingKey:(NSString *)routingKey nowait:(BOOL)nowait arguments:(NSDictionary *)arguments ;
-(void)write:(AMQPOutputStream *)outputStream;
@property UInt16 ticket;
@property NSString * destination;
@property NSString * source;
@property NSString * routingKey;
@property BOOL nowait;
@property NSDictionary * arguments;
@end

@interface ExchangeBindOk : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
-(void)write:(AMQPOutputStream *)outputStream;
@end

@interface ExchangeUnbind : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithTicket:(UInt16)ticket destination:(NSString *)destination source:(NSString *)source routingKey:(NSString *)routingKey nowait:(BOOL)nowait arguments:(NSDictionary *)arguments ;
-(void)write:(AMQPOutputStream *)outputStream;
@property UInt16 ticket;
@property NSString * destination;
@property NSString * source;
@property NSString * routingKey;
@property BOOL nowait;
@property NSDictionary * arguments;
@end

@interface ExchangeUnbindOk : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
-(void)write:(AMQPOutputStream *)outputStream;
@end

@interface QueueDeclare : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithTicket:(UInt16)ticket queue:(NSString *)queue passive:(BOOL)passive durable:(BOOL)durable exclusive:(BOOL)exclusive autoDelete:(BOOL)autoDelete nowait:(BOOL)nowait arguments:(NSDictionary *)arguments ;
-(void)write:(AMQPOutputStream *)outputStream;
@property UInt16 ticket;
@property NSString * queue;
@property BOOL passive;
@property BOOL durable;
@property BOOL exclusive;
@property BOOL autoDelete;
@property BOOL nowait;
@property NSDictionary * arguments;
@end

@interface QueueDeclareOk : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithQueue:(NSString *)queue messageCount:(UInt32)messageCount consumerCount:(UInt32)consumerCount ;
-(void)write:(AMQPOutputStream *)outputStream;
@property NSString * queue;
@property UInt32 messageCount;
@property UInt32 consumerCount;
@end

@interface QueueBind : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithTicket:(UInt16)ticket queue:(NSString *)queue exchange:(NSString *)exchange routingKey:(NSString *)routingKey nowait:(BOOL)nowait arguments:(NSDictionary *)arguments ;
-(void)write:(AMQPOutputStream *)outputStream;
@property UInt16 ticket;
@property NSString * queue;
@property NSString * exchange;
@property NSString * routingKey;
@property BOOL nowait;
@property NSDictionary * arguments;
@end

@interface QueueBindOk : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
-(void)write:(AMQPOutputStream *)outputStream;
@end

@interface QueuePurge : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithTicket:(UInt16)ticket queue:(NSString *)queue nowait:(BOOL)nowait ;
-(void)write:(AMQPOutputStream *)outputStream;
@property UInt16 ticket;
@property NSString * queue;
@property BOOL nowait;
@end

@interface QueuePurgeOk : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithMessageCount:(UInt32)messageCount ;
-(void)write:(AMQPOutputStream *)outputStream;
@property UInt32 messageCount;
@end

@interface QueueDelete : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithTicket:(UInt16)ticket queue:(NSString *)queue ifUnused:(BOOL)ifUnused ifEmpty:(BOOL)ifEmpty nowait:(BOOL)nowait ;
-(void)write:(AMQPOutputStream *)outputStream;
@property UInt16 ticket;
@property NSString * queue;
@property BOOL ifUnused;
@property BOOL ifEmpty;
@property BOOL nowait;
@end

@interface QueueDeleteOk : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithMessageCount:(UInt32)messageCount ;
-(void)write:(AMQPOutputStream *)outputStream;
@property UInt32 messageCount;
@end

@interface QueueUnbind : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithTicket:(UInt16)ticket queue:(NSString *)queue exchange:(NSString *)exchange routingKey:(NSString *)routingKey arguments:(NSDictionary *)arguments ;
-(void)write:(AMQPOutputStream *)outputStream;
@property UInt16 ticket;
@property NSString * queue;
@property NSString * exchange;
@property NSString * routingKey;
@property NSDictionary * arguments;
@end

@interface QueueUnbindOk : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
-(void)write:(AMQPOutputStream *)outputStream;
@end

@interface BasicQos : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithPrefetchSize:(UInt32)prefetchSize prefetchCount:(UInt16)prefetchCount global:(BOOL)global ;
-(void)write:(AMQPOutputStream *)outputStream;
@property UInt32 prefetchSize;
@property UInt16 prefetchCount;
@property BOOL global;
@end

@interface BasicQosOk : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
-(void)write:(AMQPOutputStream *)outputStream;
@end

@interface BasicConsume : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithTicket:(UInt16)ticket queue:(NSString *)queue consumerTag:(NSString *)consumerTag noLocal:(BOOL)noLocal noAck:(BOOL)noAck exclusive:(BOOL)exclusive nowait:(BOOL)nowait arguments:(NSDictionary *)arguments ;
-(void)write:(AMQPOutputStream *)outputStream;
@property UInt16 ticket;
@property NSString * queue;
@property NSString * consumerTag;
@property BOOL noLocal;
@property BOOL noAck;
@property BOOL exclusive;
@property BOOL nowait;
@property NSDictionary * arguments;
@end

@interface BasicConsumeOk : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithConsumerTag:(NSString *)consumerTag ;
-(void)write:(AMQPOutputStream *)outputStream;
@property NSString * consumerTag;
@end

@interface BasicCancel : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithConsumerTag:(NSString *)consumerTag nowait:(BOOL)nowait ;
-(void)write:(AMQPOutputStream *)outputStream;
@property NSString * consumerTag;
@property BOOL nowait;
@end

@interface BasicCancelOk : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithConsumerTag:(NSString *)consumerTag ;
-(void)write:(AMQPOutputStream *)outputStream;
@property NSString * consumerTag;
@end

@interface BasicPublish : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithTicket:(UInt16)ticket exchange:(NSString *)exchange routingKey:(NSString *)routingKey mandatory:(BOOL)mandatory immediate:(BOOL)immediate ;
-(void)write:(AMQPOutputStream *)outputStream;
@property UInt16 ticket;
@property NSString * exchange;
@property NSString * routingKey;
@property BOOL mandatory;
@property BOOL immediate;
@end

@interface BasicReturn : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithReplyCode:(UInt16)replyCode replyText:(NSString *)replyText exchange:(NSString *)exchange routingKey:(NSString *)routingKey ;
-(void)write:(AMQPOutputStream *)outputStream;
@property UInt16 replyCode;
@property NSString * replyText;
@property NSString * exchange;
@property NSString * routingKey;
@end

@interface BasicDeliver : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithConsumerTag:(NSString *)consumerTag deliveryTag:(UInt64)deliveryTag redelivered:(BOOL)redelivered exchange:(NSString *)exchange routingKey:(NSString *)routingKey ;
-(void)write:(AMQPOutputStream *)outputStream;
@property NSString * consumerTag;
@property UInt64 deliveryTag;
@property BOOL redelivered;
@property NSString * exchange;
@property NSString * routingKey;
@end

@interface BasicGet : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithTicket:(UInt16)ticket queue:(NSString *)queue noAck:(BOOL)noAck ;
-(void)write:(AMQPOutputStream *)outputStream;
@property UInt16 ticket;
@property NSString * queue;
@property BOOL noAck;
@end

@interface BasicGetOk : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithDeliveryTag:(UInt64)deliveryTag redelivered:(BOOL)redelivered exchange:(NSString *)exchange routingKey:(NSString *)routingKey messageCount:(UInt32)messageCount ;
-(void)write:(AMQPOutputStream *)outputStream;
@property UInt64 deliveryTag;
@property BOOL redelivered;
@property NSString * exchange;
@property NSString * routingKey;
@property UInt32 messageCount;
@end

@interface BasicGetEmpty : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithClusterId:(NSString *)clusterId ;
-(void)write:(AMQPOutputStream *)outputStream;
@property NSString * clusterId;
@end

@interface BasicAck : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithDeliveryTag:(UInt64)deliveryTag multiple:(BOOL)multiple ;
-(void)write:(AMQPOutputStream *)outputStream;
@property UInt64 deliveryTag;
@property BOOL multiple;
@end

@interface BasicReject : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithDeliveryTag:(UInt64)deliveryTag requeue:(BOOL)requeue ;
-(void)write:(AMQPOutputStream *)outputStream;
@property UInt64 deliveryTag;
@property BOOL requeue;
@end

@interface BasicRecoverAsync : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithRequeue:(BOOL)requeue ;
-(void)write:(AMQPOutputStream *)outputStream;
@property BOOL requeue;
@end

@interface BasicRecover : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithRequeue:(BOOL)requeue ;
-(void)write:(AMQPOutputStream *)outputStream;
@property BOOL requeue;
@end

@interface BasicRecoverOk : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
-(void)write:(AMQPOutputStream *)outputStream;
@end

@interface BasicNack : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithDeliveryTag:(UInt64)deliveryTag multiple:(BOOL)multiple requeue:(BOOL)requeue ;
-(void)write:(AMQPOutputStream *)outputStream;
@property UInt64 deliveryTag;
@property BOOL multiple;
@property BOOL requeue;
@end

@interface TxSelect : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
-(void)write:(AMQPOutputStream *)outputStream;
@end

@interface TxSelectOk : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
-(void)write:(AMQPOutputStream *)outputStream;
@end

@interface TxCommit : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
-(void)write:(AMQPOutputStream *)outputStream;
@end

@interface TxCommitOk : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
-(void)write:(AMQPOutputStream *)outputStream;
@end

@interface TxRollback : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
-(void)write:(AMQPOutputStream *)outputStream;
@end

@interface TxRollbackOk : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
-(void)write:(AMQPOutputStream *)outputStream;
@end

@interface ConfirmSelect : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
- (instancetype)initWithNowait:(BOOL)nowait ;
-(void)write:(AMQPOutputStream *)outputStream;
@property BOOL nowait;
@end

@interface ConfirmSelectOk : AMQPMethod
-(instancetype)init;
-(instancetype)initWithData:(NSData *)data;
-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;
-(void)write:(AMQPOutputStream *)outputStream;
@end

