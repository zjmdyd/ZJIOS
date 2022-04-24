//
//  CALayer+ZJLayer.h
//  ZJIOS
//
//  Created by issuser on 2022/4/24.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

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

typedef NS_OPTIONS(NSUInteger, UIBorderSideType) {
    UIBorderSideTypeAll  = 0,
    UIBorderSideTypeTop = 1 << 0,
    UIBorderSideTypeBottom = 1 << 1,
    UIBorderSideTypeLeft = 1 << 2,
    UIBorderSideTypeRight = 1 << 3,
};

- (CAShapeLayer *)addBorderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType;
- (CAShapeLayer *)addDashBorderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType;
- (CAShapeLayer *)addDashBorderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType needDash:(BOOL)need xPosion:(CGFloat)x yPosition:(CGFloat)y;

@end

NS_ASSUME_NONNULL_END
