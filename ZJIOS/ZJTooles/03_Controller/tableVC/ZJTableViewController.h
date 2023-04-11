//
//  ZJTableViewController.h
//  ZJIOS
//
//  Created by Zengjian on 2021/6/13.
//

#import <UIKit/UIKit.h>
#import "ZJBaseTableViewCell.h"
#import "UIViewController+ZJViewController.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const SystemTableViewCell = @"UITableViewCell";
static NSString *const SystemNormalTableViewCell = @"ZJBaseTableViewCell";

@interface ZJTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *icons, *values, *vcNames, *cellTitles, *sectionTitles;
@property (nonatomic, strong) NSMutableArray *mutableIcons, *mutableValues, *mutableVCNames, *mutableCellTitles, *mutableSectionTitles;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL hasMultiSections;

@end

NS_ASSUME_NONNULL_END
