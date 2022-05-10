//
//  UITextField+ZJTextField.h
//  ZJIOS
//
//  Created by issuser on 2022/5/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UITextFieldTextType) {
    UITextFieldTextTypeDefault,
    UITextFieldTextTypeNumber,  // 只能输入数字
};

@interface UITextField (ZJTextField)<UITextFieldDelegate>

@property (nonatomic, assign) UITextFieldTextType textType;

@end

NS_ASSUME_NONNULL_END
