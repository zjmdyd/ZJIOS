//
//  ZJKeyboardManager.m
//  HeLiCommunity
//
//  Created by ZJ on 2019/8/22.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJKeyboardManager.h"

@interface ZJKeyboardManager ()

@property (assign, nonatomic) CGRect keyboardFrame;
@property (weak, nonatomic) UITextField * nowTF;

@end

ZJKeyboardManager *_zjKeyboardManager;

@implementation ZJKeyboardManager

+ (void)load {
    [self shareInstance];
}

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _zjKeyboardManager = [[ZJKeyboardManager alloc] init];
        _zjKeyboardManager.keyboardOffsetY = 8;
        _zjKeyboardManager.enable = YES;
        [_zjKeyboardManager setup];
    });
    
    return _zjKeyboardManager;
}

- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:_zjKeyboardManager selector:@selector(KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:_zjKeyboardManager selector:@selector(KeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:_zjKeyboardManager selector:@selector(TextFieldTextDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:_zjKeyboardManager selector:@selector(TextFieldTextDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
}

- (void)KeyboardWillShow:(NSNotification *)noti {
    if (!self.enable) {
        return;
    }
    NSValue * vv = noti.userInfo[UIKeyboardFrameEndUserInfoKey];
    self.keyboardFrame = [vv CGRectValue];  // 键盘的frame
    UITextField *tf = self.nowTF;
    UIView * view = [self getViewOnWindow:tf];  // selectVeiw
    if (view) {
        CGRect fr = [tf.superview convertRect:tf.frame toView:[UIApplication sharedApplication].keyWindow]; // textField的frame
        CGRect fr2 = [view.superview convertRect:view.frame toView:[UIApplication sharedApplication].keyWindow];    // selectVeiw的frame
        CGFloat y = CGRectGetMaxY(fr);
        CGFloat y2 = self.keyboardFrame.origin.y;
        CGFloat y3 = y2-y-self.keyboardOffsetY;
        
        if (y3 < 0) {
            //tf提起
            [UIView animateWithDuration:0.25f animations:^{
                view.transform = CGAffineTransformMakeTranslation(fr2.origin.x, fr2.origin.y+y3);
            }];
        }
    }
}

- (void)KeyboardWillHide:(NSNotification *)noti {
    //    NSLog(@"wzz%@", noti.userInfo);
}

- (void)TextFieldTextDidBeginEditing:(NSNotification *)noti {
    if (!self.enable) {
        return;
    }
    UITextField * tf = noti.object;
    self.nowTF = tf;
}

- (void)TextFieldTextDidEndEditing:(NSNotification *)noti {
    if (!self.enable) {
        return;
    }
    UITextField * tf = noti.object;
    UIView * view = [self getViewOnWindow:tf];
    if (view) {
        [UIView animateWithDuration:0.25f animations:^{
            view.transform = CGAffineTransformIdentity;
        }];
    }
}

- (UIView *)getViewOnWindow:(UIView *)view {
    UIResponder *nextResponder = view;
    
    while (nextResponder && ![nextResponder isKindOfClass:[UIWindow class]]) {
        nextResponder = [nextResponder nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return nil;
        }
        if (![nextResponder isKindOfClass:[UIWindow class]] && [nextResponder isKindOfClass:[UIView class]]) {
            view = (UIView *)nextResponder;
        }
    }
    
    return view;
}

@end
