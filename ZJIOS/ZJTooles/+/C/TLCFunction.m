//
//  TLCFunction.m
//  KidReading
//
//  Created by telen on 16/3/17.
//  Copyright © 2016年 Creative Knowledge Ltd. All rights reserved.
//

#import "TLCFunction.h"
#import <objc/runtime.h>

#ifndef DEBUG
#define __DebugMsgToTarget 1 //开启输出日志
#else
#define __DebugMsgToTarget 0 //关闭输出日志
#endif

id tl_oc_msgToClass(NSString * className ,NSString *menthed ,NSArray* refArr ,BOOL retNeed)
{
    id value = nil;
    Class cls = NSClassFromString(className);
    SEL selector = NSSelectorFromString(menthed);
    Method method = class_getClassMethod(cls, selector);
    if((int)method != 0){
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[cls methodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:cls];
        for (int i=0; i < refArr.count; i++) {
            id ref = refArr[i];
            [invocation setArgument:&ref atIndex:2+i];
        }
        [invocation invoke];//perform 的传参表达方式
        if(retNeed){//获得返回值
            void *vvl = nil;
            [invocation getReturnValue:&vvl];
            value = (__bridge id)vvl;
        }
    }else{
#if __DebugMsgToTarget
        NSLog(@"msgToClass unRespondsToSelector -->>> %@ %@",className,menthed);
#endif
    }
    return value;
}


id tl_oc_msgToTarget(id target ,NSString *menthed ,NSArray* refArr ,BOOL retNeed)
{
    id value = nil;
    if (target != nil && menthed != nil) {
        SEL selector = NSSelectorFromString(menthed);
        if ([target respondsToSelector:selector]) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[target class] instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:target];
            for (int i=0; i < refArr.count; i++) {
                id ref = refArr[i];
                [invocation setArgument:&ref atIndex:2+i];
            }
            [invocation invoke];//perform 的传参表达方式
            if(retNeed){//获得返回值
                void *vvl = nil;
                [invocation getReturnValue:&vvl];
                value = (__bridge id)vvl;
            }
        }else{
#if __DebugMsgToTarget
            NSLog(@"msgToTarget unRespondsToSelector -->>> %@ %@",target,menthed);
#endif
        }
    }
    return value;
}

id tl_oc_msgToTarget_ref(id target ,NSString *menthed ,void* ref,BOOL retNeed)
{
    id value = nil;
    if (target != nil && menthed != nil) {
        SEL selector = NSSelectorFromString(menthed);
        if ([target respondsToSelector:selector]) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[target class] instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:target];
            if(ref)[invocation setArgument:ref atIndex:2];
            [invocation invoke];//perform 的传参表达方式
            if(retNeed){//获得返回值
                void *vvl = nil;
                [invocation getReturnValue:&vvl];
                value = (__bridge id)vvl;
            }
        }else{
#if __DebugMsgToTarget
            NSLog(@"msgToTarget unRespondsToSelector -->>> %@ %@",target,menthed);
#endif
        }
    }
    return value;
}
