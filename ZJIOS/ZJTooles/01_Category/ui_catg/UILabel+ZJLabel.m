//
//  UILabel+ZJLabel.m
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import "UILabel+ZJLabel.h"

@implementation UILabel (ZJLabel)

// 宽度自适应
+ (CGSize)fitSizeWithText:(NSString *)text font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAXFLOAT, 0)];
    label.text = text;
    label.font = font;
    [label sizeToFit];
    return label.frame.size;
}

// 高度自适应
+ (CGSize)fitSizeWithWidth:(CGFloat)width text:(NSString *)text font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = text;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    return label.frame.size;
}

+ (CGSize)fitSizeWithWidth:(CGFloat)width text:(id)text {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    if ([text isKindOfClass:[NSAttributedString class]]) {
        label.attributedText = text;
    }else {
        label.text = text;
    }
    label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    
    return size;
}

+ (CGSize)fitSizeWithHeight:(CGFloat)height text:(id)text {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    if ([text isKindOfClass:[NSAttributedString class]]) {
        label.attributedText = text;
    }else {
        label.text = text;
    }
    label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:CGSizeMake(MAXFLOAT, height)];

    return size;
}

- (void)italicFont {
    CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(-15 * (CGFloat)M_PI / 180), 1, 0, 0);
    self.transform = matrix;
}

@end
