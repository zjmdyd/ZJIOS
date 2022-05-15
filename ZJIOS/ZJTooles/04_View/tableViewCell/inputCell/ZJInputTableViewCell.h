//
//  ZJInputTableViewCell.h
//  WeiMing
//
//  Created by ZJ on 16/04/2018.
//  Copyright © 2018 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJInputTableViewCell;

@protocol ZJInputTableViewCelllDelegate  <NSObject>

@optional
- (void)inputTableViewCell:(ZJInputTableViewCell *)cell didBeganEditWithText:(NSString *)text;
- (void)inputTableViewCell:(ZJInputTableViewCell *)cell didEndEditWithText:(NSString *)text;

@end

@interface ZJInputTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *placehold;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *placeholdColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, assign) BOOL editEnable;
@property (nonatomic, weak) id<ZJInputTableViewCelllDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

/**
 是否是隐私输入,默认为NO
 */
@property (nonatomic, assign) BOOL secretInput;

@end
