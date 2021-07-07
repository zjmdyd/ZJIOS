//
//  UINavigationController+ZJNaviController.m
//  ZJIOS
//
//  Created by issuser on 2021/7/6.
//

#import "UINavigationController+ZJNaviController.h"

@implementation UINavigationController (ZJNaviController)

- (void)showViewController:(UIViewController *)viewController transdirectionType:(CATransitionType)type subType:(CATransitionSubtype)subtype {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.type = type;
    transition.subtype = subtype;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.view.layer addAnimation:transition forKey:kCATransition];
    [self pushViewController:viewController animated:NO];
}

- (void)popViewController:(UIViewController *)viewController transdirectionType:(CATransitionType)type subType:(CATransitionSubtype)subtype {
    
}

- (void)popViewControllerFromDirection:(CATransitionSubtype)direction {
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionReveal;
    transition.subtype = direction;
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.view.layer addAnimation:transition forKey:kCATransition];
    [self popViewControllerAnimated:NO];
}

@end
