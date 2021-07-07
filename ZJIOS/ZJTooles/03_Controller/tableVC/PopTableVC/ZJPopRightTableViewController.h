//
//  ZJPopRightTableViewController.h
//  KeerZhineng
//
//  Created by ZJ on 2019/1/19.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJNormalTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class ZJPopRightTableViewController;

@protocol ZJPopRightTableViewControllerDelegate <NSObject>

@optional
- (void)popRightTableViewController:(ZJPopRightTableViewController *)controller didSelectAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZJPopRightTableViewController : ZJNormalTableViewController

@property (nonatomic, strong) UIViewController *rootVC;
@property (nonatomic, weak) id<ZJPopRightTableViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
