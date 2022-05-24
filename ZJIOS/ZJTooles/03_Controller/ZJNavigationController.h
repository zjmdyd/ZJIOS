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

//@property (nonatomic, strong) UIColor *navigationBarBgImgColor;

/*
 *  导航栏是否半透明效果，默认为NO
 */
@property (nonatomic, assign) BOOL navigationBarTranslucent;

@property (nonatomic, assign) BOOL hiddenBackBarButtonItemTitle;
@property (nonatomic, assign) BOOL needChangeExtendedLayout;    // 默认为YES

@property (nonatomic, strong) UIColor *navigationBarBgColor;
@property (nonatomic, strong) UIColor *navigationBarTintColor;
@property (nonatomic, strong) UIColor *navigationBarShadowColor;

//@property (nonatomic, strong) UIImage *navigationBarBgImage;

@end
