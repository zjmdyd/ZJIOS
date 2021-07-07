//
//  ZJImageTextFieldTableViewCell.m
//  SuperGymV4
//
//  Created by ZJ on 4/22/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJImageTextFieldTableViewCell.h"
#import "ZJDefine.h"

@interface ZJImageTextFieldTableViewCell ()<UITextFieldDelegate> {
    NSInteger _Countdown;
}

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconLeftWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verifyWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldLeadingConstraint;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ZJImageTextFieldTableViewCell

@synthesize placehold = _placehold;
@synthesize text = _text;
@synthesize textColor = _textColor;
@synthesize font = _font;
@synthesize placeholdColor = _placeholdColor;
@synthesize textAlignment = _textAlignment;
@synthesize keyboardType = _keyboardType;
@synthesize editEnable = _editEnable;
@synthesize secretInput = _secretInput;
@synthesize delegate = _delegate;

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.placehold) {
        if (self.placeholdColor) {
            self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placehold attributes:@{NSForegroundColorAttributeName: self.placeholdColor}];
        }else {
            self.textField.placeholder = self.placehold;
        }
    }
    
    self.backgroundView.frame = CGRectMake(60, 0, kScreenW-120, 50);
    self.selectedBackgroundView.frame = CGRectMake(60, 0, kScreenW-120, 50);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconWidthConstraint.constant = FLT_EPSILON;
    self.needTextFieldLeftMargin = NO;
    self.verifyCode = NO;
    
    self.verifyButton.layer.cornerRadius = 4.0;
    [self.verifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiRefreshEvent:) name:TerminateVerifyTimerNoti object:nil];
}

#pragma mark - setter

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

- (void)setImgName:(NSString *)imgName {
    _imgName = imgName;
    
    self.iconIV.image = [UIImage imageNamed:_imgName];
    
    self.iconWidthConstraint.constant = 25;
    self.textFieldLeadingConstraint.constant = DefaultMargin;
}

- (void)setVerifyCode:(BOOL)verifyCode {
    _verifyCode = verifyCode;
    
    self.verifyWidthConstraint.constant = _verifyCode ? 60 : FLT_EPSILON;
    self.verifyButton.hidden = !_verifyCode;
}

- (void)setIconLeftMargin:(CGFloat)iconLeftMargin {
    _iconLeftMargin = iconLeftMargin;
    
    self.iconLeftWidthConstraint.constant = _iconLeftMargin;
}

- (void)setNeedTextFieldLeftMargin:(BOOL)needTextFieldLeftMargin {
    _needTextFieldLeftMargin = needTextFieldLeftMargin;
    
    self.textFieldLeadingConstraint.constant = _needTextFieldLeftMargin ? DefaultMargin : FLT_EPSILON;
}

- (void)setVerifyBtnBgColor:(UIColor *)verifyBtnBgColor {
    _verifyBtnBgColor = verifyBtnBgColor;
    
    self.verifyButton.backgroundColor = _verifyBtnBgColor;
}

- (void)setVerifyBtnTitleColor:(UIColor *)verifyBtnTitleColor {
    _verifyBtnTitleColor = verifyBtnTitleColor;
    
    [self.verifyButton setTitleColor:_verifyBtnTitleColor forState:UIControlStateNormal];
}

- (void)setVerifyBtnBorderColor:(UIColor *)verifyBtnBorderColor {
    _verifyBtnBorderColor = verifyBtnBorderColor;
    
    self.verifyButton.layer.borderWidth = 1;
    self.verifyButton.layer.borderColor = _verifyBtnBorderColor.CGColor;
}

- (IBAction)getVerify:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(imageTextFieldTabeViewCellRequestVerify:)] && _Countdown == 0) {
        [self.delegate imageTextFieldTabeViewCellRequestVerify:self];
    }
}

- (void)Countdown:(NSTimer *)timer {
    _Countdown--;
    [self.verifyButton setTitle:[NSString stringWithFormat:@"%zds", _Countdown] forState:UIControlStateNormal];
    
    if (_Countdown == 0) {
        [self terminateTimer];
    }
}

- (void)beganCountdown {
    if (!self.hasBeganCountdown) {
        self.hasBeganCountdown = YES;
        [self.textField becomeFirstResponder];
        _Countdown = 60;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Countdown:) userInfo:nil repeats:YES];
    }
}

- (void)terminateTimer {
    [self.timer invalidate];
    self.hasBeganCountdown = NO;
    [self.verifyButton setTitle:@"验证码" forState:UIControlStateNormal];
}

- (void)notiRefreshEvent:(NSNotification *)noti {
    [self terminateTimer];
}

- (BOOL)becomeFirstResponder {
    [super becomeFirstResponder];
    [self.textField becomeFirstResponder];
    
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
