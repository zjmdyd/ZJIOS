//
//  ZJTabBarViewController.h
//  PhysicalDate
//
//  Created by ZJ on 4/26/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJTabBarViewController;

@protocol ZJTabBarViewControllerDelegate <NSObject>

@optional

- (void)tabBarViewController:(ZJTabBarViewController *)tabBarViewController didSelectedIndex:(NSUInteger)index;
- (void)tabBarViewController:(ZJTabBarViewController *)tabBarViewController didSelectedViewController:(UIViewController *)viewController;

@end

@interface ZJTabBarViewController : UIViewController

@property (nonatomic, assign) NSUInteger selectIndex;
@property (nonatomic, strong, readonly) UIViewController *currentVC;
@property (nonatomic, strong, readonly) NSArray *viewControllers;

+ (instancetype)barViewControllerWithViewControllers:(NSArray *)viewControllers;
+ (instancetype)barViewControllerWithViewControllers:(NSArray *)viewControllers height:(CGFloat)height;

/**
 *
 */
- (instancetype)initWithViewControllers:(NSArray *)viewControllers;
- (instancetype)initWithViewControllers:(NSArray *)viewControllers height:(CGFloat)height;

@property (nonatomic, strong) UIColor *statusBgViewColor;

/**
 *  当隐藏导航栏的时候需要用到此属性,默认的值为白色
 */
@property (nonatomic, strong) UIColor *topViewBgColor;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *currentTitleColor;

/**
 *  当隐藏导航栏的时候需要用到此属性,值为20,默认的值为0
 */
@property (nonatomic, assign) CGFloat offsetX;

@property (nonatomic, assign) BOOL selectEnable;

@property (nonatomic, weak) id <ZJTabBarViewControllerDelegate> delegate;

@end
