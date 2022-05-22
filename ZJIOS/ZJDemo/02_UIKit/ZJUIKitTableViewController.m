//
//  ZJUIKitTableViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/13.
//

#import "ZJUIKitTableViewController.h"
#import "UIViewController+ZJViewController.h"
#import <Vision/Vision.h>

@interface ZJUIKitTableViewController ()

@end

@implementation ZJUIKitTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
    

}

- (void)initAry {
    self.cellTitles = @[@"ZJTestTableViewController", @"ZJTestColorTableViewController", @"ZJTestNavigationBarTableViewController", @"ZJTestStatusBarTableViewController", @"ZJTestSearchBarViewController", @"ZJTouchMathEventViewController", @"ZJTestLabelViewController", @"ZJTestUIAppearanceViewController", @"ZJTestNibViewController", @"ZJTestPageCtrlViewController", @"ZJTestBezierPathViewController"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZJBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SystemTableViewCell];
    if (!cell) {
        cell = [[ZJBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SystemTableViewCell];
    }
    cell.textLabel.text = self.cellTitles[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
//    NSLog(@"label1 = %@, font1 = %@", cell.textLabel, cell.textLabel.font);
//    NSLog(@"label2 = %@, font2 = %@", cell.detailTextLabel, cell.detailTextLabel.font);
    
    return cell;
}

#pragma mark - UITableViewDelegate

/*
 2022-05-15 17:50:10.589440+0800 ZJIOS[8933:266085] font1 = <UICTFont: 0x7fd4eb60ba10> font-family: "UICTFontTextStyleBody"; font-weight: normal; font-style: normal; font-size: 17.00pt
 // default
 2022-05-15 17:50:10.589726+0800 ZJIOS[8933:266085] font2 = <UICTFont: 0x7fd4eb413cb0> font-family: "UICTFontTextStyleCaption1"; font-weight: normal; font-style: normal; font-size: 12.00pt
 // system
 2022-05-15 18:27:46.931491+0800 ZJIOS[9962:301959] label2 = <UITableViewLabel: 0x7fdb6740c900; frame = (0 0; 0 0); text = '哈哈哈'; userInteractionEnabled = NO; layer = <_UILabelLayer: 0x600001dba670>>, font2 = <UICTFont: 0x7fdb6700a870> font-family: ".SFUI-Regular"; font-weight: normal; font-style: normal; font-size: 12.00pt


 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *vcName = self.cellTitles[indexPath.row];
    [self showVCWithName:vcName title:vcName];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"%s", __func__);
    
    self.title = @"self-Title";
    NSLog(@"topItem0 = %@", self.navigationController.navigationBar.topItem);
    self.navigationController.navigationBar.topItem.title = @"UIKit-Title";
    NSLog(@"topItem1 = %@", self.navigationController.navigationBar.topItem);
}

/*
 从子VC返回，viewWillAppear和viewDidAppear方法中获取到的topItem会发生变化,所以要修改title要在viewDidAppear方法中修改
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"%s", __func__);
    
    self.title = @"self-Title";
    NSLog(@"topItem0 = %@", self.navigationController.navigationBar.topItem);
    self.navigationController.navigationBar.topItem.title = @"UIKit-Title";
    NSLog(@"topItem1 = %@", self.navigationController.navigationBar.topItem);
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
