//
//  ZJMaskView.m
//  PhysicalDate
//
//  Created by ZJ on 4/27/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJMaskView.h"

@interface ZJMaskView ()

@property (nonatomic, getter=isHidden) BOOL hidden;
@property (nonatomic, strong) CompletionHandle completion;
@property (nonatomic, assign) BOOL animated;
@property (nonatomic, strong) UIView *maskAlphaView;

@end

#define kMaskViewColor [UIColor colorWithRed:(40/255.0f) green:(40/255.0f) blue:(40/255.0f) alpha:1.0]
#define kMaskAlpha 0.4

@implementation ZJMaskView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
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

/**
 *  如果初始化设置方法名和子类的初始化设置方法名相同,则会调用子类的方法而不会调用父类的方法
 */
- (void)initSetting {
    _hidden = super.hidden = YES;
    _touchEnable = YES;
    
    self.alpha = 0.0;
    self.backgroundColor = [UIColor clearColor];
    
    self.maskAlphaView = [self maskViewWithFrame:self.bounds];
    [self addSubview:self.maskAlphaView];
}

- (UIView *)maskViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = kMaskViewColor;
    view.alpha = kMaskAlpha;
    
    return view;
}

- (void)setHidden:(BOOL)hidden {
    [self setHidden:hidden animated:NO completion:nil];
}

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated completion:(CompletionHandle)completion {
    if (hidden == _hidden) return;
    _hidden = hidden;
    
    if (_hidden) {
        if (animated) {
            [UIView animateWithDuration:DefaultDuration animations:^{
                self.alpha = 0.0;
            } completion:^(BOOL finished) {
                super.hidden = hidden;
                if (completion) completion(finished);
            }];
        }else {
            super.hidden = hidden;
            if (completion) completion(YES);
        }
    }else {
        super.hidden = hidden;
        if (animated) {
            [UIView animateWithDuration:DefaultDuration animations:^{
                self.alpha = 1.0;
            } completion:^(BOOL finished) {
                if (completion) completion(finished);
            }];
        }else {
            self.alpha = 1.0;
            if (completion) completion(YES);
        }
    }
}

- (void)setMaskAlpha:(CGFloat)maskAlpha {
    _maskAlpha = maskAlpha;
    
    self.maskAlphaView.alpha = _maskAlpha;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.isHidden && self.touchEnable) {
        [self setHidden:YES animated:YES completion:nil];
        if ([self.maskDelegate respondsToSelector:@selector(zjMaskViewDidHidden:)]) {
            [self.maskDelegate zjMaskViewDidHidden:self];
        }
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawR
 
 ect:(CGRect)rect {
 // Drawing code
 }
 */

@end
