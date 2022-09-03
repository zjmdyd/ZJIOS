//
//  UILabel+ChangeFont.m
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import "UILabel+ZJLabel.h"

@implementation UILabel (ZJLabel)

#pragma mark 高度自适应

// 给定宽度
+ (CGSize)fitSizeWithWidth:(CGFloat)width text:(NSString *)text font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = text;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    
    return label.frame.size;
}

+ (CGSize)fitSizeWithWidth:(CGFloat)width text:(id)text {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    if ([text isKindOfClass:[NSAttributedString class]]) {
        label.attributedText = text;
    }else {
        label.text = text;
    }
    label.numberOfLines = 0;
    [label sizeToFit];
    
    return label.frame.size;
}

#pragma mark 宽度自适应

// 匹配文字最大宽度，高度设置不起作用
+ (CGSize)fitSizeWithText:(NSString *)text font:(UIFont *)font {
    return [self fitSizeWithWidth:0 text:text font:font];
}

+ (CGSize)fitSizeWithText:(id)text {
    return [self fitSizeWithWidth:0 text:text];
}

// 根据设置的宽高匹配最适合的size, 优先匹配宽度
- (void)fitSizeWithFont:(UIFont *)font {
    self.font = font;
    self.numberOfLines = 0;
    [self sizeToFit];
}

- (void)italicFont {
    CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(-15 * (CGFloat)M_PI / 180), 1, 0, 0);
    self.transform = matrix;
}

@end
