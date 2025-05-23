//
//  UINavigationController+ZJNaviController.h
//  ZJIOS
//
//  Created by issuser on 2021/7/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (ZJNaviController)

- (void)pushViewController:(UIViewController *)viewController transitionType:(CATransitionType)type subType:(CATransitionSubtype)subtype;
- (void)popViewController:(UIViewController *)viewController transitionType:(CATransitionType)type subType:(CATransitionSubtype)subtype;

@end

NS_ASSUME_NONNULL_END

