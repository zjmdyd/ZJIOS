//
//  UIColor+Hex.h
//  KidReading
//
//  Created by telen on 15/1/1.
//  Copyright (c) 2015年 Creative Knowledge Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

//字符串转颜色
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;

//字符串转颜色
+ (UIColor *) colorWithARGBHexString: (NSString *) stringToConvert;

//颜色转字符串
+ (NSString *) changeUIColorToRGB:(UIColor *)color;
//颜色转字符串 同时去除透明度
+ (NSString *) changeUIColorToRGB:(UIColor *)color withAlpha:(CGFloat*)alpha;

@end
