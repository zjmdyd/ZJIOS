//
//  ZJTestNavigationSettingTableViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/5/23.
//

#import "ZJTestNavigationSettingTableViewController.h"
#import "ZJScrollViewDefines.h"
#import "UITableView+ZJTableView.h"
#import "AppConfigHeader.h"
#import "ZJNavigationController.h"
#import "UIView+ZJView.h"
#import "NSMutableArray+ZJMutableArray.h"
#import "UIViewController+ZJViewController.h"

@interface ZJTestNavigationSettingTableViewController ()

@property (nonatomic, strong) NSArray *types;

@end

@implementation ZJTestNavigationSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
    [self initSetting];
}

- (void)initAry {
    self.cellTitles = @[@[@"navigationBar.backgroundColor", @"navigationBar.barTintColor", @"navigationBar.tintColor", @"navigationBar.translucent", @"navigationBar.shadowImage"],
                        @[@"scrollEdgeAppearance", @"standardAppxearance"],
                        @[@"backItem.backButtonTitle/title", @"topItem.title", @"navigationItem.prompt"],
                        @[@"prefersLargeTitles", @"LargeTitleDisplayModeAutomatic", @"LargeTitleDisplayModeAlways", @"LargeTitleDisplayModeNever"],
                        @[@"UIBarMetricsDefault", @"UIBarMetricsCompact", @"UIBarMetricsDefaultPrompt", @"UIBarMetricsCompactPrompt"],
                        @[@"UIRectEdgeNone", @"UIRectEdgeAll", @"UIRectEdgeTop", @"UIRectEdgeLeft", @"UIRectEdgeBottom", @"UIRectEdgeRight"]
    ];
    
    self.values = @[
        @[@0, @0, @0, @1, @0].mutableCopy,
        @[@0, @0].mutableCopy,
        @[@0, @0, @0].mutableCopy,
        @[@0, @1, @0, @0].mutableCopy,
        @[@0, @0, @0, @0].mutableCopy,
        @[@0, @1, @0, @0, @0, @0].mutableCopy
    ];
    self.types = @[@(UIBarMetricsDefault), @(UIBarMetricsCompact), @(UIBarMetricsDefaultPrompt), @(UIBarMetricsCompactPrompt)];
}

- (void)initSetting {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"next" style:UIBarButtonItemStylePlain target:self action:@selector(next)];
}

- (void)next {
    ((ZJNavigationController *)self.navigationController).hiddenBackBarButtonItemTitle = YES;
    [self showVCWithName:@"ZJViewController" title:@"hhh"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *ary = self.cellTitles[section];
    return ary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZJBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SystemTableViewCell];
    if (!cell) {
        cell = [[ZJBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SystemTableViewCell];
    }
    NSArray *ary = self.cellTitles[indexPath.section];
    cell.textLabel.text = ary[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UISwitch *swh = [UITableView accessorySwitchWithTarget:self];
    cell.accessoryView = swh;
    
    swh.tag = [self getTag:indexPath];
    
    NSNumber *val = self.values[indexPath.section][indexPath.row];
    swh.on = val.boolValue;
    
    return cell;
}

- (NSInteger)getTag:(NSIndexPath *)indexPath {
    NSInteger sec = indexPath.section;
    
    NSInteger beforeTotalCount = 0;
    for (int i = 0; i < sec; i++) {
        NSArray *ary = self.cellTitles[i];
        beforeTotalCount += ary.count;
    }
    
    return beforeTotalCount + indexPath.row;
}
// sec=0    sec=1   sec=2
//  0~3      4~5     6~9
// 3 < 4 ==> 0
// 4,5 < 6 ==> 1
- (NSIndexPath *)getIndexPathWithTag:(NSInteger)tag {
    NSInteger sec = 0;
    NSInteger row = 0;
    
    NSInteger beforeSecCount = 0;
    NSInteger beforeTotalCount = 0;
    for (int i = 0; i < self.cellTitles.count; i++) {
        NSArray *ary = self.cellTitles[i];
        beforeTotalCount += ary.count;
        
        if (tag < beforeTotalCount) {   // ?????????section
            sec = i;
            row = (tag - beforeSecCount) % ary.count;
            break;
        }else {
            beforeSecCount += ary.count;
        }
    }
    
    return [NSIndexPath indexPathForRow:row inSection:sec];
}

- (void)switchEvent:(UISwitch *)sender {
    NSIndexPath *indexPath = [self getIndexPathWithTag:sender.tag];
    NSMutableArray *ary = self.values[indexPath.section];
    NSLog(@"??????ary[%zd][%zd], sender.tag = %zd", indexPath.section, indexPath.row, sender.tag);
    ary[indexPath.row] = @(sender.isOn);
    if (indexPath.section == self.cellTitles.count - 1) {
        [self test13:indexPath.row set:sender.isOn];
    }else if (indexPath.section == self.cellTitles.count - 2) {
        [self test12:indexPath.row set:sender.isOn];
    }else {
        if (indexPath.section == 3) {
            if (indexPath.row == 0) {
                if (sender.isOn == NO) {
                    [ary resetBoolValuesFromIndex:1];
                }else {
                    if (![ary hasBoolTrueFromIndex:1]) {
                        ary[1] = @1;
                    }
                }
                [self.tableView reloadData];
                [self test10:@(sender.isOn)];
            }else {
                [ary resetBoolValuesFromIndex:1 excludeIndex:indexPath.row];
                
                if (sender.isOn == NO) {
                    if (![ary hasBoolTrueFromIndex:1]) {
                        ary[1] = @1;
                        [self test11:@0];
                    }
                }else {
                    [self test11:@(indexPath.row - 1)];
                }
                [self.tableView reloadData];
            }
        }else {
            NSString *selString = [NSString stringWithFormat:@"test%zd:", sender.tag];
            SEL sel = NSSelectorFromString(selString);
            if ([self respondsToSelector:sel]) {
                NSLog(@"????????????:%@", selString);
                [self performSelector:sel withObject:@(sender.isOn)];
            }else {
                NSLog(@"????????????:%@", selString);
            }
        }
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DefaultCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return DefaultSectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return DefaultSectionHeaderHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

/*
 ???????????????backgroundColor
 iOS13:?????????
 */
- (void)test0:(NSNumber *)set {
    NSLog(@"backgroundColor = %@", self.navigationController.navigationBar.backgroundColor);    // ?????????backgroundColor = (null)
    if (set.boolValue) {
        self.navigationController.navigationBar.backgroundColor = MainColor;
    }else {
        self.navigationController.navigationBar.backgroundColor = nil;
    }
}

/*
 ??????barTintColor(?????????)
 iOS13:OK
 iOS15:OK,????????????????????????,standardAppxearance?????????barTintColor????????????????????????
 */
- (void)test1:(NSNumber *)set {
    NSLog(@"barTintColor = %@", self.navigationController.navigationBar.barTintColor);  // ??????barTintColor = (null)
    NSLog(@"translucent = %d", self.navigationController.navigationBar.translucent);
    
    [self getBarAppearance];
    
    if (set.boolValue) {
        //        This color is made translucent by default unless you set the translucent property to NO
        self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    }else {
        self.navigationController.navigationBar.barTintColor = nil;
    }
    
    [self getBarAppearance];
}

- (void)getBarSubViews {
    UINavigationBar *naviBar = self.navigationController.navigationBar;
    UIView *backgroundView = [naviBar fetchSubViewWithClassName:@"_UIBarBackground"];
    NSArray *bgSubViews =  backgroundView.subviews;
    for (UIView *sView in bgSubViews) {
        NSLog(@"bgSubView = %@", sView);
        if ([sView isKindOfClass:NSClassFromString(@"UIVisualEffectView")]) {
            NSArray *ssubViews = sView.subviews;
            NSLog(@"ssubViews = %@", ssubViews);
            for (UIView *sssView in ssubViews) {
                NSLog(@"sssView = %@, hidden = %d", sssView, sssView.hidden);
            }
            
            break;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //    NSLog(@"%s, contentOffset = %@", __func__, NSStringFromCGPoint(scrollView.contentOffset));
    
    //    [self getBarAppearance];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    NSLog(@"%s, contentOffset = %@", __func__, NSStringFromCGPoint(scrollView.contentOffset));
}

- (void)getBarAppearance {
    UINavigationBar *naviBar = self.navigationController.navigationBar;
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *stdAppear = naviBar.standardAppearance;
        UINavigationBarAppearance *sclAppear = naviBar.scrollEdgeAppearance;
        NSLog(@"stdAppear = %@, backgroundColor = %@, backgroundImage = %@", stdAppear, stdAppear.backgroundColor, stdAppear.backgroundImage);
        NSLog(@"sclAppear = %@, backgroundColor = %@, backgroundImage = %@", sclAppear, sclAppear.backgroundColor, sclAppear.backgroundImage);
    } else {
        // Fallback on earlier versions
    }
}

/*
 ??????tintColor
 iOS13:OK
 iOS15:OK
 */
- (void)test2:(NSNumber *)set {
    NSLog(@"tintColor = %@", self.navigationController.navigationBar.tintColor);        // ??????systemBlueColor
    ((ZJNavigationController *)self.navigationController).navigationBarTintColor = set.boolValue ? [UIColor redColor] : nil;
}

- (void)test3:(NSNumber *)set {
    NSLog(@"barStyle = %zd", self.navigationController.navigationBar.barStyle);
    NSLog(@"translucent = %d", self.navigationController.navigationBar.translucent);
    ((ZJNavigationController *)self.navigationController).navigationBarTranslucent = set.boolValue;
}

/*
 iOS15??????????????????????????????,iOS13??????????????????
 */
- (void)test4:(NSNumber *)set {
    NSLog(@"shadowImage = %@", self.navigationController.navigationBar.shadowImage);
    ((ZJNavigationController *)self.navigationController).navigationBarShadowColor = set.boolValue ? [UIColor greenColor] : nil;
}

/*
 ## scrollEdgeAppearance
 iOS 14 or earlier, this property applies to navigation bars with large titles.
 In iOS 15, this property applies to all navigation bars.???????????????????????????prefersLargeTitles?????????
 */
- (void)test5:(NSNumber *)set {
    if (@available(iOS 13.0, *)) {
        [self getBarAppearance];
        if (set.boolValue) {
            UINavigationBarAppearance *greenAppearance = [[UINavigationBarAppearance alloc] init];
            greenAppearance.backgroundColor = [UIColor cyanColor];
            self.navigationController.navigationBar.scrollEdgeAppearance = greenAppearance;
        }else {
            self.navigationController.navigationBar.scrollEdgeAppearance = nil;
        }
        // ???iOS13?????????????????????????????????naviBar?????????setNeedsLayout()?????????
        if (@available(iOS 15.0, *)) {
            
        } else {
            [self.navigationController.navigationBar setNeedsLayout];
        }
        // iOS13????????????????????????????????????????????????barTintColor????????????tintColor???backgroundColor??????????????????
        [self getBarAppearance];
    } else {
        // Fallback on earlier versions
    }
}

/*
 standardAppearance
 iOS13:
 ???prefersLargeTitles=NO???????????????
 ???prefersLargeTitles=YES????????????????????????????????????????????????????????????scrollEdgeAppearance
 iOS15:
 ??????????????????????????????prefersLargeTitles?????????????????????????????????????????????scrollEdgeAppearance
 */
- (void)test6:(NSNumber *)set {
    if (@available(iOS 13.0, *)) {
        [self getBarAppearance];
        UINavigationBarAppearance *greenAppearance = [[UINavigationBarAppearance alloc] init];
        if (set.boolValue) {
            greenAppearance.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.5];
        }else {
            greenAppearance.backgroundColor = nil;  // standardAppearance??????
        }
        // ???iOS13?????????????????????????????????naviBar?????????setNeedsLayout()?????????
        // iOS13/15????????????????????????????????????????????????barTintColor?????????,tintColor???backgroundColor??????????????????
        self.navigationController.navigationBar.standardAppearance = greenAppearance;
        if (@available(iOS 15.0, *)) {
            
        } else {
            [self.navigationController.navigationBar setNeedsLayout];
        }
        [self getBarAppearance];
    } else {
        // Fallback on earlier versions
    }
}

/*
 topItem.title????????????????????????
 backItem.backButtonTitle/backItem.title??????????????????????????????????????????
 
 if (@available(iOS 11.0, *)) {
     //        ??????backButtonTitle?????????????????????????????????VC??????title??????,?????????test3()??????backItem???super.navigationItem????????????item
     self.navigationController.navigationBar.backItem.backButtonTitle = set.boolValue ? @"backTitle" : @"";
 } else {
     // ????????????VC???title??????,?????????backItem???title????????????super.navigationItem???title
     self.navigationController.navigationBar.backItem.title = set.boolValue ? @"backItemTitle" : @"";
 }
  */
- (void)test7:(NSNumber *)set {
    ((ZJNavigationController *)self.navigationController).navigationBarBackButtonTitle = set.boolValue ? @"backTitle" : @"";
}

- (void)test8:(NSNumber *)set {
    self.navigationController.navigationBar.topItem.title = set.boolValue ? @"cus_topItem.title" : @"default_topItem.title";
    NSLog(@"backItem = %@", self.navigationController.navigationBar.backItem);
}

/*
 ???????????????????????????viewWillAppear???????????????????????????????????????????????????????????????????????????????????????
 */
- (void)test9:(NSNumber *)set {
    if (@available(iOS 13.0, *)) {
        if (set.boolValue) {
            self.navigationItem.prompt = @"cus_prompt";
        }else {
            self.navigationItem.prompt = nil;
        }
    } else {
        // Fallback on earlier versions
    }
}

- (void)test10:(NSNumber *)set {
    if (@available(iOS 11.0, *)) {
        // ?????????????????????????????????????????????????????????????????????viewWillAppear??????????????????????????????
        self.navigationController.navigationBar.prefersLargeTitles = set.boolValue;
    } else {
        // Fallback on earlier versions
    }
}

- (void)test11:(NSNumber *)set {
    if (@available(iOS 11.0, *)) {
        // UINavigationItemLargeTitleDisplayModeAlways?????????,??????Automatic?????????
        // UINavigationItemLargeTitleDisplayModeNever?????????
        NSArray *types = @[@(UINavigationItemLargeTitleDisplayModeAutomatic), @(UINavigationItemLargeTitleDisplayModeAlways), @(UINavigationItemLargeTitleDisplayModeNever)];
        self.navigationItem.largeTitleDisplayMode = [types[set.integerValue] integerValue];
    } else {
        // Fallback on earlier versions
    }
}

/*
 ## setBackgroundImage:forBarMetrics:
 
 UIBarMetricsDefault        // ?????????  iOS13:?????????    iOS15:?????????,??????????????????????????????
 UIBarMetricsCompact        // ??????    iOS13:????????????  iOS15:?????????,??????????????????????????????
 UIBarMetricsDefaultPrompt  // ?????????????????? iOS13/15?????????
 UIBarMetricsCompactPrompt  // ?????????????????? iOS13/15?????????
 */
- (void)test12:(NSInteger)index set:(BOOL)set {
    NSInteger type = [self.types[index] integerValue];
    NSArray *colors = @[[UIColor colorWithRed:1 green:0 blue:0 alpha:0.5], [UIColor orangeColor], [UIColor yellowColor], [UIColor purpleColor]];
    if (set) {
        [((ZJNavigationController *)self.navigationController) setNavigationBarBgImgWithColor:colors[index] forBarMetrics:type];
    }else {
        [((ZJNavigationController *)self.navigationController) setNavigationBarBgImg:nil forBarMetrics:type];
    }
}

/*
 UIRectEdgeNone   = 0,
 UIRectEdgeTop    = 1 << 0,
 UIRectEdgeLeft   = 1 << 1,
 UIRectEdgeBottom = 1 << 2,
 UIRectEdgeRight  = 1 << 3,
 UIRectEdgeAll    = UIRectEdgeTop | UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight
 
 */
- (void)test13:(NSInteger)index set:(BOOL)set {
    NSArray *types = @[@(UIRectEdgeNone), @(UIRectEdgeAll), @(UIRectEdgeTop), @(UIRectEdgeLeft), @(UIRectEdgeBottom), @(UIRectEdgeRight)];
    NSInteger type = [types[index] integerValue];
    
    if (set) {
        self.edgesForExtendedLayout = type;
    }else {
        self.edgesForExtendedLayout = UIRectEdgeAll;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"%s", __func__);
    
//    self.navigationItem.prompt = @"prompt"; // ????????????viewDidAppear?????????????????????
    [self getItems];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"%s", __func__);
    
    [self getItems];
    
    //    [self getBarAppearance];
}

- (void)getItems {
    NSArray *items = self.navigationController.navigationBar.items;
    UINavigationItem *topItem = self.navigationController.navigationBar.topItem;
    //    The navigation item that is immediately below the topmost item on a navigation bar???s stack
    UINavigationItem *backItem = self.navigationController.navigationBar.backItem;
    
    NSLog(@"items = %@", items);
    NSLog(@"topItem = %@", topItem);
    NSLog(@"backItem = %@", backItem);
    //    navigationItem: The default behavior is to create a navigation item that displays the view controller's title
    NSLog(@"self.navigationItem = %@, titleView = %@", self.navigationItem, self.navigationItem.titleView);
    NSLog(@"self.navigationController.navigationItem = %@, titleView = %@", self.navigationController.navigationItem, self.navigationController.navigationItem.titleView);
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
