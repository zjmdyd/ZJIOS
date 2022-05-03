//
//  UIView+ZJToucMathEvent.h
//  ZJIOS
//
//  Created by issuser on 2022/4/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 第几象限
typedef NS_ENUM(NSInteger, QuadrantTouchType) {
    QuadrantTouchTypeFirst,
    QuadrantTouchTypeSecond,
    QuadrantTouchTypeThird,
    QuadrantTouchTypeFourth,
    QuadrantTouchTypeNone,
};

/*
 环形区域分隔的份数:2等分/4等分
 */
typedef NS_ENUM(NSInteger, AnnularSeparateType) {
    AnnularSeparateTypeHalf,
    AnnularSeparateTypeQuarter,
};

typedef NS_ENUM(NSInteger, MoveDirection) {
    MoveDirectionNoMove,
    MoveDirectionUp,
    MoveDirectionDown,
    MoveDirectionLeft,
    MoveDirectionRight,
};

@interface UIView (ZJToucMathEvent)

- (QuadrantTouchType)quadrantOfTouchPoint:(CGPoint)point separateType:(AnnularSeparateType)type;

/*
 判断点是否在环形区域内
 */
- (BOOL)touchInTheAnnularWithPoint:(CGPoint)point annularWidth:(CGFloat)annularWidth;

+ (MoveDirection)moveDirection:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end

NS_ASSUME_NONNULL_END
