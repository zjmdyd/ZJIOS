//
//  ZJCollectionPopTableViewController.h
//  KeerZhineng
//
//  Created by ZJ on 2019/3/9.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJPopBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZJCollectionPopTableViewController : ZJPopBaseTableViewController

@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, assign) NSInteger numberOfItemAtRow;

@end

NS_ASSUME_NONNULL_END
