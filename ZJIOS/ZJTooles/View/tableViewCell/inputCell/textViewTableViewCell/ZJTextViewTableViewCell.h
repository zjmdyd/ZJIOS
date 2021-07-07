//
//  ZJTextViewTableViewCell.h
//  CanShengHealth
//
//  Created by ZJ on 26/01/2018.
//  Copyright © 2018 HY. All rights reserved.
//

#import "ZJInputTableViewCell.h"

@interface ZJTextViewTableViewCell : ZJInputTableViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property(nonatomic, strong) UIColor *contentBgColor;

@end
