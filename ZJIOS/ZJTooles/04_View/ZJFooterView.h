//
//  ZJFooterView.h
//  HeartGuardForDoctor
//
//  Created by hanyou on 15/11/2.
//  Copyright © 2015年 HANYOU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJFooterView;

@protocol ZJFooterViewDelegate <NSObject>

- (void)footerViewDidClick:(ZJFooterView *)footView;

@end

@interface ZJFooterView : UIView

@property (nonatomic, weak) id <ZJFooterViewDelegate> delegate;

/**
 *  适用于作为tableView的footerView
 */
+ (instancetype)footerViewWithTitle:(NSString *)title delegate:(id<ZJFooterViewDelegate>)delegate;
+ (instancetype)footerViewWithTitle:(NSString *)title frame:(CGRect)frame delegate:(id<ZJFooterViewDelegate>)delegate;

/**
 *  适用于作为vc.view的footerView
 */
+ (instancetype)footerViewWithTitle:(NSString *)title frame:(CGRect)frame superView:(UIView *)superView delegate:(id<ZJFooterViewDelegate>)delegate;

@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *buttonBgColor;
@property (nonatomic, strong) UIColor *boardColor;

/**
 默认为YES
 */
@property (nonatomic, assign) BOOL needCornerRadius;
@property (nonatomic, assign) BOOL enableEvent;

@end
