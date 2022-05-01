//
//  ZJTestAppearanceView.m
//  ZJIOS
//
//  Created by issuser on 2022/4/29.
//

#import "ZJTestAppearanceView.h"

@interface ZJTestAppearanceView ()

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;

@end

@implementation ZJTestAppearanceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = frame.size.width/2;
        self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, frame.size.height)];
        self.rightView = [[UIView alloc] initWithFrame:CGRectMake(width, 0, width, frame.size.height)];
        [self addSubview:self.leftView];
        [self addSubview:self.rightView];
    }
    
    return self;
}

- (void)setLeftColor:(UIColor *)leftColor {
    _leftColor = leftColor;
    
    self.leftView.backgroundColor = _leftColor;
}

- (void)setRightColor:(UIColor *)rightColor {
    _rightColor = rightColor;
    
    self.rightView.backgroundColor = _rightColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
