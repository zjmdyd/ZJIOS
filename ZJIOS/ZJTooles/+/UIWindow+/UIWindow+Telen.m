//
//  UIWindow+Telen.m
//  ccc
//
//  Created by Telen on 2017/3/11.
//  Copyright © 2017年 Telen. All rights reserved.
//

#import "UIWindow+Telen.h"
#import <objc/runtime.h>

#define __rotation_cmd_ @"rotation"
#define __defaultRotation_cmd_ @"defaultRotation"

@implementation UIWindow (Telen)

- (UIInterfaceOrientationMask)defaultRotation
{
    NSNumber *value = objc_getAssociatedObject(self, __defaultRotation_cmd_);
    if (value == nil)return UIInterfaceOrientationMaskAllButUpsideDown;
    return [value unsignedIntegerValue];
}
- (void)setDefaultRotation:(UIInterfaceOrientationMask)rotation
{
    objc_setAssociatedObject(self, __defaultRotation_cmd_, @(rotation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark-
- (UIInterfaceOrientationMask)rotation
{
    NSNumber *value = objc_getAssociatedObject(self, __rotation_cmd_);
    if (value == nil)return [self defaultRotation];
    return [value unsignedIntegerValue];
}
- (void)setRotation:(UIInterfaceOrientationMask)rotation
{
    objc_setAssociatedObject(self, __rotation_cmd_, @(rotation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
