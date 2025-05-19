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
    NSLog(@"self = %@-->", self);
    if ([self isKindOfClass:class]) {
        return self;
    }
    return [[(id)self nextResponder] nextResponderWithTargetClassName:className];
}

@end
