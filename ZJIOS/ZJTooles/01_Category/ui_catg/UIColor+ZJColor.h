//
//  UIColor+ZJColor.h
//  ZJIOS
//
//  Created by Zengjian on 2021/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (ZJColor)

/**
 *  半透明遮罩层
 */
+ (UIColor *)maskViewColor;
+ (UIColor *)maskViewAlphaColor;

/**
 *  粉红色
 */
+ (UIColor *)pinkColor;

// 透明度固定为1，以0x开头的十六进制转换成的颜色
+ (UIColor *)colorWithHex:(long)hexColor;
// 0x开头的十六进制转换成的颜色,透明度可调整
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;
// 颜色转换三：iOS中十六进制的颜色（以#开头）转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color;
// 颜色转换四：iOS中十六进制的颜色（以#开头）转换为UIColor
+ (UIColor *)colorWithHexString:(NSString *)hexColor alpha:(float)opacity;
@end

NS_ASSUME_NONNULL_END
