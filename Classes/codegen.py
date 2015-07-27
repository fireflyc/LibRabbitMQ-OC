import sys

sys.path.append("./rabbitmq-codegen")

from amqp_codegen import *


ocTypeMap = {
    'octet': 'UInt8',
    'shortstr': 'NSString *',
    'longstr': 'NSString *',
    'short': 'UInt16',
    'long': 'UInt32',
    'longlong': 'UInt64',
    'bit': 'BOOL',
    'table': 'NSDictionary *',
    'timestamp': 'NSDate *'
}

def oc_name(upperNext, name):
    out = ''
    for c in name:
        if not c.isalnum():
            upperNext = True
        elif upperNext:
            out += c.upper()
            upperNext = False
        else:
            out += c
    return out


def oc_class_name(name):
    return oc_name(True, name)


def oc_property_name(name):
    return oc_name(False, name)


def oc_property_type(spec, domain):
    return ocTypeMap[spec.resolveDomain(domain)]


def oc_constant_name(c):
    return '_'.join(re.split('[- ]', c.upper()))


def generateH(specPath):
    spec = AmqpSpec(specPath)
    print '#import <Foundation/Foundation.h>'
    print '#import "AMQPStream.h" \n'
    print '#define AMQP_PROTOCOL_VERSION_MAJOR %s\n#define AMQP_PROTOCOL_VERSION_MINOR %s\n#define AMQP_PROTOCOL_VERSION_REVISION %s\n' % (
        spec.major, spec.minor, spec.revision)
    print '#define AMQP_HEADER_SIZE 7\n#define AMQP_FOOTER_SIZE 1\n'
    for (c, v, cls) in spec.constants:
        print '#define AMQP_%s %s' % (oc_constant_name(c), v)

    print '#define AMQP_BASIC_PROPERTIES_CLASS_ID 60'
    print """
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
"""
    for c in spec.classes:
        if c.hasContentProperties:
            print '@interface AMQP%sProperties:NSObject' % (oc_class_name(c.name))
            for f in c.fields:
                print '@property %s %s;' % (oc_property_type(spec, f.domain), oc_property_name(f.name))
            print '@end\n'

    for c in spec.allClasses():
        for m in c.allMethods():
            print '@interface %s%s : AMQPMethod' % (oc_class_name(c.name), oc_class_name(m.name))
            print '-(instancetype)init;'
            print '-(instancetype)initWithData:(NSData *)data;'
            print '-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream;'
            param = ""
            for a in m.arguments:
                p_name = oc_property_name(a.name)
                if param is "":
                    p_name = p_name[0].upper() + p_name[1:]
                param += "%s:(%s)%s " % (
                    p_name, oc_property_type(spec, a.domain), oc_property_name(a.name))
            if not param is "":
                print '- (instancetype)initWith' + param + ";"
            print '-(void)write:(AMQPOutputStream *)outputStream;'
            for a in m.arguments:
                print '@property %s %s;' % (oc_property_type(spec, a.domain), oc_property_name(a.name))
            print '@end\n'


def printProperties(spec):
    for c in spec.classes:
        if c.hasContentProperties:
            print '@implementation AMQP%sProperties{' % ((oc_class_name(c.name)))
            print '}'
            print '@end'


def generateC(specPath):
    spec = AmqpSpec(specPath)
    print '#import <Foundation/Foundation.h>\n'
    print '#import "AMQP.h"\n'
    print """
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
"""
    printProperties(spec)
    print '@implementation AMQP{'
    print '}'
    print '+ (AMQPMethod *)readMethod:(AMQPInputStream *)inputStream {'
    print '\tUInt16 classId = [inputStream AMQPReadUInt16];'
    print '\tUInt16 methodNumber = [inputStream AMQPReadUInt16];'
    print '\t[inputStream resetToOffset:AMQP_HEADER_SIZE];'
    for c in spec.allClasses():
        print '\tswitch(classId){'
        print '\t\tcase %s:' % (c.index)
        print '\t\t\tswitch(methodNumber){'
        for m in c.allMethods():
            print '\t\t\t\tcase %s:' % (m.index)
            print '\t\t\t\t\t return [[%s%s alloc] initWithInputStream:inputStream];' % (
                oc_class_name(c.name), oc_class_name(m.name))
        print '\t\t\t\tdefault:break;'
        print '\t\t\t}'
        print '\t\t\tdefault:break;'
        print '\t\t}'
    print '\treturn nil;'
    print '};'
    print '@end'
    for c in spec.allClasses():
        for m in c.allMethods():
            print '@implementation %s%s{\n' % (oc_class_name(c.name), oc_class_name(m.name))
            print '}\n'
            print '-(instancetype)init{'
            print '\tself = [super init];'
            print '\tif (self) {'
            print '\t\tself.amqpMethodClassId = %s;' % (c.index)
            print '\t\tself.amqpMethodId = %s;' % (m.index)
            print '\t}'
            print '\treturn self;'
            print '}'
            print """
-(instancetype)initWithData:(NSData *)data{
	self = [super init];
	if (self){
		AMQPInputStream *inputStream = [[AMQPInputStream alloc] initWithData:data];
        self = [self initWithInputStream:inputStream];
    }
	return self;
}
            """
            print '-(instancetype)initWithInputStream:(AMQPInputStream *)inputStream{'
            print '\tself = [super initWithInputStream:inputStream];'
            print '\tif (self){'
            bool_bits = 0
            no_read_bits = True
            for a in m.arguments:
                type_name = oc_property_type(spec, a.domain)
                amqp_type = spec.resolveDomain(a.domain)
                if amqp_type == 'bit':
                    if no_read_bits:
                        print '\t\tUInt8 bits = [inputStream AMQPReadUInt8];'
                        no_read_bits = False
                    print '\t\tself.%s = (bits & (1 << %s)) ? TRUE : FALSE;' % (oc_property_name(a.name), bool_bits)
                    bool_bits += 1
                else:
                    if amqp_type == 'shortstr':
                        print '\t\tself.%s = [inputStream AMQPReadShortStr];' % (oc_property_name(a.name))
                    elif amqp_type == 'longstr':
                        print '\t\tself.%s = [inputStream AMQPReadLongStr];' % (oc_property_name(a.name))
                    else:
                        print '\t\tself.%s = [inputStream AMQPRead%s];' % (oc_property_name(a.name),
                                                                           type_name.replace("*", "").strip())
            print '\t}\n\treturn self;'
            print '}\n'
            param = ""
            set_code = ""
            for a in m.arguments:
                p_name = oc_property_name(a.name)
                if param is "":
                    p_name = p_name[0].upper() + p_name[1:]
                param += "%s:(%s)%s " % (
                    p_name, oc_property_type(spec, a.domain), oc_property_name(a.name))
                set_code += "\t\tself.%s = %s;\n" % (oc_property_name(a.name), oc_property_name(a.name))
            if not param is "":
                print '- (instancetype)initWith' + param + "{"
                print '\tself = [super init];'
                print '\tif (self){'
                print '\t\tself.amqpMethodClassId = %s;' % (c.index)
                print '\t\tself.amqpMethodId = %s;' % (m.index)
                print set_code
                print '\t}'
                print '\treturn self;'
                print '}'
            print '-(void)write:(AMQPOutputStream *)outputStream{'
            print '\t[super write:outputStream];'
            bool_bits = 0
            no_write_bits = True
            for a in m.arguments:
                type_name = oc_property_type(spec, a.domain)
                amqp_type = spec.resolveDomain(a.domain)
                if amqp_type == 'bit':
                    if no_write_bits:
                        print '\tUInt8 bits = 0;'
                        no_write_bits = False
                    print '\tif(self.%s) bits |= (1<<%s);' % (oc_property_name(a.name), bool_bits)
                    bool_bits += 1
                else:
                    if not bool_bits is 0:
                        print '\t[outputStream AMQPWriteUInt8:bits];'
                        bool_bits = 0
                    if amqp_type == 'shortstr':
                        print '\t[outputStream AMQPWriteShortStr:self.%s];' % (oc_property_name(a.name))
                    elif amqp_type == 'longstr':
                        print '\t[outputStream AMQPWriteLongStr:self.%s];' % (oc_property_name(a.name))
                    else:
                        print '\t[outputStream AMQPWrite%s:self.%s];' % (type_name.replace("*", "").strip(),
                                                                         oc_property_name(a.name))
            if not bool_bits is 0:
                print '\t[outputStream AMQPWriteUInt8:bits];'
            print '}\n'

            print '-(BOOL)hasContent{'
            print '\treturn %s;' % ('TRUE' if m.hasContent else 'FALSE')
            print '}'
            print '@end\n'


if __name__ == '__main__':
    do_main(generateH, generateC)
