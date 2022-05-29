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
    self.cellTitles = @[@"ZJTestTableViewController", @"ZJTestColorTableViewController", @"ZJTestNavigationBarItemsTableViewController", @"ZJTestNavigationSettingTableViewController", @"ZJTestStatusBarTableViewController", @"ZJTestSearchBarViewController", @"ZJTouchMathEventViewController", @"ZJTestLabelViewController", @"ZJTestUIAppearanceViewController", @"ZJTestNibViewController", @"ZJTestPageCtrlViewController", @"ZJTestBezierPathViewController"];
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
//    [self test3];
}

/*
 2022-05-23 15:27:05.670318+0800 ZJIOS[7719:236162] topItem0 = <UINavigationItem: 0x7fddfdd1c300> title='UIKit'
 2022-05-23 15:27:05.673277+0800 ZJIOS[7719:236162] topItem1 = <UINavigationItem: 0x7fddfdd1c300> title='self-Title1'
 
 ## 修改self.title, navi的title和tabBar的title都改了
 */
- (void)test0 {
    //    The navigation item at the top of the navigation bar’s stack.
    NSLog(@"topItem0 = %@", self.navigationController.navigationBar.topItem);
    self.title = @"self-Title1";
    NSLog(@"topItem1 = %@", self.navigationController.navigationBar.topItem);
    
    NSLog(@"items = %@", self.navigationController.navigationBar.items);
    NSLog(@"self.navigationItem = %@", self.navigationItem);
}

/*
 2022-05-23 15:31:22.721209+0800 ZJIOS[7873:240385] topItem0 = <UINavigationItem: 0x7fad1522e180> title='UIKit'
 2022-05-23 15:31:22.722008+0800 ZJIOS[7873:240385] topItem1 = <UINavigationItem: 0x7fad1522e180> title='topItem-title'
 
 ## 修改topItem.title, navi的title改了, tabBar的title没变
 */
- (void)test1 {
    NSLog(@"topItem0 = %@", self.navigationController.navigationBar.topItem);
    self.navigationController.navigationBar.topItem.title = @"topItem-title";
    NSLog(@"topItem1 = %@", self.navigationController.navigationBar.topItem);
}

/*
 2022-05-23 15:33:35.804615+0800 ZJIOS[7967:242482] topItem0 = <UINavigationItem: 0x7fb2d9f13670> title='UIKit'
 2022-05-23 15:33:35.806689+0800 ZJIOS[7967:242482] topItem1 = <UINavigationItem: 0x7fb2d9f13670> title='self-Title1'
 2022-05-23 15:33:35.807490+0800 ZJIOS[7967:242482] topItem2 = <UINavigationItem: 0x7fb2d9f13670> title='topItem-title'
 
 ## 先修改self.title再修改topItem.title, navi的title为topItem的title,tabBar的title为self.title
 ## 修改topItem不改tabBar的title
 */
- (void)test2 {
    NSLog(@"topItem0 = %@", self.navigationController.navigationBar.topItem);
    self.title = @"self-Title1";
    NSLog(@"topItem1 = %@", self.navigationController.navigationBar.topItem);
    self.navigationController.navigationBar.topItem.title = @"topItem-title";
    NSLog(@"topItem2 = %@", self.navigationController.navigationBar.topItem);
}

/*
 2022-05-27 16:12:51.366629+0800 ZJIOS[5121:123000] topItem0 = <UINavigationItem: 0x7fc96a112060> title='UIKit'
 2022-05-27 16:12:51.367386+0800 ZJIOS[5121:123000] topItem1 = <UINavigationItem: 0x7fc96a112060> title='topItem-title1'
 2022-05-27 16:12:51.370188+0800 ZJIOS[5121:123000] topItem2 = <UINavigationItem: 0x7fc96a112060> title='self-Title1'
 2022-05-27 16:12:51.370732+0800 ZJIOS[5121:123000] topItem3 = <UINavigationItem: 0x7fc96a112060> title='topItem-title2'
 
 ## 先修改topItem.title再修改self.title, navi和tabBar的title都为self.title,
 ## 所以同时设置了topItem和self.title,navi的title以之后设置的title为准
 */
- (void)test3 {
    NSLog(@"topItem0 = %@", self.navigationController.navigationBar.topItem);
    self.navigationController.navigationBar.topItem.title = @"topItem-title1";
    NSLog(@"topItem1 = %@", self.navigationController.navigationBar.topItem);
    self.title = @"self-Title1";
    NSLog(@"topItem2 = %@", self.navigationController.navigationBar.topItem);
    self.navigationController.navigationBar.topItem.title = @"topItem-title2";
    NSLog(@"topItem3 = %@", self.navigationController.navigationBar.topItem);
    [self performSelector:@selector(changeTabBarTitle) withObject:nil afterDelay:3];
}

/*
 2022-05-27 16:15:34.500527+0800 ZJIOS[5238:125531] self.tabBarItem0 = <UITabBarItem: 0x7fd2ab216880> title='self-Title1' image=<UIImage:0x6000038e0d80 anonymous {22, 22} renderingMode=alwaysOriginal> selected
 2022-05-27 16:15:34.501703+0800 ZJIOS[5238:125531] self.tabBarItem1 = <UITabBarItem: 0x7fd2ab216880> title='tabBarTitle' image=<UIImage:0x6000038e0d80 anonymous {22, 22} renderingMode=alwaysOriginal> selected
 2022-05-27 16:15:34.501882+0800 ZJIOS[5238:125531] self.tabBarItem2 = <UITabBarItem: 0x7fd2ab216880> title='tabBarTitle' image=<UIImage:0x6000038e0d80 anonymous {22, 22} renderingMode=alwaysOriginal> selected
 2022-05-27 16:15:34.503309+0800 ZJIOS[5238:125531] self.tabBarItem3 = <UITabBarItem: 0x7fd2ab216880> title='self-Title2' image=<UIImage:0x6000038e0d80 anonymous {22, 22} renderingMode=alwaysOriginal> selected
 
 ## self.title值更新了就会去更新navi和tabBar的title
 ## 所以同时设置了tabBarItem和self.title, tabBarItem的title以之后设置的title为准
 */
- (void)changeTabBarTitle {
    //    The default value is a tab bar item that displays the view controller's title.
    NSLog(@"self.tabBarItem0 = %@", self.tabBarItem);
    self.tabBarItem.title = @"tabBarTitle"; // self.tabBarItem修改tabBarItem的title,没有设置就与self.title相同
    NSLog(@"self.tabBarItem1 = %@", self.tabBarItem);
    self.title = @"self-Title1";    // 如果设置self.title = @"self-Title1", 与self.title当前值一样,则tabBarItemtitle值不发生改变，此时tabBarItem的title和self.title不一致
    NSLog(@"self.tabBarItem2 = %@", self.tabBarItem);
    self.title = @"self-Title2";    // 如果设置self.title = @"self-Title2", 与self.title当前值不一样,则tabBarItem.title值会发生改变
    NSLog(@"self.tabBarItem3 = %@", self.tabBarItem);
}

/*
 2022-05-23 17:21:18.070613+0800 ZJIOS[10307:326375] -[ZJUIKitTableViewController viewWillAppear:]
 2022-05-23 17:21:18.070823+0800 ZJIOS[10307:326375] topItem0 = <UINavigationItem: 0x7fc721f0bdf0> title='ZJTestNavigationBarItemsTableViewController'
 2022-05-23 17:21:18.071013+0800 ZJIOS[10307:326375] topItem1 = <UINavigationItem: 0x7fc721f0bdf0> title='ZJTestNavigationBarItemsTableViewController'
 */
/*
 2022-05-23 17:21:18.589276+0800 ZJIOS[10307:326375] -[ZJUIKitTableViewController viewDidAppear:]
 2022-05-23 17:21:18.589660+0800 ZJIOS[10307:326375] topItem0 = <UINavigationItem: 0x7fc720721080> title='self-Title1'
 2022-05-23 17:21:18.589971+0800 ZJIOS[10307:326375] topItem1 = <UINavigationItem: 0x7fc720721080> title='self-Title1'
 */

/*
 从子VC返回，viewWillAppear和viewDidAppear方法中获取到的topItem会发生变化,所以要修改title要在viewDidAppear方法中修改
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"%s", __func__);
    
//    [self test0];
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
