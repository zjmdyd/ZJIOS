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
    self.cellTitles = @[@[@"navigationBar.backgroundColor", @"navigationBar.barTintColor", @"navigationBar.tintColor", @"navigationBar.translucent"],
                        @[@"UIBarMetricsDefault", @"UIBarMetricsCompact", @"UIBarMetricsDefaultPrompt", @"UIBarMetricsCompactPrompt"],
    ];
    self.values = @[@[@0, @0, @0, @1].mutableCopy, @[@0, @0, @0, @0].mutableCopy].mutableCopy;
    self.types = @[@(UIBarMetricsDefault), @(UIBarMetricsCompact), @(UIBarMetricsDefaultPrompt), @(UIBarMetricsCompactPrompt)];
}

- (void)initSetting {
//    if(@available(iOS 15.0,*)){
//        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
//        [appearance setBackgroundImage:[UIImage imageNamed:@"NavBar64"]];
//        appearance.backgroundColor = [UIColor greenColor];
//
//        UINavigationBarAppearance *stdAppearance = [[UINavigationBarAppearance alloc] init];
//        stdAppearance.backgroundColor = [UIColor redColor];
//        //            [appearance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:24 weight:UIFontWeightBold]}];
//        self.navigationController.navigationBar.standardAppearance = stdAppearance; // contentOoffset不等于0时的显示状态
//        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;  // contentOoffset=0时的显示状态
//    }else{
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
////        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:24 weight:UIFontWeightBold]}];
//
//        [self.navigationController.navigationBar setTintColor:UIColor.whiteColor];
//    }
    
    UINavigationBarAppearance *greentAppearance = [[UINavigationBarAppearance alloc] init];
    greentAppearance.backgroundColor = [UIColor greenColor];
    
    UINavigationBarAppearance *redAppearance = [[UINavigationBarAppearance alloc] init];
    redAppearance.backgroundColor = [UIColor redColor];
    self.navigationController.navigationBar.standardAppearance = redAppearance;         // iOS15:contentOoffset不等于0时的显示状态
    self.navigationController.navigationBar.scrollEdgeAppearance = greentAppearance;    // ios15:contentOoffset=0时的显示状态
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
    
    swh.tag = indexPath.row + indexPath.section*4;
    
    NSNumber *val = self.values[indexPath.section][indexPath.row];
    swh.on = val.boolValue;
    
    return cell;
}

- (void)switchEvent:(UISwitch *)sender {
    NSMutableArray *ary = self.values[sender.tag/4];
    NSLog(@"修改ary[%zd][%zd]", sender.tag/4, sender.tag%4);
    ary[sender.tag%4] = @(sender.isOn);
    if (sender.tag / 4 == 0) {
        NSString *selString = [NSString stringWithFormat:@"test%zd:", sender.tag];
        SEL sel = NSSelectorFromString(selString);
        [self performSelector:sel withObject:@(sender.isOn)];
    }else {
        [self test4:sender.tag%4 set:sender.isOn];
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
    
    //    NSString *selString = [NSString stringWithFormat:@"test%zd", indexPath.section + indexPath.row];
    //    SEL sel = NSSelectorFromString(selString);
    //
    //    if ([self respondsToSelector:sel]) {
    //        NSLog(@"有此方法:%@", selString);
    //        [self performSelector:sel];
    //    }else {
    //        NSLog(@"无此方法:%@", selString);
    //    }
}

/*
 设置背景色backgroundColor
 iOS13:有遮挡
 */
- (void)test0:(NSNumber *)set {
    NSLog(@"backgroundColor = %@", self.navigationController.navigationBar.backgroundColor);    // 默认为backgroundColor = (null)
    if (set.boolValue) {
        self.navigationController.navigationBar.backgroundColor = MainColor;
    }else {
        self.navigationController.navigationBar.backgroundColor = nil;
    }
}

/*
 设置barTintColor(背景色)
 iOS13:OK
 iOS15:OK,但是需要向上拖动
 */
- (void)test1:(NSNumber *)set {
    NSLog(@"barTintColor = %@", self.navigationController.navigationBar.barTintColor);  // 默认barTintColor = (null)
    NSLog(@"translucent = %d", self.navigationController.navigationBar.translucent);
    
    if (set.boolValue) {
        //        This color is made translucent by default unless you set the translucent property to NO
        //        self.navigationController.navigationBar.barTintColor = [UIColor greenColor];
    }else {
        //        self.navigationController.navigationBar.barTintColor = nil;
    }

    [self getBarSubViews];
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
 设置tintColor
 iOS13:OK
 iOS15:OK
 */
- (void)test2:(NSNumber *)set {
    NSLog(@"tintColor = %@", self.navigationController.navigationBar.tintColor);        // 默认systemBlueColor
    if (set.boolValue) {
        self.navigationController.navigationBar.tintColor = [UIColor redColor];
    }else {
        self.navigationController.navigationBar.tintColor = nil;
    }
}

- (void)test3:(NSNumber *)set {
    NSLog(@"barStyle = %zd", self.navigationController.navigationBar.barStyle);
    NSLog(@"translucent = %d", self.navigationController.navigationBar.translucent);
    self.navigationController.navigationBar.translucent = set.boolValue;
}

/*
 UIBarMetricsDefault    // 竖屏横屏都有, iOS13:起作用, iOS15:起作用,但是需要向上拖动才有
 UIBarMetricsCompact    // 竖屏没有，横屏有, iOS13:设置不起作用, iOS15:起作用,但是需要向上拖动才有
 UIBarMetricsDefaultPrompt
 UIBarMetricsCompactPrompt
 */
- (void)test4:(NSInteger)index set:(BOOL)set {
    NSInteger type = [self.types[index] integerValue];
    
    NSArray *colors = @[[UIColor brownColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor purpleColor]];
    if (set) {
        [((ZJNavigationController *)self.navigationController) setNavigationBarBgImgWithColor:colors[index] forBarMetrics:type];
    }else {
        [((ZJNavigationController *)self.navigationController) setNavigationBarBgImg:nil forBarMetrics:type];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"%s", __func__);
    [self getItems];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"%s", __func__);
    
    [self getItems];
}

- (void)getItems {
    NSArray *items = self.navigationController.navigationBar.items;
    UINavigationItem *topItem = self.navigationController.navigationBar.topItem;
    //    The navigation item that is immediately below the topmost item on a navigation bar’s stack
    UINavigationItem *backItem = self.navigationController.navigationBar.backItem;
    
    NSLog(@"items = %@", items);
    NSLog(@"topItem = %@", topItem);
    NSLog(@"backItem = %@", backItem);
    //    navigationItem: The default behavior is to create a navigation item that displays the view controller's title
    NSLog(@"self.navigationItem = %@, titleView = %@", self.navigationItem, self.navigationItem.titleView);
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
