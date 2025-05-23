//
//  NSObject+ZJMethodSwizzling.m
//  ZJIOS
//
//  Created by issuser on 2021/11/22.
//

#import "NSObject+ZJMethodSwizzling.h"
#import <objc/runtime.h>

/*
 // objc_method 结构体
 typedef struct objc_method *Method;
 
 struct objc_method {
 SEL _Nonnull method_name;                    // 方法名
 char * _Nullable method_types;               // 方法类型
 IMP _Nonnull method_imp;                     // 方法实现
 };
 */
@implementation NSObject (ZJMethodSwizzling)

/*
 一、函数原型与参数
 IMP class_replaceMethod(Class cls, SEL name, IMP imp, const char *types);
 ‌‌参数说明‌：
 cls：目标类（Class 对象）
 name：方法选择器（SEL）
 imp：新的方法实现（函数指针）
 types：方法类型编码（如 "v@:" 表示无返回值、带隐式参数）
 ‌‌返回值‌：被替换的原始方法实现（IMP），若方法不存在则返回
 */
+ (void)exchangeMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    // 当前类
    Class class = [self class];
    
    // 根据函数名，从class的method list中取得对应的method结构体，如果是实例方法用class_getInstanceMethod，类方法用class_getClassMethod()。会从当前的Class中寻找对应方法名的实现，若没有则向上遍历父类中查找。若父类中也没有，则返回NULL。
    // 原方法结构体 和 替换方法结构体
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    /* 如果当前类没有 原方法的 IMP，说明在从父类继承过来的方法实现，
     * 需要在当前类中添加一个 originalSelector 方法，用于判断方法是否存在
     * 但是用 替换方法 swizzledMethod 去实现它(方法不存在的情况),如果方法存在则会返回NO，class_addMethod不会替换类已有方法实现
     */
//    if ([class respondsToSelector:originalSelector]) {
//        NSLog(@"有此方法:%@", NSStringFromSelector(originalSelector));
//    }else {
//        NSLog(@"无此方法:%@", NSStringFromSelector(originalSelector));
//    }
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        NSLog(@"didAddMethod成功:%@, %@", class, NSStringFromSelector(originalSelector));
        // 原方法的 IMP 添加成功后，修改 替换方法的 IMP 为 原始方法的 IMP
        //  originalMethod替换swizzledSelector
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        NSLog(@"didAddMethod失败:%@", class);
        // 添加失败（说明已包含原方法的 IMP），调用交换两个方法的实现
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark - method 底层实现
/*
IMP class_replaceMethod(Class cls, SEL name, IMP imp, const char *types)
{
    if (!cls) return nil;

    rwlock_writer_t lock(runtimeLock);
    return addMethod(cls, name, imp, types ?: "", YES);
}

static IMP
addMethod(Class cls, SEL name, IMP imp, const char *types, bool replace)
{
    IMP result = nil;

    runtimeLock.assertWriting();

    assert(types);
    assert(cls->isRealized());

    method_t *m;
    if ((m = getMethodNoSuper_nolock(cls, name))) {
        // already exists
        if (!replace) {
            result = m->imp;
        } else {
            result = _method_setImplementation(cls, m, imp);
        }
    } else {
        // fixme optimize
        method_list_t *newlist;
        newlist = (method_list_t *)calloc(sizeof(*newlist), 1);
        newlist->entsizeAndFlags =
            (uint32_t)sizeof(method_t) | fixed_up_method_list;
        newlist->count = 1;
        newlist->first.name = name;
        newlist->first.types = strdupIfMutable(types);
        newlist->first.imp = imp;

        prepareMethodLists(cls, &newlist, 1, NO, NO);
        cls->data()->methods.attachLists(&newlist, 1);
        flushCaches(cls);

        result = nil;
    }

    return result;
}
 */
@end
