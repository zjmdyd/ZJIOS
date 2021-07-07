//
//  ZJTextViewTableViewCell.m
//  CanShengHealth
//
//  Created by ZJ on 26/01/2018.
//  Copyright © 2018 HY. All rights reserved.
//

#import "ZJTextViewTableViewCell.h"

@interface ZJTextViewTableViewCell() <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ZJTextViewTableViewCell

@synthesize placehold = _placehold;
@synthesize text = _text;
@synthesize textColor = _textColor;
@synthesize font = _font;
@synthesize placeholdColor = _placeholdColor;
@synthesize textAlignment = _textAlignment;
@synthesize keyboardType = _keyboardType;
@synthesize editEnable = _editEnable;

#pragma mark - UITextViewDelegate

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.placehold) {
#ifdef textViewPlacehold
        self.textView.placeholder = self.placehold;
        if (self.placeholdColor) {
            self.textView.placeholderColor = self.placeholdColor;
        }
#endif
    }
}

#pragma mark - setter

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = _title;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    
    self.titleLabel.textColor = _titleColor;
}

- (void)setText:(NSString *)text {
    _text = text;
    
    self.textView.text = _text;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    
    self.textView.textColor = _textColor;
    self.textView.tintColor = _textColor;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    
    self.textView.font = _font;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
    
    self.textView.textAlignment = _textAlignment;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _keyboardType = keyboardType;
    
    self.textView.keyboardType = _keyboardType;
}

- (void)setEditEnable:(BOOL)editEnable {
    _editEnable = editEnable;
    
    self.textView.editable = _editEnable;
}

- (void)setContentBgColor:(UIColor *)contentBgColor {
    _contentBgColor = contentBgColor;
    
    self.textView.backgroundColor = _contentBgColor;
}

- (BOOL)becomeFirstResponder {
    [super becomeFirstResponder];
    [self.textView becomeFirstResponder];
    
    return YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
