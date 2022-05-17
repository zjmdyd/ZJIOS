//
//  CALayer+ZJLayer.h
//  ZJIOS
//
//  Created by issuser on 2022/4/24.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "ZJShapeLayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (ZJLayer)

- (void)setMaskCornerRadius:(CGFloat)radius;

- (void)setBorderWidth:(CGFloat)width color:(UIColor *)color;
- (void)setBorderWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;


/**
 添加圆角

 @param corners 四个角
 @param cornerRadii 角度
 */
- (void)addMaskLayerAtRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

- (ZJShapeLayer *)addBorderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType;
- (ZJShapeLayer *)addBorderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType posion_value_1:(CGFloat)p_value_1 posion_value_2:(CGFloat)p_value_2;

- (ZJShapeLayer *)addDashBorderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType;
- (ZJShapeLayer *)addDashBorderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType posion_value_1:(CGFloat)p_value_1 posion_value_2:(CGFloat)p_value_2;

- (ZJShapeLayer *)addBorderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType posion_value_1:(CGFloat)p_value_1 posion_value_2:(CGFloat)p_value_2 needDash:(BOOL)need;

- (void)removeBorderWithType:(UIBorderSideType)borderType;

@end

NS_ASSUME_NONNULL_END
