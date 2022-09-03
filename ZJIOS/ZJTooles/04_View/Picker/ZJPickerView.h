//
//  ZJPickerView.h
//  TestCategory
//
//  Created by ZJ on 1/1/17.
//  Copyright © 2017 ZJ. All rights reserved.
//

#import "ZJMaskView.h"

@class ZJPickerView;
@class ZJTopEdgeTitleView;

@protocol ZJPickerViewDataSource <NSObject>

@optional
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(ZJPickerView *)pickerView;

@required
// returns the # of rows in each component..
- (NSInteger)pickerView:(ZJPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

@end

@protocol ZJPickerViewDelegate <NSObject>

@optional

- (NSString *)pickerView:(ZJPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (NSAttributedString *)pickerView:(ZJPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component;

- (void)pickerView:(ZJPickerView *)pickerView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)pickerView:(ZJPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end

@interface ZJPickerView : ZJMaskView

- (instancetype)initWithSuperView:(UIView *)superView;
- (instancetype)initWithSuperView:(UIView *)superView dateSource:(id <ZJPickerViewDataSource>)dataSource delegate:(id <ZJPickerViewDelegate>)delegate;

@property (nonatomic, weak) id <ZJPickerViewDataSource> dataSource;
@property (nonatomic, weak) id <ZJPickerViewDelegate> delegate;

@property(nonatomic, readonly) NSInteger numberOfComponents;
@property (nonatomic, strong) NSIndexPath *indexPath;

/**
 *  底部的topView
 */
@property (nonatomic, strong) ZJTopEdgeTitleView *topView;

/**
 *  底部背景色,默认为白色
 */
@property (nonatomic, strong) UIColor *bottomViewBackgroundColor;

/**
 *  弹窗时需要显示提示文字时调用该方法
 *
 *  @param text 显示在弹出框正上方的文字
 */
- (void)showWithMentionText:(NSString *)text;
- (void)showWithMentionText:(NSString *)text completion:(CompletionHandle)completion;

- (void)reloadComponent:(NSInteger)component;
- (void)reloadAllComponents;

- (NSInteger)selectedRowInComponent:(NSInteger)component;
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;
- (CGSize)rowSizeForComponent:(NSInteger)component;
- (void)reset;

@end
