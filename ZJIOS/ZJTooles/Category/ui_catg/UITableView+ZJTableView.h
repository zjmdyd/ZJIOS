//
//  UITableView+ZJTableView.h
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const SystemTableViewCell = @"UITableViewCell";
static NSString *const SystemNormalTableViewCell = @"ZJNormalTableViewCell";

@interface UITableView (ZJTableView)

+ (UISwitch *)accessorySwitchWithTarget:(id)target;
+ (UIButton *)accessoryButtonWithTarget:(id)target title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
