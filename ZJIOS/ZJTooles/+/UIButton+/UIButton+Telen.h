//
//  UIButton+Telen.h
//  KidReading
//
//  Created by telen on 15/11/3.
//  Copyright © 2015年 Creative Knowledge Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton(Telen)

- (void)setScaleTransitionsValue:(CGFloat)scaleTo;//默认 1.05
- (void)setScaleTransitionsDefaultValue:(CGFloat)scaleDefault;//默认1

//自己 缩放
- (void)addTouchScaleTransitions;

//其他view 缩放
- (void)addTouchScaleTransitions_forView:(UIView*)view; //请保证view 存在

//其他views 缩放
- (void)addTouchScaleTransitions_forViews:(UIView*)view,...; //请保证view 存在
- (void)removeTouchScaleTransitions_forViews:(UIView*)view,...;

@property(nonatomic,strong)UIColor * rippleColor; //光圈颜色
- (void)addTouchUpInside_Ripple;//添加点击光圈

@end
