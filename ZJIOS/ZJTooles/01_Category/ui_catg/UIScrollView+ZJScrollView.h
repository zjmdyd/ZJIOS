//
//  UIScrollView+ZJScrollView.h
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (ZJScrollView)

- (void)registerCellWithSysIDs:(NSArray *)sysIDs;
- (void)registerCellWithNibIDs:(NSArray *)nibIDs;
- (void)registerCellWithNibIDs:(NSArray *)nibIDs sysIDs:(NSArray *)sysIDs;

@end

NS_ASSUME_NONNULL_END
