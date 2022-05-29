//
//  ZJNavigationController.h
//  SportWatch
//
//  Created by ZJ on 2/24/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJNavigationController : UINavigationController <UINavigationControllerDelegate>

- (void)setNavigationBarBgImg:(UIImage *)bgImg forBarMetrics:(UIBarMetrics)barMetrics;
- (void)setNavigationBarBgImgWithColor:(UIColor *)color forBarMetrics:(UIBarMetrics)barMetrics;

/*
 *  导航栏是否半透明效果，默认为YES
 */
@property (nonatomic, assign) BOOL navigationBarTranslucent;

// 返回按钮title
@property (nonatomic, copy) NSString *navigationBarBackButtonTitle;
@property (nonatomic, assign) BOOL hiddenBackBarButtonItemTitle;

@property (nonatomic, strong) UIColor *navigationBarTintColor;

// 分割线颜色
@property (nonatomic, strong) UIColor *navigationBarShadowColor;
@property (nonatomic, assign) BOOL hiddenShadowImage;


//@property (nonatomic, strong) UIColor *navigationBarBgImgColor;



@property (nonatomic, assign) BOOL needChangeExtendedLayout;    // 默认为YES

@property (nonatomic, strong) UIColor *navigationBarBgColor;


//@property (nonatomic, strong) UIImage *navigationBarBgImage;

@end
