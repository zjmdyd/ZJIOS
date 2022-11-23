//
//  Person.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/16.
//

#import "Person.h"
#include <objc/runtime.h>
#import "ZJAnimal.h"

@implementation Person

void jump2(id self,SEL sel, NSString* metter){
    NSLog(@"跳了%@米",metter);
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
 一般定义一个属性后，系统就会自动生成set、get方法，但是在分类中定义一个属性后，是不会自动生成set get方法的，
 */
- (NSString *)personName{
    return objc_getAssociatedObject(self, @selector(personName));
//    return objc_getAssociatedObject(self, @"personName");
}

-(void)setPersonName:(NSString *)personName {
    // objc_setAssociatedObject（将某个值跟某个对象关联起来，将某个值存储到某个对象中）
    // object:给哪个对象添加属性
    // key:属性名称
    // value:属性值
    // policy:保存策略
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

/*
 *第一步:动态方法解析，其实就是在调用的方法找不到的时候，会走到这个方法下面，可以根据自己的需求来添加具体的方法
 *@param sel 这个其实就是自己选择的方法
 *任何方法默认都有两个隐式参数,self,_cmd（当前方法的方法编号)
 */
/*
 class_addMethod参数说明：
 第一个参数：是给那个类添加方法；如[Person class]
 第二个参数：就是哪个方法找不到或者没有实现，这里指的就是jump方法
 第三个参数：是要添加的方法指针，这里是jump2方法指针
 第四个参数：就是返回值了，：左边是返回值，右边是参数V@:@指的是返回的是void，参数是NSString；*/
//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    NSString * selStr = NSStringFromSelector(sel);
//    if ([selStr isEqualToString:@"jump"]) {
//        class_addMethod([Person class], sel, (IMP)jump2, "v@:@");
//        return YES;
//    }
//
//    return NO;
//}

/*
 * 第二步:消息接受者重定向 后备接收者对象 如果第一步未处理，那么让别的对象去处理这个方法
 这里+resolveInstanceMethod: 或者 +resolveClassMethod:无论是返回 YES，还是返回 NO，只要其中没有添加其他函数实现，运行时都会进行下一步。
 **/
//-(id)forwardingTargetForSelector:(SEL)aSelector{
//    if([NSStringFromSelector(aSelector) isEqualToString:@"jump"]){
//        return [[ZJAnimal alloc]init];
//    }
//    return [super forwardingTargetForSelector:aSelector];
//}

/*
 * 第三步 消息重定向 如果前两步未处理，这是最后处理的机会将目标函数以其他形式执行
 如果经过消息动态解析、消息接受者重定向，Runtime 系统还是找不到相应的方法实现而无法响应消息，Runtime 系统会利用 -methodSignatureForSelector: 或者 +methodSignatureForSelector: 方法获取函数的参数和返回值类型。
 如果 methodSignatureForSelector: 返回了一个 NSMethodSignature 对象（函数签名），Runtime 系统就会创建一个 NSInvocation 对象，并通过 forwardInvocation: 消息通知当前对象，给予此次消息发送最后一次寻找 IMP 的机会。
 如果 methodSignatureForSelector: 返回 nil。则 Runtime 系统会发出 doesNotRecognizeSelector: 消息，程序也就崩溃了。
 **/
// 获取函数的参数和返回值类型，返回签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:@"jump"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    
    return [super methodSignatureForSelector:aSelector];
}

// 消息重定向
-(void)forwardInvocation:(NSInvocation *)anInvocation{
    //改变消息接受者对象
    //改变消息的SEL
    anInvocation.selector = @selector(fly);
    [anInvocation invokeWithTarget:[[ZJAnimal alloc]init]];
}

@end
