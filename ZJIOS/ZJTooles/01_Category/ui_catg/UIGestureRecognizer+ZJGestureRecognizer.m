//
//  UIGestureRecognizer+ZJGestureRecognizer.m
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import "UIGestureRecognizer+ZJGestureRecognizer.h"

@implementation UIGestureRecognizer (ZJGestureRecognizer)

#pragma mark - 方向判断

/**
 *  atan2(y, x):用来计算y/x的反正切值, 返回值范围 : (-pi/2,pi/2)
 */
+ (CGFloat)getAngle:(CGFloat)dx dy:(CGFloat)dy {
    return atan2(dy, dx)*180 / M_PI;
}

+ (Direction)direction:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    CGFloat dy = startPoint.y - endPoint.y;    // 因为y值是向下增长的
    CGFloat dx = endPoint.x - startPoint.x;
    
    Direction result = DirectionOfNoMove;
    if (fabs(dy) < 2 || fabs(dy) < 2) {
        return DirectionOfNoMove;
    }
    CGFloat angle = [self getAngle:dx dy:dy];
    if (angle >= -45 && angle < 45) {
        result = DirectionOfRight;
    } else if (angle >= 45 && angle < 135) {
        result = DirectionOfUp;
    } else if (angle >= -135 && angle < -45) {
        result = DirectionOfDown;
    }
    else if ((angle >= 135 && angle <= 180) || (angle >= -180 && angle < -135)) {
        result = DirectionOfLeft;
    }
    
    return result;
}

@end
