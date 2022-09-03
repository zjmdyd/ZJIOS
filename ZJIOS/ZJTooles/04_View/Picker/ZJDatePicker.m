//
//  ZJDatePicker.m
//  TestCategory
//
//  Created by ZJ on 12/30/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJDatePicker.h"
#import "ZJTopEdgeTitleView.h"

@interface ZJDatePicker ()

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) CompletionHandle completion;

@property (nonatomic, getter=isHidden) BOOL hidden;

@end

@implementation ZJDatePicker

@synthesize date = _date;

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

- (instancetype)initWithSuperView:(UIView *)superView datePickerMode:(UIDatePickerMode)mode {
    self = [super initWithFrame:superView.bounds];
    if (self) {
        _datePickerMode = mode;
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
    [self.bottomView addSubview:self.topView];
    
    CGFloat originY = self.topView.bounds.size.height+1;
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, originY, self.bounds.size.width, PickerViewHeight - originY)];
    [self.datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.datePickerMode = _datePickerMode;
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [self.bottomView addSubview:self.datePicker];
}

- (void)clickButton:(UIButton *)sender {
    if (sender.tag == 0) {
        self.date = self.oldDate;
    }else {
        _date = self.datePicker.date;
        self.oldDate = _date;
    }
    if ([self.delegate respondsToSelector:@selector(datePicker:clickedButtonAtIndex:)]) {
        [self.delegate datePicker:self clickedButtonAtIndex:sender.tag];
    }
    
    self.hidden = YES;
}

- (void)dateChange:(UIDatePicker *)sender {
    if ([self.delegate respondsToSelector:@selector(datePickerDidChangeDate:)]) {
        self.date = sender.date;
        [self.delegate datePickerDidChangeDate:self];
    }
}

#pragma mark - setter

- (void)setDate:(NSDate *)date {
    [self setDate:date animated:NO];
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated {
    _date = date?:[NSDate date];
    [self.datePicker setDate:_date animated:animated];
}

- (void)setMinDate:(NSDate *)minDate {
    _minDate = minDate;
    self.datePicker.minimumDate = minDate;
    
    _maxDate = [NSDate distantFuture];
    self.datePicker.maximumDate = _maxDate;
}

- (void)setMaxDate:(NSDate *)maxDate {
    _maxDate = maxDate;
    self.datePicker.maximumDate = maxDate;
    
    _minDate = [NSDate distantPast];
    self.datePicker.minimumDate = _minDate;
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode {
    _datePickerMode = datePickerMode;
    self.datePicker.datePickerMode = datePickerMode;
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

- (NSDate *)date {
    _date = self.datePicker.date;
    return _date;
}

- (NSDate *)oldDate {
    if (!_oldDate) {
        _oldDate = self.datePicker.date;
    }
    
    return _oldDate;
}

#pragma mark - touchEvent

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.touchEnable) {
        self.hidden = YES;
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)reset {
    self.date = [NSDate date];
    self.minDate = [NSDate distantPast];
    self.maxDate = [NSDate distantFuture];
    self.delegate = nil;
    self.tag = 0;
    self.topView.mentionTitle = @"";
}

@end
