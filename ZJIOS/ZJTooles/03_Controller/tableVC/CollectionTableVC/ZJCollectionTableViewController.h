//
//  ZJCollectionTableViewController.h
//  KeerZhineng
//
//  Created by ZJ on 2019/3/7.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJNormalTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZJCollectionTableViewController : ZJNormalTableViewController

@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, assign) NSInteger numberOfItemAtRow;

@end

NS_ASSUME_NONNULL_END
