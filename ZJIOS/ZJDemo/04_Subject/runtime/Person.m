//
//  Person.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/16.
//

#import "Person.h"
#include <objc/runtime.h>
#import "ZJAnimal.h"
#import "ZJDefaultOject.h"

@implementation Person

+ (void)initialize
{
    if (self == [Person class]) {
        NSLog(@"%s", __func__);
    }
}
/*
 为什么category不能有属性，因为分类的结构体指针中，没有实例变量的成员结构
 分类的作用就是在不修改原有类的基础上，为一个类扩展方法，类别扩展的新方法有更高的优先级，会覆盖同名的原类的已有方法。
 struct objc_method {
 SEL _Nonnull method_name;       //方法名
 char * _Nullable method_types;  //方法类型
 IMP _Nonnull method_imp;        //方法实现
 }
 */

/*
 动态添加属性
 一般定义一个属性后，系统就会自动生成set、get方法，但是在分类中定义一个属性后，
 只会生成setter和getter的声明，不会生成setter和getter的实现以及成员变量
 */
- (NSString *)personName {
    return objc_getAssociatedObject(self, @selector(personName));
    //    return objc_getAssociatedObject(self, @"personName");
}

/*
 objc_setAssociatedObject（将某个值跟某个对象关联起来，将某个值存储到某个对象中）
 
 二、参数说明
 参数名    类型    作用
 object    id           需要关联属性的目标对象（通常为self）
 key    const void *    唯一标识关联属性的键（推荐使用static const void *或 @selector()保证唯一性）
 value    id            要关联的对象值（设为nil可移除关联）
 policy    objc_AssociationPolicy    关联策略（决定value的内存管理方式）
 
 三、关联策略（policy）类型
 策略常量    等效属性修饰符    说明
 OBJC_ASSOCIATION_ASSIGN                @property(assign)    弱引用，不保留对象
 OBJC_ASSOCIATION_RETAIN_NONATOMIC      @property(strong, nonatomic)    强引用，非原子操作
 OBJC_ASSOCIATION_COPY_NONATOMIC        @property(copy, nonatomic)    拷贝对象，非原子操作
 OBJC_ASSOCIATION_RETAIN                @property(strong, atomic)    强引用，原子操作（线程安全）
 OBJC_ASSOCIATION_COPY                  @property(copy, atomic)    拷贝对象，原子操作（线程安全）
 
 */
-(void)setPersonName:(NSString *)personName {
    objc_setAssociatedObject(self, @selector(personName), personName, OBJC_ASSOCIATION_COPY_NONATOMIC);
    //    objc_setAssociatedObject(self, @"personName", personName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
/*
 void
 objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy) {
 objc_setAssociatedObject_non_gc(object, key, value, policy);
 }
 
 void objc_setAssociatedObject_non_gc(id object, const void *key, id value, objc_AssociationPolicy policy) {
 _object_set_associative_reference(object, (void *)key, value, policy);
 }
 void _object_set_associative_reference(id object, void *key, id value, uintptr_t policy) {
 // retain the new value (if any) outside the lock.
 ObjcAssociation old_association(0, nil);
 id new_value = value ? acquireValue(value, policy) : nil;
 {
 AssociationsManager manager;
 AssociationsHashMap &associations(manager.associations());
 disguised_ptr_t disguised_object = DISGUISE(object);
 if (new_value) {
 // break any existing association.
 AssociationsHashMap::iterator i = associations.find(disguised_object);
 if (i != associations.end()) {
 // secondary table exists
 ObjectAssociationMap *refs = i->second;
 ObjectAssociationMap::iterator j = refs->find(key);
 if (j != refs->end()) {
 old_association = j->second;
 j->second = ObjcAssociation(policy, new_value);
 } else {
 (*refs)[key] = ObjcAssociation(policy, new_value);
 }
 } else {
 // create the new association (first time).
 ObjectAssociationMap *refs = new ObjectAssociationMap;
 associations[disguised_object] = refs;
 (*refs)[key] = ObjcAssociation(policy, new_value);
 object->setHasAssociatedObjects();
 }
 } else {
 // setting the association to nil breaks the association.
 AssociationsHashMap::iterator i = associations.find(disguised_object);
 if (i !=  associations.end()) {
 ObjectAssociationMap *refs = i->second;
 ObjectAssociationMap::iterator j = refs->find(key);
 if (j != refs->end()) {
 old_association = j->second;
 refs->erase(j);
 }
 }
 }
 }
 // release the old value (outside of the lock).
 if (old_association.hasValue()) ReleaseValue()(old_association);
 }
 class AssociationsManager {
 static spinlock_t _lock;
 static AssociationsHashMap *_map;               // associative references:  object pointer -> PtrPtrHashMap.
 public:
 AssociationsManager()   { _lock.lock(); }
 ~AssociationsManager()  { _lock.unlock(); }
 
 AssociationsHashMap &associations() {
 if (_map == NULL)
 _map = new AssociationsHashMap();
 return *_map;
 }
 };
 */

void jump2(id self, SEL sel, id metter) {
    NSLog(@"跳了%@米", metter);
    NSLog(@"self = %@, sel = %@", self, NSStringFromSelector(sel));
}

//- (void)eat:(id)obj {
//    NSLog(@"吃的啥呀:%@", obj);
//}

void eat2(id self, SEL sel, id obj) {
    NSLog(@"吃的啥呀2:%@", obj);
}

/*
 BOOL class_addMethod(Class cls, SEL name, IMP imp, const char *types);
 该函数用于在运行时向指定类动态添加方法实现。主要特性包括：
 可添加全新方法或覆盖父类方法（但不会替换类已有方法实现）
 返回值表示操作是否成功（YES=添加成功，NO=类已存在同名方法）
 二、参数详解
 参数名    类型    说明
 cls    Class   目标类对象，通常传入[ClassName class]
 name   SEL     方法选择器，使用@ selector(methodName)格式指定
 imp    IMP     函数指针，指向方法的具体实现（需包含self和_cmd参数）
 types  const char*     方法类型编码字符串，描述返回值类型和参数类型
 
 三、类型编码规则（types参数）
 编码符号    对应类型    示例说明
 v    void返回值   v@:表示无返回，参数为(id, SEL)
 @    id类型对象    @参数或返回值
 :    SEL类型      隐含参数_cmd的编码35
 i    int类型      用于整型返回值或参数
 
 class_addMethod参数说明：
 第一个参数：是给那个类添加方法；如[Person class]
 第二个参数：就是哪个方法找不到或者没有实现，这里指的就是jump方法
 第三个参数：是要添加的方法指针，这里是jump2方法指针
 第四个参数：就是返回值了，：左边是返回值，右边是参数V@:@指的是返回的是void，参数是NSString；*/
/*
 第一步:消息动态解析，其实就是在调用的方法找不到的时候，会走到这个方法下面，当自己或者父类有这个方法就不会执行消息转发机制的方法
 可以根据自己的需求来添加具体的方法
 @param sel 这个其实就是自己选择的方法
 任何方法默认都有两个隐式参数,self,_cmd（当前方法的方法编号)
 
 resolveInstanceMethod:是Objective-C 运行时动态方法决议的核心方法，用于在消息发送失败后提供补救机会。
 一、触发条件与调用流程
 ‌‌触发时机‌
 当对象调用未实现的方法时，在以下步骤后触发：
 缓存和方法列表查找失败（包括继承链搜索）
 消息发送阶段未找到 IMP 实现
 ‌‌系统调用链‌
 graph LR
 A[objc_msgSend] --> B[查找IMP失败]
 B --> C[resolveMethod_locked]
 C --> D{是否为元类?}
 D -->|否| E[调用resolveInstanceMethod:]
 D -->|是| F[先调用resolveClassMethod:]
 二、方法特性
 ‌‌参数与返回值
 + (BOOL)resolveInstanceMethod:(SEL)sel;
 sel：未实现的方法选择器
 返回 YES 表示已动态添加方法，系统会重新尝试查找
 ‌‌与元类方法的区别‌
 类方法动态决议使用 resolveClassMethod:，但最终会回溯到 NSObject 的实例方法决议
 
 通过 class_addMethod 将 C 函数绑定为 Objective-C 方法，类型编码 "v@:" 表示无返回值、接收对象和选择器参数。
 四、注意事项
 ‌‌调用次数限制‌
 每个未实现的 SEL 仅触发一次决议，避免循环
 ‌‌性能影响‌
 频繁动态添加方法会增加运行时开销
 ‌‌消息转发优先级‌
 若返回 NO 或未处理，会进入 forwardingTargetForSelector: 等消息转发流程
 
 */
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString * selStr = NSStringFromSelector(sel);
    if ([selStr isEqualToString:@"eat:"]) {
        // 如果执行了class_addMethod方法后，则就算返回NO,消息转发流程也不会再转发了。因为已经找到方法了
        class_addMethod([Person class], sel, (IMP)eat2, "v@:");
        return YES;
    }
    
    return NO;
}

/* 消息接收者重定向
 该方法属于Objective-C消息转发机制的第二阶段（备援接收者阶段），允许将未实现的方法调用转发给其他对象处理23。主要特性包括：
 返回值：可返回任意能响应aSelector的对象，若返回nil则进入下一阶段转发流程
 执行时机：在resolveInstanceMethod返回NO后触发
 性能优势：比完整的forwardInvocation转发更高效
 二、消息转发流程中的定位
 ‌‌完整转发流程‌
 第一阶段：resolveInstanceMethod（动态方法解析）
 第二阶段：forwardingTargetForSelector（快速转发）
 第三阶段：methodSignatureForSelector+forwardInvocation（完整转发）
 ‌‌中断条件‌
 若该方法返回有效对象，则转发流程立即终止，不再执行后续阶段
 四、注意事项
 ‌‌循环检测‌
 需避免返回self导致无限循环
 ‌‌性能优化‌
 比forwardInvocation少一次方法签名创建和NSInvocation对象构建
 ‌‌与respondsToSelector:关系‌
 系统会先检查本对象是否能响应方法，再决定是否进入转发流程
 ‌‌类方法处理‌
 类方法需在元类中实现forwardingTargetForSelector
 五、执行原理
 ‌‌底层调用链‌
 objc_msgSend → resolveInstanceMethod → forwardingTargetForSelector → forwardInvocation
 ‌‌多次触发问题‌
 当返回self且methodSignatureForSelector有实现时可能触发二次解析
 **/
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if([NSStringFromSelector(aSelector) isEqualToString:@"fly"]) {
        return [[ZJAnimal alloc] init];
    }
    return [super forwardingTargetForSelector:aSelector];
}

/*
 * 第三步 消息重定向 如果前两步未处理，这是最后处理的机会将目标函数以其他形式执行
 如果经过消息动态解析、消息接受者重定向，Runtime 系统还是找不到相应的方法实现而无法响应消息，Runtime 系统会利用 -methodSignatureForSelector: 或者 +methodSignatureForSelector: 方法获取函数的参数和返回值类型。
 如果 methodSignatureForSelector: 返回了一个 NSMethodSignature 对象（函数签名），Runtime 系统就会创建一个 NSInvocation 对象，并通过 -forwardInvocation: 消息通知当前对象，给予此次消息发送最后一次寻找 IMP 的机会。
 如果 methodSignatureForSelector: 返回 nil。则 Runtime 系统会发出 doesNotRecognizeSelector: 消息，程序也就崩溃了。
 **/
// 获取函数的参数和返回值类型，返回签名
/*
 该方法属于Objective-C消息转发机制的第三阶段（完整消息转发阶段），用于为未实现的方法提供方法签名。核心特性包括：
 ‌‌必须与forwardInvocation:配合使用‌，两者共同构成完整转发流程
 ‌‌返回值要求‌：必须返回非nil的NSMethodSignature对象，否则系统直接抛出doesNotRecognizeSelector:异常
 ‌‌执行时机‌：在forwardingTargetForSelector:返回nil后触发
 二、消息转发流程中的定位
 ‌‌完整转发链条‌
 第一阶段：resolveInstanceMethod:（动态方法解析）
 第二阶段：forwardingTargetForSelector:（快速转发）
 第三阶段：methodSignatureForSelector:+forwardInvocation:（完整转发）
 ‌‌关键中断条件‌
 若该方法返回nil，则立即终止转发流程并触发崩溃
 三、核心实现逻辑
 ‌‌方法签名构建规则‌
 需通过[NSMethodSignature signatureWithObjCTypes:]创建签名
 类型编码需与目标方法的参数/返回值严格匹配（例如"v@:@"表示返回void，参数为id和SEL）
 五、注意事项
 ‌‌性能影响‌
 频繁构建方法签名会影响性能，建议缓存常用签名
 ‌‌与respondsToSelector:的关系‌
 系统会优先检查该方法，再决定是否进入转发流程
 ‌‌ARC环境处理‌
 涉及对象类型参数时需注意内存管理语义（如__bridge转换）
 ‌‌类方法处理‌
 类方法需在元类中重写methodSignatureForSelector:
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (![self respondsToSelector:aSelector]) { // 都会满足条件，到这一步肯定是未找到方法
        id signa = [NSMethodSignature signatureWithObjCTypes:"v@:"];
        return signa;
    }
    return [super methodSignatureForSelector:aSelector];
}

// 消息重定向
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    anInvocation.selector = @selector(defaultMethodEvent:);         // 改变消息的SEL
    [anInvocation invokeWithTarget:[[ZJDefaultOject alloc] init]];  // 改变消息接受者对象
}

@end
