//
//  ZJFoundationTableViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/13.
//

#import "ZJFoundationTableViewController.h"
#import "ZJCopyStongViewController.h"
#import "UINavigationController+ZJNaviController.h"
#import "UIViewController+ZJViewController.h"

@interface ZJFoundationTableViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ZJFoundationTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s", __func__);
    [self initAry];
    [self initSetting];
    [UIScreen mainScreen].brightness = .1;
}

- (void)initAry {
    self.titles = @[@"ZJCopyStongViewController", @"ZJCopyMutableCopyViewController", @"ZJAssignnWeakViewController", @"ZJDictionaryNullViewController", @"ZJMutableAryViewController", @"ZJWebViewController", @"ZJNSDataViewController", @"ZJAryViewController", @"ZJNScannerViewController", @"ZJTimerViewController"];
}

- (void)initSetting {
    self.navigationItem.rightBarButtonItem = [self barbuttonWithSystemType:UIBarButtonSystemItemDone];
//    [self barbuttonWithTitle:@"呵呵"];
}
//
//- (void)barItemAction:(UIBarButtonItem *)sender {
//    NSLog(@"%s", __func__);
//}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SystemTableViewCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SystemTableViewCell];
    }
    cell.textLabel.text = self.titles[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *vcName = self.titles[indexPath.row];
    [self showVCWithName:vcName hidesBottom:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s", __func__);
}
/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

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
