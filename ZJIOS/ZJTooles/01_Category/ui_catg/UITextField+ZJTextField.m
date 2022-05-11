//
//  UITextField+ZJTextField.m
//  ZJIOS
//
//  Created by issuser on 2022/5/7.
//

#import "UITextField+ZJTextField.h"
#import "NSString+ZJString.h"
#include <objc/runtime.h>

@implementation UITextField (ZJTextField)

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.textType == ZJTextFieldTextTypeNumber) {
        NSString *filterStr = [string pureNumberStringContainedPoint:self.containedPoint];
        if ([string isEqualToString:filterStr]) {
            return YES;
        }else {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - textType

- (void)setTextType:(ZJTextFieldTextType)textType {
    // objc_setAssociatedObject（将某个值跟某个对象关联起来，将某个值存储到某个对象中）
    // object:给哪个对象添加属性
    // key:属性名称
    // value:属性值
    // policy:保存策略
    objc_setAssociatedObject(self, @selector(textType), @(textType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ZJTextFieldTextType)textType {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

#pragma mark - containedPoint

- (void)setContainedPoint:(BOOL)containedPoint {
    objc_setAssociatedObject(self, @selector(containedPoint), @(containedPoint), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)containedPoint {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end
