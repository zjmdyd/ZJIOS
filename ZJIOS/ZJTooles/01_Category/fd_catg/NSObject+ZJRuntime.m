//
//  NSObject+ZJRuntime.m
//  ZJIOS
//
//  Created by Zengjian on 2021/7/2.
//

#import "NSObject+ZJRuntime.h"
#import <UIKit/UIKit.h>
#include <objc/runtime.h>

#define NSOBJECT_SWIZZLEMETHOD_ENABLED     1

@implementation NSObject (ZJRuntime)

- (NSArray *)objectProperties {
    u_int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++) {
        const char* propertyName = property_getName(properties[i]);
        [propertiesArray addObject:[NSString stringWithUTF8String:propertyName]];
    }
    
    free(properties);
    
    return propertiesArray;
}

- (id)nextResponderWithTargetClassName:(NSString *)className {
    Class class = objc_getClass([className UTF8String]);

    if ([self isKindOfClass:class]) {
        return self;
    }
    return [[(id)self nextResponder] nextResponderWithTargetClassName:className];
}

//runtime交换方法
- (void)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector {
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
