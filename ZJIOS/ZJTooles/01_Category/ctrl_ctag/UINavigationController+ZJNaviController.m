//
//  UINavigationController+ZJNaviController.m
//  ZJIOS
//
//  Created by issuser on 2021/7/6.
//

#import "UINavigationController+ZJNaviController.h"

#define TransDuration 1//0.25

@implementation UINavigationController (ZJNaviController)
// 设置转场类型

- (void)pushViewController:(UIViewController *)viewController transitionType:(CATransitionType)type subType:(CATransitionSubtype)subtype {
    CATransition *transition = [CATransition animation];
    transition.duration = TransDuration;
    transition.type = type;     
    transition.subtype = subtype;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.view.layer addAnimation:transition forKey:kCATransition];
    [self pushViewController:viewController animated:NO];
}

- (void)popViewController:(UIViewController *)viewController transitionType:(CATransitionType)type subType:(CATransitionSubtype)subtype {
    CATransition *transition = [CATransition animation];
    transition.type = type;
    transition.subtype = subtype;
    transition.duration = TransDuration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.view.layer addAnimation:transition forKey:kCATransition];
    [self popViewControllerAnimated:NO];
}

@end
