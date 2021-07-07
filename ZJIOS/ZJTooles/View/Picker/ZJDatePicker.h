//
//  ZJDatePicker.h
//  TestCategory
//
//  Created by ZJ on 12/30/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJMaskView.h"

@class ZJDatePicker;
@class ZJTopEdgeTitleView;

@protocol ZJDatePickerDelegate <NSObject>

@optional

- (void)datePicker:(ZJDatePicker *)datePicker clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)datePickerDidChangeDate:(ZJDatePicker *)datePicker;

@end

@interface ZJDatePicker : ZJMaskView

- (instancetype)initWithSuperView:(UIView *)superView datePickerMode:(UIDatePickerMode)mode;

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *minDate;
@property (nonatomic, strong) NSDate *maxDate;
@property (nonatomic, strong) NSDate *oldDate;

@property (nonatomic, assign) UIDatePickerMode datePickerMode;
@property (nonatomic, weak  ) id <ZJDatePickerDelegate> delegate;

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

- (void)setDate:(NSDate *)date animated:(BOOL)animated;

- (void)reset;

@end
