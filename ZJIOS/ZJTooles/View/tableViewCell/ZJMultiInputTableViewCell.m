//
//  ZJMultiInputTableViewCell.m
//  HeLiCommunity
//
//  Created by ZJ on 2019/7/24.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJMultiInputTableViewCell.h"

@implementation ZJMultiInputTableViewCell

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(multiInputTableViewCell:didEndEditAtIndex:text:)]) {
        [self.delegate multiInputTableViewCell:self didEndEditAtIndex:textField.tag text:textField.text];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
