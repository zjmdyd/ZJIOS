//
//  ZJNavigationController.m
//  SportWatch
//
//  Created by ZJ on 2/24/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJNavigationController.h"
#import "UIImage+ZJImage.h"

@interface ZJNavigationController ()

@end

@implementation ZJNavigationController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.delegate = self;
}

- (void)setNavigationBarBgImg:(UIImage *)bgImg forBarMetrics:(UIBarMetrics)barMetrics {
    [self.navigationBar setBackgroundImage:bgImg forBarMetrics:barMetrics];
}

- (void)setNavigationBarBgImgWithColor:(UIColor *)color forBarMetrics:(UIBarMetrics)barMetrics {
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:color] forBarMetrics:barMetrics];
}

- (void)setNavigationBarTranslucent:(BOOL)navigationBarTranslucent {
    _navigationBarTranslucent = navigationBarTranslucent;

    self.navigationBar.translucent = _navigationBarTranslucent;
}

- (void)setNavigationBarBackButtonTitle:(NSString *)navigationBarBackButtonTitle {
    _navigationBarBackButtonTitle = navigationBarBackButtonTitle;
    
    if (@available(iOS 11.0, *)) {
        self.navigationBar.backItem.backButtonTitle = _navigationBarBackButtonTitle;
    } else {
        // 会影响父VC的title显示,修改了backItem的title也会影响super.navigationItem的title
        self.navigationBar.backItem.title = _navigationBarBackButtonTitle;
    }
}

- (void)setNavigationBarTintColor:(UIColor *)navigationBarTintColor {
    _navigationBarTintColor = navigationBarTintColor;
    self.navigationBar.tintColor = _navigationBarTintColor;    // 对返回按钮颜色起作用
}

/*
 iOS15需要向上拖动才有效果,iOS13立刻就有效果
 iOS13默认会有可见的分割线, iOS15默认的分割线不可见
 self.navigationBar.shadowImage = nil;//[UIImage new]; iOS15上这两者没区别
 */
- (void)setNavigationBarShadowColor:(UIColor *)navigationBarShadowColor {
    _navigationBarShadowColor = navigationBarShadowColor;

    if (_navigationBarShadowColor) {
        self.navigationBar.shadowImage = [UIImage imageWithColor:_navigationBarShadowColor];
    }else {
        self.navigationBar.shadowImage = [UIImage new];
    }
}

- (void)setHiddenShadowImage:(BOOL)hiddenShadowImage {
    _hiddenShadowImage = hiddenShadowImage;
    
    if (_hiddenShadowImage) {
        self.navigationBar.shadowImage = [UIImage new];
    }
}

/*
 *  此方法会在viewDidLoad之后调用
 */
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    NSLog(@"edgesForExtendedLayout = %zd", viewController.edgesForExtendedLayout);
//    NSLog(@"topItem = %@", viewController.navigationController.navigationBar.topItem);
//    NSLog(@"backItem = %@", viewController.navigationController.navigationBar.backItem);
//    NSLog(@"viewController.navigationItem = %@, titleView = %@", viewController.navigationItem, viewController.navigationItem.titleView);

    if (!self.hiddenBackBarButtonItemTitle) return;
    
    NSArray *viewControllerArray = self.viewControllers;

    long previousViewControllerIndex = [viewControllerArray indexOfObject:viewController] - 1;
    UIViewController *previous;

    if (previousViewControllerIndex >= 0) {
        previous = [viewControllerArray objectAtIndex:previousViewControllerIndex];
        previous.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                     initWithTitle:@""
                                                     style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:nil];
    }
}

@end
