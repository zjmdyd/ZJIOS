//
//  ZJPickerView.m
//  TestCategory
//
//  Created by ZJ on 1/1/17.
//  Copyright © 2017 ZJ. All rights reserved.
//

#import "ZJPickerView.h"
#import "ZJTopEdgeTitleView.h"

@interface ZJPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIView *bottomView;   // 底部的View
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) CompletionHandle completion;

@property (nonatomic, getter=isHidden) BOOL hidden;

@end

@implementation ZJPickerView

@synthesize bottomViewBackgroundColor = _bottomViewBackgroundColor;

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
    return [self initWithSuperView:superView dateSource:nil delegate:nil];
}

- (instancetype)initWithSuperView:(UIView *)superView dateSource:(id <ZJPickerViewDataSource>)dataSource delegate:(id <ZJPickerViewDelegate>)delegate {
    self = [self initWithFrame:superView.bounds];
    if (self) {
        [superView addSubview:self];
        _dataSource = dataSource;
        _delegate = delegate;
        [self.pickerView reloadAllComponents];
    }
    
    return self;
}

- (void)initSetting2 {
    _hidden = YES;
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, PickerViewHeight)];
    self.bottomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:self.bottomView];
    
    self.topView = [[ZJTopEdgeTitleView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40) target:self];
    [self.bottomView addSubview:self.topView];
    
    CGFloat originY = self.topView.bounds.size.height+1;
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, originY, self.bottomView.bounds.size.width, PickerViewHeight - originY)];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.backgroundColor = [UIColor whiteColor];
    [self.bottomView addSubview:self.pickerView];
}

- (void)clickButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(pickerView:clickedButtonAtIndex:)]) {
        [self.delegate pickerView:self clickedButtonAtIndex:sender.tag];
    }
    
    self.hidden = YES;
}

- (NSInteger)selectedRowInComponent:(NSInteger)component {
    if (self.dataSource && self.numberOfComponents > 0) {
        return [self.pickerView selectedRowInComponent:component];
    }
    return 0;
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    if (self.dataSource && self.numberOfComponents > 0) {
        [self.pickerView selectRow:row inComponent:component animated:animated];
    }
}

- (CGSize)rowSizeForComponent:(NSInteger)component {
    return [self.pickerView rowSizeForComponent:component];
}

#pragma mark - reloadData

- (void)reloadComponent:(NSInteger)component {
    [self.pickerView reloadComponent:component];
}

- (void)reloadAllComponents {
    [self.pickerView reloadAllComponents];
}

#pragma mark - setter

- (void)setDataSource:(id<ZJPickerViewDataSource>)dataSource {
    _dataSource = dataSource;
    
    if (self.indexPath) self.indexPath = nil;
    
//    for (int i = 0; i < self.numberOfComponents; i++) {
//        [self.pickerView selectRow:0 inComponent:i animated:NO];
//    }
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

#pragma mark - getter - 设置初始值

- (NSInteger)numberOfComponents {
    return self.pickerView.numberOfComponents;
}

- (UIColor *)bottomViewBackgroundColor {
    if (!_bottomViewBackgroundColor) {
        _bottomViewBackgroundColor = [UIColor whiteColor];
    }
    return _bottomViewBackgroundColor;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if ([self.dataSource respondsToSelector:@selector(numberOfComponentsInPickerView:)]) {
        return [self.dataSource numberOfComponentsInPickerView:self];
    }
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([self.dataSource respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)]) {
        return [self.dataSource pickerView:self numberOfRowsInComponent:component];
    }
    
    return 0;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(ZJPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([self.delegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)]) {
        return [self.delegate pickerView:self titleForRow:row forComponent:component];
    }
    return nil;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([self.delegate respondsToSelector:@selector(pickerView:attributedTitleForRow:forComponent:)]) {
        return [self.delegate pickerView:self attributedTitleForRow:row forComponent:component];
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([self.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        [self.delegate pickerView:self didSelectRow:row inComponent:component];
    }
}

#pragma mark - touchEvent

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *th = touches.anyObject;
    CGPoint point = [th locationInView:self];
    if (point.y > [UIScreen mainScreen].bounds.size.height - PickerViewHeight) {
        return;
    }
    if (self.touchEnable) {
        self.hidden = YES;
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)reset {
    for (int i = 0; i < self.numberOfComponents; i++) {
        [self selectRow:0 inComponent:i animated:NO];
    }
    
    self.dataSource = nil;
    self.delegate = nil;
    self.tag = 0;
    self.topView.mentionTitle = @"";
}

@end
