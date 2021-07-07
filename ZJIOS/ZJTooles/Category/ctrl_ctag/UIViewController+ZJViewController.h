//
//  UIViewController+ZJViewController.h
//  ZJIOS
//
//  Created by issuser on 2021/7/6.
//

#import <UIKit/UIKit.h>
#import "ZJAlertObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ZJViewController)

- (UIViewController *)preControllerWithIndex:(NSInteger)index;
- (void)popToVCWithIndex:(NSInteger)index;
- (void)popToVCWithName:(NSString *)name;

#pragma mark - UIBarButtonItem

- (UIBarButtonItem *)barbuttonWithSystemType:(UIBarButtonSystemItem)type;
- (UIBarButtonItem *)barbuttonWithTitle:(NSString *)title;
- (UIBarButtonItem *)barButtonWithImageName:(NSString *)imgName;

/**
 *  创建多个UIBarButtonItem(系统默认)此方法效果不好,建议使用barbuttonWithCustomViewWithImageNames:
 */
- (NSArray *)barButtonWithImageNames:(NSArray *)imgNames;

/**
 *  自定义UIBarButtonItem
 *
 *  @param images 数组最多支持2张图片
 */
- (UIBarButtonItem *)barButtonItemWithCustomViewWithImageNames:(NSArray *)images;

#pragma mark - alert

- (void)alertWithAlertObject:(ZJAlertObject *)object;
- (void)alertSheetWithWithAlertObject:(ZJAlertObject *)object;


#pragma mark - 系统分享

- (void)systemShareWithIcon:(NSString *)icon text:(NSString *)text path:(NSString *)path;

#pragma mark - NSNotificationCenter

- (void)removeNotificationObserver;

@end

NS_ASSUME_NONNULL_END
