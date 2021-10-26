//
//  UIView+ZJView.h
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZJView)

- (void)setCornerRadius:(CGFloat)radius;

- (void)setBorderWidth:(CGFloat)width color:(UIColor *)color;
- (void)setBorderWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

/**
 *  添加tap手势
 *
 *  @param delegate 当不需要delegate时可设为nil
 */

- (void)addTapGestureWithDelegate:(id <UIGestureRecognizerDelegate>)delegate target:(id)target;

- (void)logSubViews;
+ (UIView *)maskViewWithFrame:(CGRect)frame;
- (UIView *)subViewWithTag:(NSInteger)tag;
- (UIView *)fetchSubViewWithClassName:(NSString *)className;
- (UIView *)fetchSuperViewWithClassName:(NSString *)className;

// 左文字右图片
+ (UIView *)createTitleIVWithFrame:(CGRect)frame path:(NSString *)path placehold:(NSString *)placehold title:(NSString *)title;

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
- (CAShapeLayer *)addDashBorderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType width:(CGFloat)width height:(CGFloat)height;

#pragma mark - supplementView

- (void)addIconBadgeWithImage:(UIImage *)image;
- (void)addIconBadgeWithImage:(UIImage *)image bgColor:(UIColor *)color;

// 第几象限
typedef NS_ENUM(NSInteger, QuadrantTouchType) {
    QuadrantTouchTypeOfFirst,
    QuadrantTouchTypeOfSecond,
    QuadrantTouchTypeOfThird,
    QuadrantTouchTypeOfFourth,
};

/*
 环形区域分隔的份数:2等分/4等分
 */
typedef NS_ENUM(NSInteger, AnnularSeparateType) {
    AnnularSeparateTypeOfHalf,
    AnnularSeparateTypeOfQuarter,
};

- (QuadrantTouchType)quadrantOfTouchPoint:(CGPoint)point separateType:(AnnularSeparateType)type;
- (BOOL)touchPointInTheAnnular:(CGPoint)point annularWidth:(CGFloat)annularWidth;

@end

NS_ASSUME_NONNULL_END
