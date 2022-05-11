//
//  UITextField+ZJTextField.h
//  ZJIOS
//
//  Created by issuser on 2022/5/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZJTextFieldTextType) {
    ZJTextFieldTextTypeDefault,
    ZJTextFieldTextTypeNumber,  // 只能输入数字
};

@interface UITextField (ZJTextField)<UITextFieldDelegate>

@property (nonatomic, assign) BOOL containedPoint;
@property (nonatomic, assign) ZJTextFieldTextType textType;

@end

NS_ASSUME_NONNULL_END
