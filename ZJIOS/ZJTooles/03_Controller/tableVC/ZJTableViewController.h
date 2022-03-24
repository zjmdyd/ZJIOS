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

@property (nonatomic, strong) NSArray *icons, *values, *vcNames, *cellTitles, *sectionTitles;
@property (nonatomic, strong) NSMutableArray *mutableIcons, *mutableValues, *mutableVCNames, *mutableCellTitles, *mutableSectionTitles;

@end

NS_ASSUME_NONNULL_END
