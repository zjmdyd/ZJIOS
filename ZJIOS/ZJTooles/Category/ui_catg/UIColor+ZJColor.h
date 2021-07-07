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

@end

NS_ASSUME_NONNULL_END
