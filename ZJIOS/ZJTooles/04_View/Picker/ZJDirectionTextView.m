//
//  ZJDirectionTextView.m
//  CanShengHealth
//
//  Created by ZJ on 04/04/2018.
//  Copyright © 2018 HY. All rights reserved.
//

#import "ZJDirectionTextView.h"
#import "ZJTopEdgeTitleView.h"

@interface ZJDirectionTextView ()

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) CompletionHandle completion;

@property (nonatomic, getter=isHidden) BOOL hidden;

@end

@implementation ZJDirectionTextView

#pragma mark - init

/**
 *  当只调用init方法, 也会调用initFrame方法,
 *  则对象的frame初始值为CGRectZero
 */
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSetting2];
    }
    return self;
}

- (instancetype)initWithSuperView:(UIView *)superView {
    self = [super initWithFrame:superView.bounds];
    if (self) {
        [superView addSubview:self];
        [self initSetting2];
    }
    
    return self;
}

- (void)initSetting2 {
    _hidden = YES;
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, PickerViewHeight)];
    self.bottomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:self.bottomView];
    
    self.topView = [[ZJTopEdgeTitleView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40) target:self];
    self.topView.leftTitle = @"";
    [self.bottomView addSubview:self.topView];
    
    CGFloat originY = self.topView.bounds.size.height+1;
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, originY, self.bounds.size.width, PickerViewHeight - originY)];
    self.textView.editable = NO;
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.contentInset =UIEdgeInsetsMake(8, 8, 8, 8);
    [self.bottomView addSubview:self.textView];
    
    self.touchEnable = NO;
}

- (void)clickButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(directionTextView:clickedButtonAtIndex:)]) {
        [self.delegate directionTextView:self clickedButtonAtIndex:sender.tag];
    }
    
    self.hidden = YES;
}

#pragma mark - setter

- (void)setText:(NSString *)text {
    _text = text;
    
    self.textView.text = _text;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    
    self.textView.textColor = _textColor;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    
    self.textView.font = _font;
}

- (void)setBottomViewBackgroundColor:(UIColor *)bottomViewBackgroundColor {
    _bottomViewBackgroundColor = bottomViewBackgroundColor;
    
    self.bottomView.backgroundColor = _bottomViewBackgroundColor;
}

- (void)setHidden:(BOOL)hidden {
    [self setHidden:hidden animated:NO completion:nil];
}

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated completion:(CompletionHandle)completion {
    if (hidden == _hidden) return;
    
    _hidden = hidden;
    
    if (_hidden) {
        __block CGRect frame = self.bottomView.frame;
        [UIView animateWithDuration:DefaultDuration animations:^{
            frame.origin.y += PickerViewHeight;
            self.bottomView.frame = frame;
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [super setHidden:hidden animated:animated completion:completion];
            
            if (self.completion) self.completion(finished);
        }];
    }else {
        [super setHidden:hidden animated:animated completion:completion];
        
        __block CGRect frame = self.bottomView.frame;
        [UIView animateWithDuration:DefaultDuration animations:^{
            frame.origin.y -= PickerViewHeight;
            self.bottomView.frame = frame;
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
            if (self.completion) self.completion(finished);
        }];
    }
}

#pragma mark - showWithText

- (void)showWithMentionText:(NSString *)text {
    [self showWithMentionText:text completion:nil];
}

- (void)showWithMentionText:(NSString *)text completion:(CompletionHandle)completion {
    self.topView.mentionTitle = text;
    [self setHidden:NO animated:YES completion:completion];
}

#pragma mark - getter 设置初始值

#pragma mark - touchEvent

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.touchEnable) {
        self.hidden = YES;
    }else {
        UITouch *th = touches.allObjects.firstObject;
        if (![th.view isKindOfClass:[UITextView class]] && ![th.view isKindOfClass:[ZJTopEdgeTitleView class]]) {
            self.hidden = YES;
        }
    }
    [super touchesBegan:touches withEvent:event];
}

@end
