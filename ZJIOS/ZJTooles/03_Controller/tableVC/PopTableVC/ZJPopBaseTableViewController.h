//
//  ZJPopBaseTableViewController.h
//  KeerZhineng
//
//  Created by ZJ on 2019/1/19.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJNormalTableViewController.h"
#import "ZJPopRightTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZJPopBaseTableViewController : ZJNormalTableViewController<ZJPopRightTableViewControllerDelegate>

@property (nonatomic, strong) NSArray *rightUpTitles;
@property (nonatomic, strong) NSArray *rightUpVCNames;

@end

NS_ASSUME_NONNULL_END
