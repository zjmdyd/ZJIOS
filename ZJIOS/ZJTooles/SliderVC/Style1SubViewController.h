//
//  Style1SubViewController.h
//  Menu
//
//  Created by YunTu on 15/2/10.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "Style1BaseViewController.h"

@protocol Style1SubViewControllerDelegate <Style1BaseViewControllerDelegate>

@optional
- (void)style1SubViewControllerEventWithIndex:(NSIndexPath *)indexPath;

@end

@interface Style1SubViewController : Style1BaseViewController

@property (nonatomic, weak) id <Style1SubViewControllerDelegate>delegate;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *placeholdPath;
@property (nonatomic, copy) NSString *iconPath;

@end
