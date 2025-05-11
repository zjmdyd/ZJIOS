//
//  UIView+ZJToucMathEvent.m
//  ZJIOS
//
//  Created by issuser on 2022/4/24.
//

#import "UIView+ZJToucMathEvent.h"

@implementation UIView (ZJToucMathEvent)

// 象限的规则:原点和坐标轴上的点不属于任何象限
- (QuadrantTouchType)quadrantOfTouchPoint:(CGPoint)point separateType:(AnnularSeparateType)type {
    CGFloat x = point.x, y = point.y;
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    if (type == AnnularSeparateTypeQuarter) {
        if (x > width/2 && y < height/2) {
            return QuadrantTouchTypeFirst;
        }else if (x < width/2 && y < height/2) {
            return QuadrantTouchTypeSecond;
        }else if (x < width/2 && y > height/2) {
            return QuadrantTouchTypeThird;
        }else if (x > width/2 && y > height/2) {
            return QuadrantTouchTypeFourth;
        }else {
            return QuadrantTouchTypeNone;
        }
    }else {
        if (y < width/2) {
            return QuadrantTouchTypeFirst;
        }else if(y > width/2 && y < width){
            return QuadrantTouchTypeSecond;
        }else {
            return QuadrantTouchTypeNone;
        }
    }
}

- (BOOL)touchInTheAnnularWithPoint:(CGPoint)point annularWidth:(CGFloat)annularWidth {
    return [self touchInTheAnnularWithPoint:point annularWidth:annularWidth baseRangeWidth:self.bounds.size.width];
}

- (BOOL)touchInTheAnnularWithPoint:(CGPoint)point annularWidth:(CGFloat)annularWidth baseRangeWidth:(CGFloat)baseRangeWidth {
    CGFloat x = point.x, y = point.y;
    CGFloat width = baseRangeWidth;
    CGFloat dx = fabs(x - width/2);
    CGFloat dy = fabs(y - width/2);
    CGFloat dis = sqrt(dx*dx + dy*dy);
    if (dis > (width/2 - annularWidth) && dis < width/2) {  // 点到圆心的距离
        return YES;
    }
    return NO;
}

- (CGFloat)touchAngleWithPoint:(CGPoint)point baseRangeWidth:(CGFloat)baseRangeWidth {
    CGFloat x = point.x, y = point.y;
    CGFloat width = baseRangeWidth;
    CGFloat dx = fabs(x - width/2);
    CGFloat dy = fabs(y - width/2);
    return atan2(dy, dx);
}

+ (MoveDirection)moveDirection:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    CGFloat dy = startPoint.y - endPoint.y;    // 因为y值是向下增长的,以第一象限点举例
    CGFloat dx = endPoint.x - startPoint.x;
    NSLog(@"dx = %f, dy = %f", dx, dy);
    NSLog(@"dy/dx = %f, atan2(dy, dx) = %f, 角度值 = %f", dy/dx, atan2(dy, dx), atan2(dy, dx) * 180/M_PI);
    
    MoveDirection result = MoveDirectionNoMove;
    if (MAX(fabs(dy), fabs(dx)) < 5) {  // 设置有效滑动距离
        return MoveDirectionNoMove;
    }

    CGFloat angle = [self getAngle:dx dy:dy];
    if (angle >= -45 && angle < 45) {
        result = MoveDirectionRight;
        NSLog(@"向右");
    } else if (angle >= 45 && angle < 135) {
        result = MoveDirectionUp;
        NSLog(@"向上");
    } else if (angle >= -135 && angle < -45) {
        result = MoveDirectionDown;
        NSLog(@"向下");
    }
    else if ((angle >= 135 && angle <= 180) || (angle >= -180 && angle < -135)) {
        result = MoveDirectionLeft;
        NSLog(@"向左");
    }
    
    return result;
}

/**
 *  atan2(y, x):用来计算y/x的反正切值, 返回值范围 : (-pi/2,pi/2)
 */
+ (CGFloat)getAngle:(CGFloat)dx dy:(CGFloat)dy {
    return atan2(dy, dx) * 180/M_PI;
}

@end
