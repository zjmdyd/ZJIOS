//
//  ZJTopEdgeTitleView.h
//  ZJCustomTools
//
//  Created by ZJ on 6/15/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  取消和确定view 类似toolBar
 */
@interface ZJTopEdgeTitleView : UIView

/**
 *  边角文字
 */
@property (nonatomic, copy) NSString *leftTitle;
@property (nonatomic, copy) NSString *rightTitle;
@property (nonatomic, copy) NSString *mentionTitle;
@property (nonatomic, copy) NSAttributedString *mentionAttrTitle;

/**
 *  弹窗左边button的titleColor
 */
@property (nonatomic, strong) UIColor *leftButtonTitleColor;

/**
 *  弹窗右边button的titleColor
 */
@property (nonatomic, strong) UIColor *rightButtonTitleColor;

/**
 *  弹窗右边button的image
 */
@property (nonatomic, strong) NSString *rightButtonImgName;

/**
 *  弹窗顶部中间提示框文字颜色
 */
@property (nonatomic, strong) UIColor *mentionTitleColor;

@property (nonatomic, strong) id target;

- (instancetype)initWithFrame:(CGRect)frame target:(id)target;

@end
