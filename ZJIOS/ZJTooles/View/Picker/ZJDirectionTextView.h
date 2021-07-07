//
//  ZJDirectionTextView.h
//  CanShengHealth
//
//  Created by ZJ on 04/04/2018.
//  Copyright © 2018 HY. All rights reserved.
//

#import "ZJMaskView.h"

@class ZJDirectionTextView;
@class ZJTopEdgeTitleView;

@protocol ZJDirectionTextViewDelegate <NSObject>

@optional

- (void)directionTextView:(ZJDirectionTextView *)directionTextView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface ZJDirectionTextView : ZJMaskView

- (instancetype)initWithSuperView:(UIView *)superView;

@property (nonatomic, weak) id <ZJDirectionTextViewDelegate> delegate;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font; // 默认15

/**
 *  底部的topView
 */
@property (nonatomic, strong) ZJTopEdgeTitleView *topView;

/**
 *  底部背景色, 分割线颜色
 */
@property (nonatomic, strong) UIColor *bottomViewBackgroundColor;

/**
 *  弹窗时需要显示提示文字时调用该方法
 *
 *  @param text 显示在弹出框正上方的文字
 */
- (void)showWithMentionText:(NSString *)text;
- (void)showWithMentionText:(NSString *)text completion:(CompletionHandle)completion;

@end

