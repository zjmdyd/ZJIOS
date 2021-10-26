//
//  UILabel+ZJLabel.m
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import "UILabel+ZJLabel.h"

@implementation UILabel (ZJLabel)

- (UILabel *)accessoryViewWithText:(id)text bgColor:(UIColor *)color frame:(CGRect)frame {
    return [self accessoryViewWithText:text bgColor:color frame:frame needCornerRadius:NO];
}

- (UILabel *)accessoryViewWithText:(id)text bgColor:(UIColor *)color frame:(CGRect)frame needCornerRadius:(BOOL)need {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.numberOfLines = 0;
    if ([text isKindOfClass:[NSAttributedString class]]) {
        label.attributedText = text;
    }else {
        label.text = text;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
    }
    
    label.backgroundColor = color;
    
    if (need) {
        label.layer.cornerRadius = 8;
        label.layer.masksToBounds = YES;
    }
    
    return label;
}

- (CGSize)fitSizeWithWidth:(CGFloat)width {
    self.numberOfLines = 0;
    CGSize size = [self sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    
    return size;
}

- (CGSize)fitSizeWithHeight:(CGFloat)height {
    self.numberOfLines = 0;
    CGSize size = [self sizeThatFits:CGSizeMake(MAXFLOAT, height)];
    
    return size;
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
    CGSize size = [label sizeThatFits:CGSizeMake(MAXFLOAT, height)];

    return size;
}

- (void)resizeHeight {
    CGSize size = [self fitSizeWithWidth:self.bounds.size.width];
    CGRect newframe = self.frame;
    newframe.size.height = size.height;
    self.frame = newframe;
}

- (void)italicFont {
    CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(-15 * (CGFloat)M_PI / 180), 1, 0, 0);
    self.transform = matrix;
}

@end
