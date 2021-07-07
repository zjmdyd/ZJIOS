//
//  ZJInputTableViewCell.m
//  WeiMing
//
//  Created by ZJ on 16/04/2018.
//  Copyright © 2018 HY. All rights reserved.
//

#import "ZJInputTableViewCell.h"

@implementation ZJInputTableViewCell

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(inputTableViewCell:didBeganEditWithText:)]) {
        [self.delegate inputTableViewCell:self didBeganEditWithText:textField.text];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(inputTableViewCell:didEndEditWithText:)]) {
        [self.delegate inputTableViewCell:self didEndEditWithText:textField.text];
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(inputTableViewCell:didBeganEditWithText:)]) {
        [self.delegate inputTableViewCell:self didBeganEditWithText:textView.text];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(inputTableViewCell:didEndEditWithText:)]) {
        [self.delegate inputTableViewCell:self didEndEditWithText:textView.text];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
