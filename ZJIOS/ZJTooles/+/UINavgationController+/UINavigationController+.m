//
//  UINavigationController+telen.m
//  Reader
//
//  Created by telen on 14-4-20.
//  Copyright (c) 2014年 Creative Knowledge Ltd. All rights reserved.
//

#import "UINavigationController+.h"
#import <objc/runtime.h>
#import "NSObject+Telen.h"
#define AniTime  0.5f

// 扩展NavigationController中的方法（catagory）
@implementation UINavigationController (telen)

static bool isPushPoped = YES;
- (void)pushAnimationDidStop {
    isPushPoped = YES;
}

- (void)popAnimationDidStop {
    isPushPoped = YES;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    isPushPoped = YES;
}

- (void)pushViewController: (UIViewController*)controller
    animatedWithTransition: (UIViewAnimationTransition)transition {
    if (isPushPoped == NO) {
        return;
    }
    if ([self.topViewController isMemberOfClass:[controller class]]) {
        return;
    }
    isPushPoped = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:AniTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(pushAnimationDidStop)];
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    [UIView commitAnimations];
    [self pushViewController:controller animated:NO];
}

- (UIViewController*)popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)transition {
    
    isPushPoped = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:AniTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(popAnimationDidStop)];
    [UIView setAnimationTransition:transition forView:self.view cache:NO];
    [UIView commitAnimations];
    UIViewController* poppedController = [self popViewControllerAnimated:NO];
    
    return poppedController;
}

- (void)pushViewController:(UIViewController *)controller animatedType:(NSString *)AniType subType:(NSString *)AniSubType
{
    if (isPushPoped == NO) {
        return;
    }
    if ([self.topViewController isMemberOfClass:[controller class]]) {
        return;
    }
    isPushPoped = NO;
    
    //telen 自定义push 动画 解决闪的问题
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = AniType;//kCATransitionMoveIn;//@"moveIn";//@"reveal";//@"cube";@"suckEffect";
    transition.subtype = AniSubType;//kCATransitionFromRight;
    transition.delegate = self;
    [self.view.layer addAnimation:transition forKey:nil];
    [self pushViewController:controller animated:NO];
}

- (UIViewController *)popViewControllerAnimatedType:(NSString *)AniType subType:(NSString *)AniSubType
{
    isPushPoped = NO;
    //telen 自定义push 动画 解决闪的问题
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = AniType;//kCATransitionMoveIn;//@"moveIn";//@"reveal";//@"cube";@"suckEffect";
    transition.subtype = AniSubType;//kCATransitionFromRight;
    transition.delegate = self;
    [self.view.layer addAnimation:transition forKey:nil];
    UIViewController* poppedController = [self popViewControllerAnimated:NO];
    return poppedController;
}

- (void)pushViewControllerDefaultAnimation:(UIViewController *)controller
{
    [self pushViewController:controller animatedType:kCATransitionMoveIn subType:kCATransitionFromRight];
}

- (UIViewController *)popViewControllerDefaultAnimation
{
    return [self popViewControllerAnimatedType:kCATransitionReveal subType:kCATransitionFromLeft];
}

- (void)pushViewControllerAnimation_Present:(UIViewController *)controller
{
    [self pushViewController:controller animatedType:kCATransitionMoveIn subType:kCATransitionFromTop];
}

- (UIViewController *)popViewControllerAnimation_Dismiss
{
    return [self popViewControllerAnimatedType:kCATransitionReveal subType:kCATransitionFromBottom];
}

- (NSArray*)popToRootViewControllerAnimated_Dismiss
{
    isPushPoped = NO;
    //telen 自定义push 动画 解决闪的问题
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;//kCATransitionMoveIn;//@"moveIn";//@"reveal";//@"cube";@"suckEffect";
    transition.subtype = kCATransitionFromBottom;//kCATransitionFromRight;
    transition.delegate = self;
    [self.view.layer addAnimation:transition forKey:nil];
    NSArray* arr = [self popToRootViewControllerAnimated:NO];
    return arr;
}

- (void)pushViewControllerAnimation_Page:(UIViewController *)controller
{
    [self pushViewController:controller animatedType:kCATransitionReveal subType:kCATransitionFromRight];
}

- (UIViewController *)popViewControllerAnimation_Page
{
    return [self popViewControllerAnimatedType:kCATransitionMoveIn subType:kCATransitionFromLeft];
}

@end



@implementation UINavigationController (TLEdgePanPan)

- (BOOL)hasProperty:(NSString*)name target:(id)target
{
    if (name != nil) {
        objc_property_t property = class_getProperty([target class], name.UTF8String);
        if (property != nil
            && property != NULL) {
            return YES;
        }
    }
    return NO;
}

- (id)valueForKey:(NSString *)key target:(id)target
{
    id value = nil;
    @try {
        value = [target valueForKey:key];
    } @catch (NSException *exception) {
        key = nil;
    } @finally {
    }
    return value;
}

static const char* PopPanAdded = "PopPanAdded";
- (void)addPanPopGestureRecognizer_once
{
    UIGestureRecognizer *gesture = self.interactivePopGestureRecognizer;
    id popadd = objc_getAssociatedObject(gesture, PopPanAdded);
    if (!popadd) {
        UIView *gestureView = gesture.view;
        //gesture.enabled = NO;
        
        UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] init];
        popRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
        popRecognizer.maximumNumberOfTouches = 1;
        
        //获取系统手势的target数组
        NSString* keyArr = [NSString stringWithFormat:@"_%@",@"targets"];
        NSString* keytarget = [NSString stringWithFormat:@"_%@",@"target"];
        NSString* keySEL = [NSString stringWithFormat:@"handle%@%@",@"Navigation",@"Transition:"];
        
        NSMutableArray *_targets = [self valueForKey:keyArr target:gesture];
        if (_targets != nil && [_targets isKindOfClass:[NSArray class]] && _targets.count ==1) {
            
            //获取它的唯一对象，我们知道它是一个叫UIGestureRecognizerTarget的私有类，它有一个属性叫_target
            id gestureRecognizerTarget = [_targets firstObject];
            
            //获取_target:_UINavigationInteractiveTransition，它有一个方法叫handleNavigationTransition:
            id navigationInteractiveTransition = [self valueForKey:keytarget target:gestureRecognizerTarget];
            
            //通过前面的打印，我们从控制台获取出来它的方法签名。
            SEL handleTransition = NSSelectorFromString(keySEL);
            
            if ([navigationInteractiveTransition respondsToSelector:handleTransition]) {
                //创建一个与系统一模一样的手势，我们只把它的类改为UIPanGestureRecognizer
                [popRecognizer addTarget:navigationInteractiveTransition action:handleTransition];
                //
                [gestureView addGestureRecognizer:popRecognizer];
                objc_setAssociatedObject(gesture, PopPanAdded, @"YES", OBJC_ASSOCIATION_RETAIN);
                objc_setAssociatedObject(popRecognizer, PopPanAdded, @"YES", OBJC_ASSOCIATION_RETAIN);
            }
        }
    }
}

+ (void)load
{
    [self swizzleSelector:@selector(gestureRecognizerShouldBegin:) withSelector:@selector(TLEdgePanPan_gestureRecognizerShouldBegin:)];
}

- (BOOL)TLEdgePanPan_gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
{
    if (self.viewControllers.count <= 1)//关闭主界面的右滑返回
    {
        return NO;
    }

    id popAdd = objc_getAssociatedObject(gestureRecognizer, PopPanAdded);
    if (popAdd != nil) {
        UIPanGestureRecognizer* sender = (UIPanGestureRecognizer*)gestureRecognizer;
        CGPoint offset = [sender translationInView:sender.view];
        //NSLog(@"%@",NSStringFromCGPoint(offset));
        if (offset.x >= 0) {
            return YES;
        }
        return NO;
    }
    IMP imp = [self.class getImplementationSelector:@selector(gestureRecognizerShouldBegin:)];
    if (imp != 0) {
        return [self TLEdgePanPan_gestureRecognizerShouldBegin:gestureRecognizer];
    }
    return NO;
}

- (BOOL)super_gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return [self TLEdgePanPan_gestureRecognizerShouldBegin:gestureRecognizer];
}

@end

