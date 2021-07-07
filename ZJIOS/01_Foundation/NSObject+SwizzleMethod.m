//
//  NSObject+SwizzleMethod.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/17.
//

#import "NSObject+SwizzleMethod.h"
#include <objc/runtime.h>

#define NSOBJECT_SWIZZLEMETHOD_ENABLED     1

@implementation NSObject (SwizzleMethod)

//runtime交换方法
- (void)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector
{
    if(!NSOBJECT_SWIZZLEMETHOD_ENABLED) return;

    Class class = [self class];
    
    //获取方法
    Method originalMethod = class_getInstanceMethod(class, origSelector);
    Method swizzledMethod = class_getInstanceMethod(class, newSelector);
    
    //添加origSelector方法，并将origSelector的实现指向swizzledMethod，以达到交换方法实现的目的。
    //如果didAddMethod返回YES，说明origSelectorz在Class中不存在，是新方法，并将origSelector的实现指向swizzledMethod
    //返回NO，说明Class中已经存在origSelector方法
    BOOL didAddMethod = class_addMethod(class,
                                        origSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        //利用class_replaceMethod将newSelector的实现指向originalMethod（替换newSelector的实现）。
        class_replaceMethod(class,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        //利用method_exchangeImplementations交换方法的实现
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
