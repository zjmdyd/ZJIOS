//
//  Style1BaseViewController.h
//  Menu
//
//  Created by YunTu on 15/2/10.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef kSidebarWidth
#define kSidebarWidth 270.0 // 侧栏宽度，设屏宽为320，右侧留一条空白可以看到背后页面内容
#endif

@class Style1BaseViewController;

@protocol Style1BaseViewControllerDelegate <NSObject>

- (void)style1BaseViewControllerDidVerticalScroll:(Style1BaseViewController *)controller;

@end

@interface Style1BaseViewController : ZJNormalViewController

@property (nonatomic, strong, readonly) UIView *contentView;   // 所有要显示的子控件全添加到这里

/**
 * @brief 执行显示/隐藏侧边菜单
 */
- (void)showOrHideSideMenu;

@property (nonatomic, strong) UIViewController *rootVC;
@property (nonatomic, assign) BOOL panEnable;
@property (nonatomic, weak) id <Style1BaseViewControllerDelegate> delegate;

@end
