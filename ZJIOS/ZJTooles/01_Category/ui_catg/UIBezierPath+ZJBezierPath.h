//
//  UIBezierPath+ZJBezierPath.h
//  ZJIOS
//
//  Created by issuser on 2022/5/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBezierPath (ZJBezierPath)

+ (UIBezierPath *)pathWithPoint:(CGPoint)p0 toPoint:(CGPoint)p1;
+ (UIBezierPath *)pathWithBorderRectSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
