//
//  ZJRuntimeViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/15.
//

#import "ZJRuntimeViewController.h"
#include <objc/runtime.h>
#import "NSObject+ZJRuntime.h"
#import "NSObject+ZJMethodSwizzling.h"
#import "Son.h"
#import "Student.h"

@interface ZJRuntimeViewController ()

@end

@implementation ZJRuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
}

- (void)initAry {
    self.vcType = ZJBaseTableViewTypeExecute;
    self.cellTitles = @[@"nextResponder", @"object_getClass1", @"object_getClass2", @"objc_getClass", @"swizzledMethod1", @"swizzledMethod_addClasMethod", @"swizzledMethod3", @"testIMP", @"testSuperClass"];
    self.values = @[@"test0", @"test1", @"test2", @"test3", @"test4", @"test5", @"test6", @"test7", @"test8"];
}

- (void)test0 {
    NSLog(@"nextResponder = %@", [self.view nextResponderWithTargetClassName:@"ZJRuntimeViewController"]);
}

- (void)test1 {
    NSString *str = @"hhhh";    // 实例对象
    Class s0 = [str class];     // 类对象   [str class] == object_getClass(str),实例对象调用class()方法等同于调用object_getClass()
    Class s1 = [s0 class];      // 类对象的[s0 class]方法无实际作用
    Class s2 = object_getClass(s0); // 元类对象, 类对象调用object_getClass(s0)获得元类对象
    Class s3 = object_getClass(s2); // 根元类, 元类对象调用object_getClass(s2)获得根元类
    NSLog(@"str = %@, object_getClass(str) = %@", str, object_getClass(str));   // str = hhhh, object_getClass(str) = __NSCFConstantString
    NSLog(@"s0 = %@, object_getClass(s0) = %@", s0, object_getClass(s0));   // s0 = __NSCFConstantString, object_getClass(s0) = __NSCFConstantString
    NSLog(@"s1 = %@, object_getClass(s1) = %@", s1, object_getClass(s1));   // s1 = __NSCFConstantString, object_getClass(s1) = __NSCFConstantString
    NSLog(@"s2 = %@, object_getClass(s2) = %@", s2, object_getClass(s2));   // s2 = __NSCFConstantString, object_getClass(s2) = NSObject
    NSLog(@"s3 = %@, object_getClass(s3) = %@", s3, object_getClass(s3));   // s3 = NSObject, object_getClass(s3) = NSObject
    
    NSLog(@"class_isMetaClass(s0) = %d", class_isMetaClass(s0)); // 0
    NSLog(@"class_isMetaClass(s1) = %d", class_isMetaClass(s1)); // 0
    NSLog(@"class_isMetaClass(s2) = %d", class_isMetaClass(s2)); // 1
    NSLog(@"class_isMetaClass(s3) = %d", class_isMetaClass(s3)); // 1
}

- (void)test2 {
    NSObject *obj = [NSObject new];     // 实例对象
    Class objClass = [NSObject class];  // 类对象
    Class metaClass = object_getClass(objClass);    // 元类对象
    Class rMetaClass = object_getClass(metaClass);    // 根元类对象
    NSLog(@"obj = %@, objClass = %@", obj, objClass);
    NSLog(@"metaClass = %@, rMetaClass = %@", metaClass, rMetaClass);
    
    NSLog(@"objClass = %d", class_isMetaClass(objClass));   // 0
    NSLog(@"[objClass class] = %d", class_isMetaClass([objClass class]));   // 0
    NSLog(@"metaClass = %d", class_isMetaClass(metaClass)); // 1
    NSLog(@"rMetaClass = %d", class_isMetaClass(metaClass)); // 1
}

- (void)test3 {
    const char *a = "NSString";
    NSLog(@"objc_getClass(a) = %@", objc_getClass(a));  // NSString
    
    const char *b = "hello";
    NSLog(@"objc_getClass(b) = %@", objc_getClass(b));  // (null)
}

- (void)test4 {
    [ZJRuntimeViewController exchangeMethod:@selector(funA) swizzledSelector:@selector(funB)];
    [self funA];    // 方法B
    [self funB];    // 方法A
}

- (void)funA {
    NSLog(@"方法A");
}

- (void)funB {
    NSLog(@"方法B");
}

- (void)test5 {
    [ZJRuntimeViewController exchangeMethod:@selector(funC) swizzledSelector:@selector(funD)];
    // 如果没有funcC，则会添加funcC，但是方法的实现是用funcD
    [self performSelector:@selector(funC)]; // 方法D
    [self performSelector:@selector(funD)]; // 方法D
}
//
//- (void)funC {//    NSLog(@"方法C");//}

- (void)funD {
    NSLog(@"方法D");
}

- (void)test6 {
    Son *son = [Son new];
    [son eat];          // 调用eatAnother(), --> son eatAnother, self = Son
    [son eatAnother];   // 调用eat(), --> eat, self = Son
    
    Father *father = [Father new];
    [father eat];       // 调用eat(), --> eat, self = Father
}

/*
 Objective-C调用方法的时候，传递的所有参数，还包括两个隐藏的参数：
 目标对象
 调用的方法SEL
 
 如: BOOL class_addMethod(Class cls, SEL name, IMP imp, const char *types);
 参数详解
 参数名    类型    说明
 cls    Class   目标类对象，通常传入[ClassName class]
 name   SEL     方法选择器，使用@ selector(methodName)格式指定
 imp    IMP     函数指针，指向方法的具体实现（需包含self和_cmd参数）
 types  const char*     方法类型编码字符串，描述返回值类型和参数类型
 
 void jump2(id self, SEL sel, id metter) {
 NSLog(@"跳了%@米", metter);
 NSLog(@"self = %@, sel = %@", self, NSStringFromSelector(sel));
 }
 当需要大量重复调用方法的时候，我们可以绕开消息绑定而直接利用IMP指针调起方法，这样的执行将会更加高效
 */
//testIMP
- (void)test7 {
    void (*setter)(id, SEL, int);
    int i;
    
    setter =  (void (*)(id, SEL, int))[self methodForSelector:@selector(setFilled:)];
    for ( i = 0 ; i < 10 ; i++ )
        setter(self, @selector(setFilled:), i);
}

- (void)setFilled:(NSInteger)number {
    NSLog(@"number = %ld", (long)number);
}

- (void)test8 {
    Student *stu = [Student new];
    [stu testSuperClass];
}

//- (void)test1 {
//    unsigned int numIvars; // 成员变量个数
////    Method *meth = class_copyMethodList(NSClassFromString(@"ZJTestFloatViewController"), &numIvars);
//    Method *meth = class_copyMethodList([ZJTestFloatViewController class], &numIvars);
//    NSLog(@"numIvars = %d", numIvars);
//    
//    for(int i = 0; i < numIvars; i++) {
//        Method thisIvar = meth[i];
//        SEL sel = method_getName(thisIvar);
//        IMP im = method_getImplementation(thisIvar);
//        const char *name = sel_getName(sel);
//        NSLog(@"zp method :%s", name);
//        NSString *selString =  NSStringFromSelector(sel);
//        NSLog(@"selString :%@", selString);
//    }
//    
//    free(meth);
//}

//Class objc_allocateClassPair(Class superclass, const char *name,
//                             size_t extraBytes)
//{
//    Class cls, meta;
//
//    rwlock_writer_t lock(runtimeLock);
//
//    // 如果 Class 名字已存在或父类没有通过认证则创建失败
//    if (getClass(name)  ||  !verifySuperclass(superclass, true/*rootOK*/)) {
//        return nil;
//    }
//
//    //分配空间
//    cls  = alloc_class_for_subclass(superclass, extraBytes);
//    meta = alloc_class_for_subclass(superclass, extraBytes);
//
//    //构建meta和class的关系
//    objc_initializeClassPair_internal(superclass, name, cls, meta);
//
//    return cls;
//}

/*
 OC对象的分类主要可以分为三种:
 instance对象 (实例对象)
 class对象 (类对象)
 meta-class对象 (元类对象)
 元类(类对象的类)
 所有的类自身也是一个对象，我们可以向这个对象发送消息(即调用类方法)。如：
 NSArray *array = [NSArray array];
 这个例子中，+array消息发送给了NSArray类，而这个NSArray也是一个对象。既然是对象，那么它也是一个objc_object指针，它包含一个指向其类的一个isa指针，这个isa指针也要指向这个类所属的类。那么这些就有一个问题了，这个isa指针指向什么呢？这就引出了meta-class的概念：
 meta-class是一个类对象的类
 当我们向一个对象发送消息时，runtime会在这个对象所属的这个类的方法列表中查找方法；而向一个类发送消息时，会在这个类的meta-class的方法列表中查找。
 
 meta-class 是必须的，因为它为一个 Class 存储类方法。每个Class都必须有一个唯一的 meta-class，因为每个Class的类方法基本不可能完全相同。
 再深入一下，meta-class也是一个类，也可以向它发送一个消息，那么它的isa又是指向什么呢？为了不让这种结构无限延伸下去，Objective-C的设计者让所有的meta-class的isa指向基类的meta-class，以此作为它们的所属类。即，任何NSObject继承体系下的meta-class都使用NSObject的meta-class作为自己的所属类 （在一定程度上可以理解为若一个Class继承自NSObject，则这个Class的meta-class继承自NSObject的meta-class），而基类的meta-class的isa指针是指向它自己，这就是说 NSObject 的 meta-class 的 isa 指针指向NSObject 的 meta-class自己。这样就形成了一个完美的闭环。
 
 可以看到，对象最基本的就是有一个isa指针，指向他的class，而Class本身是继承自object。isa指针的理解就是英文is a，代表“xxx is a （class）”。那么也就是说，一个对象的isa指向哪个class，代表它是那个类的对象。那么对于class来说，它也是一个对象，它的isa指针指向什么呢？
 对于Class来说，也就需要一个描述他的类，也就是“类的类”，而meta正是“关于某事自身的某事”的解释，所以MetaClass就因此而生了。
 
 对象 (objc_object 结构体)的isa 指针指向的是对应的类对象 (object_class 结构体)。那么类对象 (object_class 结构体)的isa 指针又指向哪里呢？
 object_class 结构体的isa 指针实际上指向的是类对象自身的Meta Class (元类)。
 Meta Class (元类)就是一个类对象所属的类。一个对象所属的类叫做类对象，而一个类对象所属的类就叫做元类。
 Runtime中，把类对象的所属类型叫做Meta Class (元类)，用于描述类对象本身所具有的特征，而在元类的methodLists中，保存了类的方法链表，即所谓的「类方法」。并且类对象中的isa 指针指向的就是元类。每个类对象有且仅有一个与之相关的元类。
 */
/*runtime
 特性： 编写的代码具有运行时、动态特性
 在编译阶段，OC 可以 调用任何函数，即使这个函数并未实现，只要声明过就不会报错，只有当运行的时候才会报错，这是因为OC是运行时动态调用的。而 C 语言 调用未实现的函数 就会报错。
 用来干什么? 基本作用
 在程序运行过程中，动态的创建类，动态添加、修改这个类的属性和方法；
 遍历一个类中所有的成员变量、属性、以及所有方法
 消息传递、转发
 用在哪些地方 Runtime的典型事例:
 给系统分类添加属性、方法
 方法交换
 获取对象的属性、私有属性
 字典转换模型
 KVC、KVO
 归档(编码、解码)
 消息传递的关键要素
 指向superclass的指针
 会有一个SEL跟方法实现的地址(这个地址是基于独立的类)关联的表
 当创建一个新的对象时，分配内存，初始化变量，对象变量中的第一个是指向该类结构的指针，这个名字为isa的指针能让对象可以访问它的类，并通过该类访问它继承的所有类
 
 Objc-msgSend的发送过程
 消息发送给对象时，消息传递函数遵循对象的isa指针指向类结构的指针，在该结构中它查询结构体变量methodLists中的方法SEL(方法选择器)
 如在isa指向的类结构中找不到SEL(方法选择器)，Objc_msgSend会跟随指向Supercalss(父类)指针并再次尝试查找该SEL
 如连续失败直到NSObject类，它的superclass也就是它自己本身
 一旦找到SEL，该函数就会调用methodLists的方法并将接收对象的指针传给它

在调用方法时，编译器将它转成了objc_msgSend消息发送了，在Runtime的执行过程如下
 1、Runtime先通过对象someobject找到isa指针，判断isa指针是否为nil，为nil直接return。
 2、若不为空则通过isa指针找到当前实例的类对象，在类对象下查找缓存是否有messageName方法。
 3、若在类对象缓存中找到messageName方法，则直接调用IMP方法(本质上是函数的指针)。
 4、若在类对象缓存中没找到messageName方法，则查找当前类对象的方法列表methodlist，若找到方法则将其添加到类对象的缓存中。
 5、若在类对象方法列表中没找到messageName方法，则继续到当前类的父类中以相同的方式查找（即类的缓存->类的方法列表）。
 6、若在父类中找到messageName方法，则将IMP添加到类对象缓存中。
 7、若在父类中没找到messageName方法，则继续查询父类的父类，直到追溯到最上层NSObject。
 8、若还是没有找到，则启用动态方法解析、备用接收者、消息转发三部曲，给程序最后一个机会
 9、若还是没找到，则Runtime会抛出异常doesNotRecognizeSelector。
 综上，方法的查询流程基本就是查询类对象中的缓存和方法列表->父类中的缓存和方法列表->父类的父类中的缓存和方法列表->...->NSObject中的缓存和方法列表->动态方法解析->备用接收者->消息转发。
 */
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
