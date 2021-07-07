//
//  UIColor+ZJColor.m
//  ZJIOS
//
//  Created by Zengjian on 2021/7/5.
//

#import "UIColor+ZJColor.h"

@implementation UIColor (ZJColor)

+ (UIColor *)maskViewColor {
    return [UIColor colorWithRed:(40/255.0f) green:(40/255.0f) blue:(40/255.0f) alpha:1.0];
}

+ (UIColor *)maskViewAlphaColor {
    return [UIColor colorWithRed:(40/255.0f) green:(40/255.0f) blue:(40/255.0f) alpha:0.4];
}

+ (UIColor *)pinkColor {
    return [UIColor colorWithRed:0.9 green:0 blue:0 alpha:0.2];
}

@end
