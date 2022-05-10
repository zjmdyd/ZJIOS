//
//  UITextField+ZJTextField.m
//  ZJIOS
//
//  Created by issuser on 2022/5/7.
//

#import "UITextField+ZJTextField.h"

@implementation UITextField (ZJTextField)

@dynamic textType;

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.textType == UITextFieldTextTypeNumber) {
        NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        NSString *filterStr = [[string componentsSeparatedByCharactersInSet:charSet.invertedSet] componentsJoinedByString:@""];
        if ([string isEqualToString:filterStr]) {
            return YES;
        }
    }
    
    return YES;
}

@end
