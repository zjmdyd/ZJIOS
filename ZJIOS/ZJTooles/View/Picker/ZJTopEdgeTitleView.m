//
//  ZJTopEdgeTitleView.m
//  ZJCustomTools
//
//  Created by ZJ on 6/15/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJTopEdgeTitleView.h"

@implementation UIView(FitFrameView)

- (CGFloat) top {
    return self.frame.origin.y;
}

- (void) setTop: (CGFloat) newtop {
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

- (CGSize) size {
    return self.frame.size;
}

- (void) setSize: (CGSize) aSize {
    CGRect newframe = self.frame;
    newframe.size = aSize;
    self.frame = newframe;
}

- (CGFloat) height {
    return self.frame.size.height;
}

- (void) setHeight: (CGFloat) newheight {
    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

@end

@interface ZJTopEdgeTitleView ()

@property (nonatomic, strong) UILabel *mentionLabel;

@end

@implementation ZJTopEdgeTitleView

@synthesize leftButtonTitleColor = _leftButtonTitleColor;
@synthesize rightButtonTitleColor = _rightButtonTitleColor;

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initSettingWithTarget:nil];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSettingWithTarget:nil];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame target:(id)target {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSettingWithTarget:target];
    }
    
    return self;
}

- (void)initSettingWithTarget:(id)target {
    self.backgroundColor = [UIColor whiteColor];
    
    NSArray *titles = @[@"取消", @"确定"];
    CGFloat width = 50;
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.tag = i;
        btn.frame = CGRectMake(i*(self.frame.size.width - width), 0, width, self.frame.size.height);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        if (target) {
            [btn addTarget:target action:NSSelectorFromString(@"clickButton:") forControlEvents:UIControlEventTouchUpInside];
        }
        [self addSubview:btn];
    }
    
    self.mentionLabel = [[UILabel alloc] initWithFrame:CGRectMake(width, 0, self.frame.size.width - 2*width, self.frame.size.height)];
    self.mentionLabel.textAlignment = NSTextAlignmentCenter;
    self.mentionLabel.textColor = self.mentionTitleColor;
    [self addSubview:self.mentionLabel];
}

- (void)setTarget:(id)target {
    _target = target;
    
    for (UIButton *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn addTarget:_target action:NSSelectorFromString(@"clickButton:") forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

#pragma mark - setter

- (void)setLeftTitle:(NSString *)leftTitle {
    _leftTitle = leftTitle;
    UIButton *btn = [self.subviews objectAtIndex:0];
    btn.enabled = _leftTitle.length;
    [btn setTitle:_leftTitle forState:UIControlStateNormal];
}

- (void)setRightTitle:(NSString *)rightTitle {
    _rightTitle = rightTitle;
    UIButton *btn = [self.subviews objectAtIndex:1];
    [btn setTitle:_rightTitle forState:UIControlStateNormal];
    [btn setBackgroundImage:nil forState:UIControlStateNormal];
}

- (void)setRightButtonImgName:(NSString *)rightButtonImgName {
    _rightButtonImgName = rightButtonImgName;
    
    UIButton *btn = [self.subviews objectAtIndex:1];
    [btn setTitle:@"" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:_rightButtonImgName] forState:UIControlStateNormal];
    btn.contentMode = UIViewContentModeScaleAspectFit;
    btn.size = CGSizeMake(44, 25);//16 9
    //    btn.left -= 8;
    btn.top += (40-btn.height) / 2;
}

- (void)setMentionTitle:(NSString *)mentionTitle {
    _mentionTitle = mentionTitle;
    self.mentionLabel.text = _mentionTitle;
}

- (void)setMentionAttrTitle:(NSAttributedString *)mentionAttrTitle {
    _mentionAttrTitle = mentionAttrTitle;
    
    self.mentionLabel.attributedText = _mentionAttrTitle;
}

- (void)setLeftButtonTitleColor:(UIColor *)leftButtonTitleColor {
    _leftButtonTitleColor = leftButtonTitleColor;
    UIButton *btn = [self.subviews objectAtIndex:0];
    [btn setTitleColor:_leftButtonTitleColor forState:UIControlStateNormal];
}

- (void)setRightButtonTitleColor:(UIColor *)rightButtonTitleColor {
    _rightButtonTitleColor = rightButtonTitleColor;
    UIButton *btn = [self.subviews objectAtIndex:1];
    [btn setTitleColor:_rightButtonTitleColor forState:UIControlStateNormal];
}

- (void)setMentionTitleColor:(UIColor *)mentionTitleColor {
    _mentionTitleColor = mentionTitleColor;
    self.mentionLabel.textColor = _mentionTitleColor;
}

@end
