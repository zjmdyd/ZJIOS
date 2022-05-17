//
//  UIBezierPath+ZJBezierPath.m
//  ZJIOS
//
//  Created by issuser on 2022/5/16.
//

#import "UIBezierPath+ZJBezierPath.h"

@implementation UIBezierPath (ZJBezierPath)

+ (UIBezierPath *)pathWithPoint:(CGPoint)p0 toPoint:(CGPoint)p1 {
    // 线的路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:p0];
    [path addLineToPoint:p1];
    
    return path;
}

+ (UIBezierPath *)pathWithBorderRectSize:(CGSize)size {
    CGFloat s_width = size.width;
    CGFloat s_height = size.height;
    
    // 水平
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.0f, 0.0f)];
    [path addLineToPoint:CGPointMake(s_width, 0.0f)];
    
    // 垂直
    [path addLineToPoint:CGPointMake(s_width, s_height)];
    [path addLineToPoint:CGPointMake(0.0f, s_height)];
    
    [path addLineToPoint:CGPointMake(0.0f, 0.0f)];
    
    return path;
}

@end
