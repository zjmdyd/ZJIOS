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

@interface ZJTestNavigationSettingTableViewController ()

//@property (nonatomic, strong) NSMutableArray *values;

@end

@implementation ZJTestNavigationSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
    [self initSetting];
}

- (void)initAry {
    
}

- (void)initSetting {
    self.cellTitles = @[@[@"navigationBar.backgroundColor", @"navigationBar.barTintColor", @"navigationBar.tintColor", @"navigationBar.translucent"]];
    self.mutableValues = @[@0, @0, @0, @1].mutableCopy;
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
    swh.tag = indexPath.row;
    
    NSNumber *val = self.mutableValues[indexPath.row];
    swh.on = val.boolValue;
    
    return cell;
}

- (void)switchEvent:(UISwitch *)sender {
    self.mutableValues[sender.tag] = @(sender.isOn);
    NSString *selString = [NSString stringWithFormat:@"test%zd:", sender.tag];
    SEL sel = NSSelectorFromString(selString);
    [self performSelector:sel withObject:@(sender.isOn)];
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
    
    NSString *selString = [NSString stringWithFormat:@"test%zd", indexPath.section + indexPath.row];
    SEL sel = NSSelectorFromString(selString);
    
    if ([self respondsToSelector:sel]) {
        NSLog(@"有此方法:%@", selString);
        [self performSelector:sel];
    }else {
        NSLog(@"无此方法:%@", selString);
    }
}

- (void)test0:(NSNumber *)set {
    NSLog(@"backgroundColor = %@", self.navigationController.navigationBar.backgroundColor);    // 默认为backgroundColor = (null)
    if (set.boolValue) {
        self.navigationController.navigationBar.backgroundColor = MainColor;
    }else {
        self.navigationController.navigationBar.backgroundColor = nil;
    }
}

- (void)test1:(NSNumber *)set {
    NSLog(@"barTintColor = %@", self.navigationController.navigationBar.barTintColor);  // 默认barTintColor = (null)
    NSLog(@"translucent = %d", self.navigationController.navigationBar.translucent);

    if (set.boolValue) {
//        This color is made translucent by default unless you set the translucent property to NO
        self.navigationController.navigationBar.barTintColor = [UIColor greenColor];
    }else {
        self.navigationController.navigationBar.barTintColor = nil;
    }
}

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

- (void)test4 {
//    [((ZJNavigationController *)self.navigationController) setNavigationBarBgImgColor:<#(UIColor *)#> forBarMetrics:<#(UIBarMetrics)#>]
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
