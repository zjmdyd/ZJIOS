//
//  ZJTitleTextFieldTableViewCell.m
//  SportWatch
//
//  Created by ZJ on 3/14/17.
//  Copyright © 2017 ZJ. All rights reserved.
//

#import "ZJTitleTextFieldTableViewCell.h"

@interface ZJTitleTextFieldTableViewCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ZJTitleTextFieldTableViewCell

@synthesize placehold = _placehold;
@synthesize text = _text;
@synthesize textColor = _textColor;
@synthesize font = _font;
@synthesize placeholdColor = _placeholdColor;
@synthesize textAlignment = _textAlignment;
@synthesize keyboardType = _keyboardType;
@synthesize editEnable = _editEnable;
@synthesize secretInput = _secretInput;

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.placehold) {
        if (self.placeholdColor) {
            self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placehold attributes:@{NSForegroundColorAttributeName: self.placeholdColor}];
        }else {
            self.textField.placeholder = self.placehold;
        }
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
    
    self.textField.text = _text;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    
    self.textField.textColor = _textColor;
    self.textField.tintColor = _textColor;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    
    self.textField.font = _font;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
    
    self.textField.textAlignment = _textAlignment;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _keyboardType = keyboardType;
    
    self.textField.keyboardType = _keyboardType;
}

- (void)setEditEnable:(BOOL)editEnable {
    _editEnable = editEnable;
    
    self.textField.enabled = _editEnable;
}

- (void)setSecretInput:(BOOL)secretInput {
    _secretInput = secretInput;
    
    self.textField.secureTextEntry = _secretInput;
}

- (BOOL)becomeFirstResponder {
    [super becomeFirstResponder];
    [self.textField becomeFirstResponder];
    
    return YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
