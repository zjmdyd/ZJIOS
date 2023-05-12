//
//  ZJBaseTableViewController.h
//  ZJIOS
//
//  Created by Zengjian on 2023/5/12.
//

#import "ZJTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZJBaseTableViewType) {
    ZJBaseTableViewTypeShow,
    ZJBaseTableViewTypeExecute,
};

@interface ZJBaseTableViewController : ZJTableViewController

@property (nonatomic, assign) NSInteger vcType;

@end

NS_ASSUME_NONNULL_END
