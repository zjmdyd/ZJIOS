//
//  ZJViewController.h
//  ZJIOS
//
//  Created by Zengjian on 2021/6/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJViewController : UIViewController

@property (nonatomic, strong) NSArray *titles, *icons, *values, *vcNames, *cellTitles, *sectionTitles, *keys;
@property (nonatomic, strong) NSMutableArray *mutableTitles, *mutableIcons, *mutableValues, *mutableVCNames, *mutableCellTitles, *mutableSectionTitles, *mutableKeys;

@property (nonatomic, strong) NSTimer *timer;

@end

NS_ASSUME_NONNULL_END
