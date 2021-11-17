//首先我们建立一个Person类，并添加一个分类Person+Additon；在分类中添加对象方法、类方法、属性、代理。
//代码如下：

/******************** Person+Addition.h ********************/
#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PersonProtocol <NSObject>

- (void)PersonProtocolMethod;

+ (void)PersonProtocolClassMethod;

@end

@interface Person (Addition)<PersonProtocol>

/* name 属性 */
@property (nonatomic, copy) NSString *personName;

// 类方法
+ (void)printClassName;

// 对象方法
- (void)printName;

@end

NS_ASSUME_NONNULL_END


/******************** Person+Addition.m ********************/
#import "Person+Addition.h"

@implementation Person (Addition)

+ (void)printClassName {
    NSLog(@"printClassName");
}

- (void)printName {
    NSLog(@"printName");
}

#pragma mark - PersonProtocol 方法
- (void)PersonProtocolMethod {
    NSLog(@"PersonProtocolMethod");
}

+ (void)PersonProtocolClassMethod {
    NSLog(@"PersonProtocolClassMethod");
}

@end


// Person 类的 Category 结构体
struct _category_t {
    const char *name;
    struct _class_t *cls;
    const struct _method_list_t *instance_methods;
    const struct _method_list_t *class_methods;
    const struct _protocol_list_t *protocols;
    const struct _prop_list_t *properties;
};

// Person 类的 Category 结构体赋值
static struct _category_t _OBJC_$_CATEGORY_Person_$_Addition __attribute__ ((used, section ("__DATA,__objc_const"))) = 
{
    "Person",
    0, // &OBJC_CLASS_$_Person,
    (const struct _method_list_t *)&_OBJC_$_CATEGORY_INSTANCE_METHODS_Person_$_Addition,
    (const struct _method_list_t *)&_OBJC_$_CATEGORY_CLASS_METHODS_Person_$_Addition,
    (const struct _protocol_list_t *)&_OBJC_CATEGORY_PROTOCOLS_$_Person_$_Addition,
    (const struct _prop_list_t *)&_OBJC_$_PROP_LIST_Person_$_Addition,
};

// Category 数组，如果 Person 有多个分类，则 Category 数组中对应多个 Category
static struct _category_t *L_OBJC_LABEL_CATEGORY_$ [1] __attribute__((used, section ("__DATA, __objc_catlist,regular,no_dead_strip")))= {
    &_OBJC_$_CATEGORY_Person_$_Addition,
};

// Category 中的 「对象方法列表结构体」
// - (void)printName; 对象方法的实现
static void _I_Person_Addition_printName(Person * self, SEL _cmd) {
    NSLog((NSString *)&__NSConstantStringImpl__var_folders_jb_6hgmfgfx44s5vlhxxjmrcxqh0000gn_T_Person_Addition_e519a1_mi_1);
}

// - (void)PersonProtocolMethod; 方法的实现
static void _I_Person_Addition_PersonProtocolMethod(Person * self, SEL _cmd) {
    NSLog((NSString *)&__NSConstantStringImpl__var_folders_jb_6hgmfgfx44s5vlhxxjmrcxqh0000gn_T_Person_Addition_e519a1_mi_2);
}

// Person 分类中添加 「对象方法列表结构体」
static struct /*_method_list_t*/ {
    unsigned int entsize;  // sizeof(struct _objc_method)
    unsigned int method_count;
    struct _objc_method method_list[2];
} _OBJC_$_CATEGORY_INSTANCE_METHODS_Person_$_Addition __attribute__ ((used, section ("__DATA,__objc_const"))) = {
    sizeof(_objc_method),
    2,
    {{(struct objc_selector *)"printName", "v16@0:8", (void *)_I_Person_Addition_printName},
    {(struct objc_selector *)"PersonProtocolMethod", "v16@0:8", (void *)_I_Person_Addition_PersonProtocolMethod}}
};
// 只要是Category中实现了的对象方法（包括代理方法中的对象方法）。都会添加到 对象方法列表结构体 _OBJC_$_CATEGORY_INSTANCE_METHODS_Person_$_Addition中来。
// 如果只是在Person.h中定义，而没有实现，则不会添加。

// Category 中的 「类方法列表结构体」
// + (void)printClassName; 类方法的实现
static void _C_Person_Addition_printClassName(Class self, SEL _cmd) {
    NSLog((NSString *)&__NSConstantStringImpl__var_folders_jb_6hgmfgfx44s5vlhxxjmrcxqh0000gn_T_Person_Addition_e519a1_mi_0);
}

// + (void)PersonProtocolClassMethod; 方法的实现
static void _C_Person_Addition_PersonProtocolClassMethod(Class self, SEL _cmd) {
    NSLog((NSString *)&__NSConstantStringImpl__var_folders_jb_6hgmfgfx44s5vlhxxjmrcxqh0000gn_T_Person_Addition_e519a1_mi_3);
}

// Person 分类中添加 「类方法列表结构体」
static struct /*_method_list_t*/ {
    unsigned int entsize;  // sizeof(struct _objc_method)
    unsigned int method_count;
    struct _objc_method method_list[2];
} _OBJC_$_CATEGORY_CLASS_METHODS_Person_$_Addition __attribute__ ((used, section ("__DATA,__objc_const"))) = {
    sizeof(_objc_method),
    2,
    {{(struct objc_selector *)"printClassName", "v16@0:8", (void *)_C_Person_Addition_printClassName},
    {(struct objc_selector *)"PersonProtocolClassMethod", "v16@0:8", (void *)_C_Person_Addition_PersonProtocolClassMethod}}
};
// 只要是Category中实现了的类方法（包括代理中的类方法）。都会添加到类方法列表结构体 _OBJC_$_CATEGORY_CLASS_METHODS_Person_$_Addition中来。
// 如果只是下Person.h中定义，而没有实现，则不会添加。

// Person 分类中添加 「协议列表结构体」
static struct /*_protocol_list_t*/ {
    long protocol_count;  // Note, this is 32/64 bit
    struct _protocol_t *super_protocols[1];
} _OBJC_PROTOCOL_REFS_PersonProtocol __attribute__ ((used, section ("__DATA,__objc_const"))) = {
    1,
    &_OBJC_PROTOCOL_NSObject
};

// 协议列表 对象方法列表结构体
static struct /*_method_list_t*/ {
    unsigned int entsize;  // sizeof(struct _objc_method)
    unsigned int method_count;
    struct _objc_method method_list[1];
} _OBJC_PROTOCOL_INSTANCE_METHODS_PersonProtocol __attribute__ ((used, section ("__DATA,__objc_const"))) = {
    sizeof(_objc_method),
    1,
    {{(struct objc_selector *)"PersonProtocolMethod", "v16@0:8", 0}}
};

// Category 中「协议列表结构体」
// 协议列表 类方法列表结构体
static struct /*_method_list_t*/ {
    unsigned int entsize;  // sizeof(struct _objc_method)
    unsigned int method_count;
    struct _objc_method method_list[1];
} _OBJC_PROTOCOL_CLASS_METHODS_PersonProtocol __attribute__ ((used, section ("__DATA,__objc_const"))) = {
    sizeof(_objc_method),
    1,
    {{(struct objc_selector *)"PersonProtocolClassMethod", "v16@0:8", 0}}
};

// PersonProtocol 结构体赋值
struct _protocol_t _OBJC_PROTOCOL_PersonProtocol __attribute__ ((used)) = {
    0,
    "PersonProtocol",
    (const struct _protocol_list_t *)&_OBJC_PROTOCOL_REFS_PersonProtocol,
    (const struct method_list_t *)&_OBJC_PROTOCOL_INSTANCE_METHODS_PersonProtocol,
    (const struct method_list_t *)&_OBJC_PROTOCOL_CLASS_METHODS_PersonProtocol,
    0,
    0,
    0,
    sizeof(_protocol_t),
    0,
    (const char **)&_OBJC_PROTOCOL_METHOD_TYPES_PersonProtocol
};
struct _protocol_t *_OBJC_LABEL_PROTOCOL_$_PersonProtocol = &_OBJC_PROTOCOL_PersonProtocol;


// Category 中 「属性列表结构体」
// Person 分类中添加的属性列表
static struct /*_prop_list_t*/ {
    unsigned int entsize;  // sizeof(struct _prop_t)
    unsigned int count_of_properties;
    struct _prop_t prop_list[1];
} _OBJC_$_PROP_LIST_Person_$_Addition __attribute__ ((used, section ("__DATA,__objc_const"))) = {
    sizeof(_prop_t),
    1,
    {{"personName","T@\"NSString\",C,N"}}
};
//只有Person分类中添加的属性列表结构体 _OBJC_$_PROP_LIST_Person_$_Addition，没有成员变量结构体_ivar_list_t 结构体。
//更没有对应的set 方法 / get 方法相关内容。这也直接说明了Category中不能添加成员变量这一事实。

//dyld的加载流程
//我们在iOS底层探索 --- dyld加载流程中详细的探索了dyld的加载流程；而我们之前也说过Category (分类)是在运行时阶段动态加载的；
//而Runtime (运行时)加载的过程离不开我们的dyld。
//dyld 加载的流程大致是这样：
//配置环境变量；
//加载共享缓存；
//初始化主 APP；
//插入动态缓存库；
//链接主程序；
//链接插入的动态库；
//初始化主程序：OC, C++ 全局变量初始化；
//返回主程序入口函数。
//
//我们只需要关心的是第 7 步，因为 Runtime（运行时） 是在这一步初始化的。加载 Category（分类）自然也是在这个过程中。
//初始化主程序中，Runtime 初始化的调用栈如下：
//
//dyldbootstrap::start ---> dyld::_main ---> initializeMainExecutable ---> runInitializers --->
//recursiveInitialization ---> doInitialization ---> doModInitFunctions ---> _objc_init
//最后调用的 _objc_init 是 libobjc 库中的方法， 是 Runtime 的初始化过程，也是 Objective-C 的入口。
//在 _objc_init 这一步中：Runtime 向 dyld 绑定了回调，当 image 加载到内存后，dyld 会通知 Runtime 进行处理，Runtime 接手后调用 map_images 做解析和处理，调用 _read_images 方法把 Category（分类） 的对象方法、协议、属性添加到类上，把 Category（分类） 的类方法、协议添加到类的 metaclass 上；接下来 load_images 中调用 call_load_methods 方法，遍历所有加载进来的 Class，按继承层级和编译顺序依次调用 Class 的 load 方法和其 Category 的 load 方法。
//
//加载Category（分类）的调用栈如下：
//_objc_init ---> map_images ---> map_images_nolock ---> _read_images（加载分类） ---> load_images。
//既然我们知道了 Category（分类）的加载发生在 _read_images 方法中，那么我们只需要关注_read_images 方法中关于分类加载的代码即可。
//
//在这里，我们只需要关系执行初始化方法这一步。我们再来回顾一下_objc_init方法：
//不知道大家还记不记得，我们再探索lldb加载流程的时候，探索到_objc_init方法的时候，找到了关键的一段代码：
//_dyld_objc_notify_register(&map_images, load_images, unmap_image);
//当时我们探索了第二个参数load_images；而我们的Category的加载流程就藏在第一个参数map_images里面。按照我们之前的探索方式，持续的跟进，我们会发现这样一条函数调用栈：
//_objc_init --> map_images --> map_images_nolock --> _read_images
//到这里的时候，我并没有发现关于Category的代码，于是搜索了一下，在_read_images方法里面发现了这个：
//那么就进入load_categories_nolock看一下，突然觉得找对了地方，里面有很多关于关于Category的内容，下面我们一起来探索一下：
static void load_categories_nolock(header_info *hi) {
    bool hasClassProperties = hi->info()->hasCategoryClassProperties();

    size_t count;
    auto processCatlist = [&](category_t * const *catlist) {
        for (unsigned i = 0; i < count; i++) {
            category_t *cat = catlist[i];
            Class cls = remapClass(cat->cls);
            locstamped_category_t lc{cat, hi};

            if (!cls) {
                // Category's target class is missing (probably weak-linked).
                // Ignore the category.
                if (PrintConnecting) {
                    _objc_inform("CLASS: IGNORING category \?\?\?(%s) %p with "
                                 "missing weak-linked target class",
                                 cat->name, cat);
                }
                continue;
            }

            // Process this category.
            if (cls->isStubClass()) {
                // Stub classes are never realized. Stub classes
                // don't know their metaclass until they're
                // initialized, so we have to add categories with
                // class methods or properties to the stub itself.
                // methodizeClass() will find them and add them to
                // the metaclass as appropriate.
                if (cat->instanceMethods ||
                    cat->protocols ||
                    cat->instanceProperties ||
                    cat->classMethods ||
                    cat->protocols ||
                    (hasClassProperties && cat->_classProperties))
                {
                    objc::unattachedCategories.addForClass(lc, cls);
                }
            } else {
                // First, register the category with its target class.
                // Then, rebuild the class's method lists (etc) if
                // the class is realized.
                if (cat->instanceMethods ||  cat->protocols
                    ||  cat->instanceProperties)
                {
                    if (cls->isRealized()) {
                        attachCategories(cls, &lc, 1, ATTACH_EXISTING);
                    } else {
                        objc::unattachedCategories.addForClass(lc, cls);
                    }
                }

                if (cat->classMethods  ||  cat->protocols
                    ||  (hasClassProperties && cat->_classProperties))
                {
                    if (cls->ISA()->isRealized()) {
                        attachCategories(cls->ISA(), &lc, 1, ATTACH_EXISTING | ATTACH_METACLASS);
                    } else {
                        objc::unattachedCategories.addForClass(lc, cls->ISA());
                    }
                }
            }
        }
    };

    processCatlist(hi->catlist(&count));
    processCatlist(hi->catlist2(&count));
}
//这里看到attachCategories这个函数，跟进去（注意看官方注释，这个很重要，顿时豁然开朗，这就是要找的核心代码呀!!!）：
// Attach method lists and properties and protocols from categories to a class.
// Assumes the categories in cats are all loaded and sorted by load order, 
// oldest categories first.
static void 
attachCategories(Class cls, category_list *cats, bool flush_caches)
{
    if (!cats) return;
    if (PrintReplacedMethods) printReplacements(cls, cats);

    bool isMeta = cls->isMetaClass();

    // 创建方法列表、属性列表、协议列表，用来存储分类的方法、属性、协议
    method_list_t **mlists = (method_list_t **)
        malloc(cats->count * sizeof(*mlists));
    property_list_t **proplists = (property_list_t **)
        malloc(cats->count * sizeof(*proplists));
    protocol_list_t **protolists = (protocol_list_t **)
        malloc(cats->count * sizeof(*protolists));

    // Count backwards through cats to get newest categories first
    int mcount = 0;           // 记录方法的数量
    int propcount = 0;        // 记录属性的数量
    int protocount = 0;       // 记录协议的数量
    int i = cats->count;      // 从分类数组最后开始遍历，保证先取的是最新的分类
    bool fromBundle = NO;     // 记录是否是从 bundle 中取的
    while (i--) { // 从后往前依次遍历
        auto& entry = cats->list[i];  // 取出当前分类
    
        // 取出分类中的方法列表。如果是元类，取得的是类方法列表；否则取得的是对象方法列表
        method_list_t *mlist = entry.cat->methodsForMeta(isMeta);
        if (mlist) {
            mlists[mcount++] = mlist;            // 将方法列表放入 mlists 方法列表数组中
            fromBundle |= entry.hi->isBundle();  // 分类的头部信息中存储了是否是 bundle，将其记住
        }

        // 取出分类中的属性列表，如果是元类，取得的是 nil
        property_list_t *proplist = 
            entry.cat->propertiesForMeta(isMeta, entry.hi);
        if (proplist) {
            proplists[propcount++] = proplist;
        }

        // 取出分类中遵循的协议列表
        protocol_list_t *protolist = entry.cat->protocols;
        if (protolist) {
            protolists[protocount++] = protolist;
        }
    }

    // 取出当前类 cls 的 class_rw_t 数据
    auto rw = cls->data();

    // 存储方法、属性、协议数组到 rw 中
    // 准备方法列表 mlists 中的方法
    prepareMethodLists(cls, mlists, mcount, NO, fromBundle);
    // 将新方法列表添加到 rw 中的方法列表中
    rw->methods.attachLists(mlists, mcount);
    // 释放方法列表 mlists
    free(mlists);
    // 清除 cls 的缓存列表
    if (flush_caches  &&  mcount > 0) flushCaches(cls);

    // 将新属性列表添加到 rw 中的属性列表中
    rw->properties.attachLists(proplists, propcount);
    // 释放属性列表
    free(proplists);

    // 将新协议列表添加到 rw 中的协议列表中
    rw->protocols.attachLists(protolists, protocount);
    // 释放协议列表
    free(protolists);
}

// 看上面代码的最后两行，可以看到协议和属性调用了同一个方法attachLists：
void attachLists(List* const * addedLists, uint32_t addedCount) {
        if (addedCount == 0) return;

        if (hasArray()) {
            // many lists -> many lists
            uint32_t oldCount = array()->count;
            uint32_t newCount = oldCount + addedCount;
            array_t *newArray = (array_t *)malloc(array_t::byteSize(newCount));
            newArray->count = newCount;
            array()->count = newCount;

            ///根据下面的代码，可以看出来，分类中的方法会被添加到原有方法的前面。
            ///在方法查询的时候，分类中的方法会先被查到并返回。
            ///如果分类中定义了和原类中一样的方法，那么只会执行分类中的方法。
            for (int i = oldCount - 1; i >= 0; i--)
                newArray->lists[i + addedCount] = array()->lists[i];
            for (unsigned i = 0; i < addedCount; i++)
                newArray->lists[i] = addedLists[i];
            free(array());
            setArray(newArray);
            validate();
        }
        else if (!list  &&  addedCount == 1) {
            // 0 lists -> 1 list
            list = addedLists[0];
            validate();
        } 
        else {
            // 1 list -> many lists
            Ptr<List> oldList = list;
            uint32_t oldCount = oldList ? 1 : 0;
            uint32_t newCount = oldCount + addedCount;
            setArray((array_t *)malloc(array_t::byteSize(newCount)));
            array()->count = newCount;
            if (oldList) array()->lists[addedCount] = oldList;
            for (unsigned i = 0; i < addedCount; i++)
                array()->lists[i] = addedLists[i];
            validate();
        }
    }
//这里有一点很重要，注意看我在attachLists中的注释。不过我还是要再强调一遍：
//分类中的方法会被添加到原有方法的前面。
//在方法查询的时候，分类中的方法会先被查到并返回。
//如果分类中定义了和原类中一样的方法，那么只会执行分类中的方法。
//由此可见，Category在运行时被加载的流程如下：
//_objc_init --> map_images --> map_images_nolock --> _read_images --> attachCategories --> attachLists
//Category（分类）和 Class（类）的+load方法
//Category（分类）中的方法、属性、协议附加到类上面的操作，是在+load方法执行之前进行的。也就是说+load方法执行之前，类中就已经加载了Category（分类）中的方法、属性、协议。
//
//而 Category（分类）和 Class（类）的+load方法的调用顺序规则如下所示：
//
//先调用主类，按照编译顺序，依次根据继承关系，由父类向子类调用；
//调用完主类，再调用分类，按照编译顺序，依次调用；
//+load方法除非主动调用，否则只会调用一次。
//通过这样的调用规则，我们可以知道：主类的+load方法一定在分类+load方法之前调用。但是分类的+load方法调用顺序并不是按照继承关系调用的，而是按照编译顺序确定的，这一导致了+load方法的调用顺序并不确定。
//可能是：父类 -> 子类 -> 父类分类 -> 子类分类；
//也可能是：父类 -> 子类 -> 子类分类 -> 父类分类。
