//
//  ZJFooterView.m
//  HeartGuardForDoctor
//
//  Created by hanyou on 15/11/2.
//  Copyright © 2015年 HANYOU. All rights reserved.
//

#import "ZJFooterView.h"
#import "ZJDefine.h"

@interface ZJFooterView ()

@property (nonatomic, strong) UIButton *button;

@end

#define kButtonHeight 80

@implementation ZJFooterView

@synthesize buttonBgColor = _buttonBgColor;

#pragma mark - init

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSetting];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSetting];
    }
    return self;
}

+ (instancetype)footerViewWithTitle:(NSString *)title delegate:(id<ZJFooterViewDelegate>)delegate{
    ZJFooterView *footView = [ZJFooterView footerViewWithTitle:title frame:CGRectZero superView:nil delegate:delegate];
    
    return footView;
}

+ (instancetype)footerViewWithTitle:(NSString *)title frame:(CGRect)frame delegate:(id<ZJFooterViewDelegate>)delegate{
    ZJFooterView *footView = [ZJFooterView footerViewWithTitle:title frame:frame superView:nil delegate:delegate];
    
    return footView;
}

+ (instancetype)footerViewWithTitle:(NSString *)title frame:(CGRect)frame superView:(UIView *)superView delegate:(id<ZJFooterViewDelegate>)delegate{
    if (CGRectEqualToRect(CGRectZero, frame)) frame = [self defaultFrame];
    
    ZJFooterView *footView = [[ZJFooterView alloc] initWithFrame:frame];
    footView.title = title;
    footView.delegate = delegate;
    if (superView) [superView addSubview:footView];

    return footView;
}

- (void)initSetting {
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    CGFloat left = DefaultSpan*2;
    self.button.frame = CGRectMake(left, 20, self.frame.size.width - left*2, self.frame.size.height - 40);
    self.needCornerRadius = YES;
    self.enableEvent = YES;
    self.button.layer.masksToBounds = YES;
    self.button.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.button setTintColor:[UIColor whiteColor]];
    [self.button addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.button];
}

- (void)btnEvent:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(footerViewDidClick:)]) {
        if ([self.delegate isKindOfClass:[UIViewController class]]) {
            [((UIViewController *)self.delegate).view endEditing:YES];
        }
        [self.delegate footerViewDidClick:self];
    }
}

#pragma mark - setter

- (void)setTitle:(NSString *)title {
    _title = title;
    [self.button setTitle:title forState:UIControlStateNormal];
}

- (void)setButtonBgColor:(UIColor *)buttonBgColor {
    _buttonBgColor = buttonBgColor;
    self.button.backgroundColor = _buttonBgColor;
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    
    self.button.tintColor = _tintColor;
}

- (void)setBoardColor:(UIColor *)boardColor {
    _boardColor = boardColor;
    
    self.button.layer.borderWidth = 1.0;
    self.button.layer.borderColor = _boardColor.CGColor;
}

- (void)setNeedCornerRadius:(BOOL)needCornerRadius {
    _needCornerRadius = needCornerRadius;

    self.button.layer.cornerRadius = _needCornerRadius ? DefaultSpan : FLT_EPSILON;
}

#pragma mark - getter

+ (CGRect)defaultFrame {
    return CGRectMake(0, 0, kScreenW, kButtonHeight);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
