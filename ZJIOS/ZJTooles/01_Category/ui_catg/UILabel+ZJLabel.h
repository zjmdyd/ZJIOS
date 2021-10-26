//
//  UILabel+ZJLabel.h
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (ZJLabel)

/**
 *  根据文本内容适配Label高度
 */
- (CGSize)fitSizeWithWidth:(CGFloat)width;
- (CGSize)fitSizeWithHeight:(CGFloat)height;
+ (CGSize)fitSizeWithWidth:(CGFloat)width text:(id)text;
+ (CGSize)fitSizeWithHeight:(CGFloat)height text:(id)text;
- (void)resizeHeight;

/**
 斜体
 */
- (void)italicFont;

@end

NS_ASSUME_NONNULL_END
