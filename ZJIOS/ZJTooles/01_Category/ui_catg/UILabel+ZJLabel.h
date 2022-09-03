//
//  UILabel+ZJLabel.h
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (ZJLabel)

#pragma mark 高度自适应

// 给定宽度
+ (CGSize)fitSizeWithWidth:(CGFloat)width text:(NSString *)text font:(UIFont *)font;
+ (CGSize)fitSizeWithWidth:(CGFloat)width text:(id)text;

#pragma mark 宽度自适应

// 匹配文字最大宽度，高度设置不起作用
+ (CGSize)fitSizeWithText:(NSString *)text font:(UIFont *)font;
+ (CGSize)fitSizeWithText:(id)text;

// 根据设置的宽高匹配最适合的size, 优先匹配宽度
- (void)fitSizeWithFont:(UIFont *)font;

/**
 斜体
 */
- (void)italicFont;

@end

NS_ASSUME_NONNULL_END
