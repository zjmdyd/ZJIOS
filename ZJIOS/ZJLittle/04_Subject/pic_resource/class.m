struct objc_object {
    Class _Nonnull isa  OBJC_ISA_AVAILABILITY;
};

typedef struct objc_class *Class;

struct objc_class {
    //结构体的第一个成员变量也是isa指针，这就说明了Class本身其实也是一个对象，因此我们称之为类对象，类对象在编译期产生用于创建实例对象，是单例。
    Class _Nonnull isa  OBJC_ISA_AVAILABILITY;

#if !__OBJC2__
    Class _Nullable super_class                              OBJC2_UNAVAILABLE;
    const char * _Nonnull name                               OBJC2_UNAVAILABLE;
    long version                                             OBJC2_UNAVAILABLE;
    long info                                                OBJC2_UNAVAILABLE;
    long instance_size                                       OBJC2_UNAVAILABLE;
    struct objc_ivar_list * _Nullable ivars                  OBJC2_UNAVAILABLE;
    struct objc_method_list * _Nullable * _Nullable methodLists                    OBJC2_UNAVAILABLE;
    struct objc_cache * _Nonnull cache                       OBJC2_UNAVAILABLE;
    struct objc_protocol_list * _Nullable protocols          OBJC2_UNAVAILABLE;
#endif

} OBJC2_UNAVAILABLE;
// methodList是一个二维数组，所以可以修改*methodLists的值来增加成员方法，
// 虽没办法扩展methodLists指向的内存区域，却可以改变这个内存区域的值（存储的是指针）。因此，可以动态添加方法，不能添加成员变量。

typedef struct objc_ivar *Ivar;
//表示类中实例变量的类型,objc_ivar可以根据实例查找其在类中的名字，也就是“反射”;
struct objc_ivar {
    char * _Nullable ivar_name                               OBJC2_UNAVAILABLE;
    char * _Nullable ivar_type                               OBJC2_UNAVAILABLE;
    int ivar_offset                                          OBJC2_UNAVAILABLE;
#ifdef __LP64__
    int space                                                OBJC2_UNAVAILABLE;
#endif
} 
// 成员变量列表
struct objc_ivar_list {
   int ivar_count                                           OBJC2_UNAVAILABLE;
#ifdef __LP64__
   int space                                                OBJC2_UNAVAILABLE;
#endif
   /* variable length structure */
   struct objc_ivar ivar_list[1]                            OBJC2_UNAVAILABLE;
} 

/// An opaque type that represents a method in a class definition.
typedef struct objc_method *Method;
struct objc_method {
    SEL _Nonnull method_name                                 OBJC2_UNAVAILABLE;
    //方法的参数类型和返回值类型。
    char * _Nullable method_types                            OBJC2_UNAVAILABLE;
    //方法的实现，本质上是一个函数指针
    IMP _Nonnull method_imp                                  OBJC2_UNAVAILABLE;
}   
// 方法列表
struct objc_method_list {
    struct objc_method_list * _Nullable obsolete             OBJC2_UNAVAILABLE;

    int method_count                                         OBJC2_UNAVAILABLE;
#ifdef __LP64__
    int space                                                OBJC2_UNAVAILABLE;
#endif
    /* variable length structure */
    struct objc_method method_list[1]                        OBJC2_UNAVAILABLE;
}   

//cache为方法调用的性能进行优化，通俗的讲，每当实例对象接收到一个消息时候，它不会直接在isa指向的类方法的方法列表中遍历查找能够响应消息的方法，效率太低了，而是有限在cache中查找。Runtime系统会把被调用的方法存在cache中，下次查找的时候效率更高。
struct objc_cache {
    unsigned int mask /* total = mask + 1 */                 OBJC2_UNAVAILABLE;
    unsigned int occupied                                    OBJC2_UNAVAILABLE;
    Method _Nullable buckets[1]                              OBJC2_UNAVAILABLE;
};

/// An opaque type that represents a method selector.
typedef struct objc_selector *SEL;
// objc_msgSend函数第二个参数类型为SEL，它是selector在Objective-C中的表示类型
objc_msgSend(id _Nullable self, SEL _Nonnull op, ...)

// IMP:A pointer to the function of a method implementation. 指向一个方法实现的指针
typedef id _Nullable (*IMP)(id _Nonnull, SEL _Nonnull, ...); 

//分类中可以添加实例方法，类方法，甚至可以实现协议，添加属性，不可以添加成员变量。
struct category_t {
    //是指 class_name 而不是 category_name。
    const char *name;
    //要扩展的类对象，编译期间是不会定义的，而是在Runtime阶段通过name对 应到对应的类对象。
    classref_t cls;
    struct method_list_t *instanceMethods;
    //category中所有添加的类方法的列表。
    struct method_list_t *classMethods;
    //category实现的所有协议的列表。
    struct protocol_list_t *protocols;
    struct property_list_t *instanceProperties;
    // Fields below this point are not always present on disk.
    struct property_list_t *_classProperties;

    method_list_t *methodsForMeta(bool isMeta) {
        if (isMeta) return classMethods;
        else return instanceMethods;
    }

    property_list_t *propertiesForMeta(bool isMeta, struct header_info *hi);
};

//@property标记了类中的属性，它是一个指向objc_property结构体的指针：
typedef struct objc_property *objc_property_t;
//通过class_copyPropertyList和protocol_copyPropertyList方法来获取类和协议中的属性
OBJC_EXPORT objc_property_t _Nonnull * _Nullable
class_copyPropertyList(Class _Nullable cls, unsigned int * _Nullable outCount)
OBJC_EXPORT objc_property_t _Nonnull * _Nullable
protocol_copyPropertyList(Protocol * _Nonnull proto,
                          unsigned int * _Nullable outCount)
unsigned int number = 0
objc_property_t *propertys = class_copyPropertyList([self class], &number);
 for (int i = 0; i < number; i ++) {
       objc_property_t property = propertys[i];
       const char *name = property_getName(property);
       const char *type = property_getAttributes(property);
       NSString *nameStr = [NSString stringWithUTF8String:name];
       NSString *typeStr = [NSString stringWithUTF8String:type];
       NSLog(@"name === %@   type === %@", nameStr, typeStr);
 }
