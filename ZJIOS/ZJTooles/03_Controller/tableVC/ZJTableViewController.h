//
//  ZJTableViewController.h
//  ZJIOS
//
//  Created by Zengjian on 2021/6/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const SystemTableViewCell = @"UITableViewCell";

@interface ZJTableViewController : UITableViewController

/// cellTitles当title是多维可变数组时会用到
@property (nonatomic, strong) NSArray *icons, *titles, *values, *vcNames, *cellTitles, *sectionTitles;
@property (nonatomic, strong) NSMutableArray *mutableIcons, *mutableTitles, *mutableValues, *mutableVCNames, *mutableCellTitles, *mutableSectionTitles;

@end

NS_ASSUME_NONNULL_END
