//
//  ZJImageTextFieldTableViewCell.h
//  SuperGymV4
//
//  Created by ZJ on 4/22/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJInputTableViewCell.h"

#define TerminateVerifyTimerNoti @"terminateVerifyNoti"

@class ZJImageTextFieldTableViewCell;

@protocol ZJImageTextFieldTableViewCellDelegate  <ZJInputTableViewCelllDelegate>

@optional

- (void)imageTextFieldTabeViewCellRequestVerify:(ZJImageTextFieldTableViewCell *)cell;

@end

@interface ZJImageTextFieldTableViewCell : ZJInputTableViewCell

/**
 是否是验证码,默认为NO
 */
@property (nonatomic, getter=isVerifyCode) BOOL verifyCode;

/**
 文本框是否需要左边距，默认为NO, 当有照片时为默认为YES,
 */
@property (nonatomic, getter=isNeedTextFieldLeftMargin) BOOL needTextFieldLeftMargin;

@property (nonatomic, copy) NSString *imgName;

@property (nonatomic, strong) UIColor *verifyBtnBgColor;
@property (nonatomic, strong) UIColor *verifyBtnTitleColor;
@property (nonatomic, strong) UIColor *verifyBtnBorderColor;

/**
 icon左边距，默认为16
 */
@property (nonatomic, assign) CGFloat iconLeftMargin;

@property (nonatomic, weak) id <ZJInputTableViewCelllDelegate, ZJImageTextFieldTableViewCellDelegate>delegate;

// 
@property (nonatomic, assign) BOOL hasBeganCountdown;

- (void)beganCountdown;

@end
