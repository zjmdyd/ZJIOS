//
//  ColorTransformer.m
//  ZJIOS
//
//  Created by Zengjian on 2025/5/25.
//

#import "ColorTransformer.h"
#import <UIKit/UIKit.h>

@implementation ColorTransformer

//// 1. 允许转换
//+ (BOOL)allowsReverseTransformation {
//    return YES;
//}
//
//// 2. 转换成什么类
//+ (Class)transformedValueClass {
//    return [NSData class];
//}
//
//// 3. 返回转换后的对象
//- (id)transformedValue:(id)value {
//    UIColor *color = (UIColor *)value;
//    CGFloat red, green, blue, alpha;
//
//    [color getRed:&red green:&green blue:&blue alpha:&alpha];
//    CGFloat components[4] = {red, green, blue, alpha};
//
//    NSData *dataFormaterColor = [[NSData alloc] initWithBytes:components length:sizeof(components)];
//    return dataFormaterColor;
//}
//
////  4. 重新生成原对象
//- (id)reverseTransformedValue:(id)value {
//    NSData *data = (NSData *)value;
//    CGFloat components[4] = {0.0, 0.0, 0.0, 0.0};
//    [data getBytes:components length:sizeof(components)];
//    UIColor *color = [UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:components[3]];
//
//    return color;
//}

@end
