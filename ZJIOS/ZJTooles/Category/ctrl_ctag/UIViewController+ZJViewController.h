//
//  UIViewController+ZJViewController.h
//  ZJIOS
//
//  Created by issuser on 2021/7/6.
//

#import <UIKit/UIKit.h>
#import "ZJAlertObject.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^AlertActionCompl)(UIAlertAction *act, NSArray *textFields);

@interface UIViewController (ZJViewController)

- (UIViewController *)preControllerWithIndex:(NSUInteger)index;
- (void)popToVCWithIndex:(NSUInteger)index;
- (void)popToVCWithName:(NSString *)name;
- (void)showVCWithName:(NSString *)vcName;
- (void)showVCWithName:(NSString *)vcName hidesBottom:(BOOL)hidden;

#pragma mark - UIBarButtonItem

- (UIBarButtonItem *)barbuttonWithSystemType:(UIBarButtonSystemItem)type;
- (UIBarButtonItem *)barbuttonWithTitle:(NSString *)title;
- (UIBarButtonItem *)barButtonWithImageName:(NSString *)imgName;

/**
 *  创建多个UIBarButtonItem(系统默认)此方法不能调整item之间的间距,需调整建议使用barbuttonWithCustomViewWithImageNames:
 */
- (NSArray<UIBarButtonItem *> *)barButtonWithImageNames:(NSArray *)imgNames;

/**
 *  自定义UIBarButtonItem
 *
 *  @param images 数组最多支持2张图片
 */
- (UIBarButtonItem *)barButtonItemWithCustomViewWithImageNames:(NSArray *)images;

#pragma mark - alert

- (void)alertFunc:(ZJAlertObject *)object alertCompl:(AlertActionCompl)callBack;


#pragma mark - 系统分享

- (void)systemShareWithIcon:(NSString *)icon text:(NSString *)text path:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
