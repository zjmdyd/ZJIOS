//
//  UIViewController+ZJViewController.h
//  ZJIOS
//
//  Created by issuser on 2021/7/6.
//

#import <UIKit/UIKit.h>
#import "ZJAlertObject.h"
#import "ZJAlertAction.h"
#import "ZJCtrlConfig.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^AlertActionCompl)(ZJAlertAction *act, NSArray *textFields);

@interface UIViewController (ZJViewController)

// index:0代表自己,1代表superVC
- (UIViewController *)preControllerWithIndex:(NSUInteger)index;

- (void)popToVCWithIndex:(NSUInteger)index;
- (void)popToVCWithName:(NSString *)name;
- (void)popToVCWithName:(NSString *)name isNib:(BOOL)isNib;
- (void)showVCWithNibName:(NSString *)name;
- (void)showVCWithNibName:(NSString *)name title:(NSString *)title;

- (void)showDetailVCWithNibName:(NSString *)name;
- (void)showDetailVCWithNibName:(NSString *)name title:(NSString *)title;

- (void)presentVCWithNibName:(NSString *)name;
- (void)presentVCWithNibName:(NSString *)name title:(NSString *)title;

#pragma mark - 

+ (UIViewController *)createVCWithNibName:(NSString *)name;
+ (UIViewController *)createVCWithNibName:(NSString *)name title:(NSString *)title;

- (void)showVCWithConfig:(ZJCtrlConfig *)ctrlConfig;

- (void)showVCWithName:(NSString *)name;
- (void)showVCWithName:(NSString *)name title:(NSString *)title;
- (void)showVCWithName:(NSString *)name title:(NSString *)title style:(UITableViewStyle)style hidesBottom:(BOOL)hidden;

#pragma mark - 根据控制器名字创建控制器

+ (UIViewController *)createVCWithName:(NSString *)name;
+ (UIViewController *)createVCWithName:(NSString *)name title:(NSString *)title;
+ (UIViewController *)createVCWithName:(NSString *)name title:(NSString *)title style:(UITableViewStyle)style;
+ (UIViewController *)createVCWithName:(NSString *)name title:(NSString *)title style:(UITableViewStyle)style hidesBottom:(BOOL)hidden;

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

- (void)systemShareWithIcon:(NSString *)icon text:(NSString *)text url:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
