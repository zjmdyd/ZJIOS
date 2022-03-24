//
//  UILabel+ZJLabel.h
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (ZJLabel)

// 宽度自适应
+ (CGSize)fitSizeWithText:(NSString *)text font:(UIFont *)font;
// 高度自适应
+ (CGSize)fitSizeWithWidth:(CGFloat)width text:(NSString *)text font:(UIFont *)font;

/**
 *  根据文本内容适配Label高度
 */
+ (CGSize)fitSizeWithWidth:(CGFloat)width text:(id)text;
+ (CGSize)fitSizeWithHeight:(CGFloat)height text:(id)text;

/**
 斜体
 */
- (void)italicFont;

@end

NS_ASSUME_NONNULL_END
