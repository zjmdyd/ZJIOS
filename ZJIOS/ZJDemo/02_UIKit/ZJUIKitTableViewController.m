//
//  ZJUIKitTableViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/13.
//

#import "ZJUIKitTableViewController.h"
#import <Vision/Vision.h>

@interface ZJUIKitTableViewController ()

@end

@implementation ZJUIKitTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
}

- (void)initAry {
    self.cellTitles = @[@"ZJTestTableViewController", @"ZJTestColorTableViewController", @"ZJTestNavigationBarItemsTableViewController", @"ZJTestNavigationSettingTableViewController", @"ZJTestStatusBarTableViewController", @"ZJTestSearchBarViewController", @"ZJTouchMathEventViewController", @"ZJTestLabelViewController", @"ZJTestUIAppearanceViewController", @"ZJTestNibViewController", @"ZJTestPageCtrlViewController"];
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
    [self test0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"%s", __func__);
    
    [self test0];
}

/*
 2023-05-19 17:37:30.480662+0800 ZJIOS[12183:5346561] -[ZJUIKitTableViewController viewWillAppear:]
 2023-05-19 17:37:30.480913+0800 ZJIOS[12183:5346561] topItem = <UINavigationItem: 0x7fea9670bb00> title='ZJTestTableViewController' style=navigator
 2023-05-19 17:37:30.481232+0800 ZJIOS[12183:5346561] items = (
     "<UINavigationItem: 0x7fea97f07b70> title='UIKit' style=navigator",
     "<UINavigationItem: 0x7fea9670bb00> title='ZJTestTableViewController' style=navigator"
 )
 2023-05-19 17:37:30.481410+0800 ZJIOS[12183:5346561] self.navigationItem = <UINavigationItem: 0x7fea97f07b70> title='UIKit' style=navigator
 2023-05-19 17:37:30.481627+0800 ZJIOS[12183:5346561] self.tabBarItem = <UITabBarItem: 0x7fea97e16960> title='UIKit' image=<UIImage:0x600001f0cd80 anonymous {22, 22} renderingMode=alwaysOriginal> selected
 2023-05-19 17:37:31.541443+0800 ZJIOS[12183:5346561] -[ZJUIKitTableViewController viewDidAppear:]
 2023-05-19 17:37:31.541658+0800 ZJIOS[12183:5346561] topItem = <UINavigationItem: 0x7fea97f07b70> title='UIKit' style=navigator
 2023-05-19 17:37:31.541807+0800 ZJIOS[12183:5346561] items = (
     "<UINavigationItem: 0x7fea97f07b70> title='UIKit' style=navigator"
 )
 2023-05-19 17:37:31.541928+0800 ZJIOS[12183:5346561] self.navigationItem = <UINavigationItem: 0x7fea97f07b70> title='UIKit' style=navigator
 2023-05-19 17:37:31.542166+0800 ZJIOS[12183:5346561] self.tabBarItem = <UITabBarItem: 0x7fea97e16960> title='UIKit' image=<UIImage:0x600001f0cd80 anonymous {22, 22} renderingMode=alwaysOriginal> selected
 2023-05-19 17:37:31.544836+0800 ZJIOS[12183:5346561] -[ZJTableViewController dealloc], currentVC = ZJTestTableViewController


  从子VC返回，viewWillAppear和viewDidAppear方法中获取到的topItem会发生变化,所以要修改title要在viewDidAppear方法中修改
  */
- (void)test0 {
    NSLog(@"topItem = %@", self.navigationController.navigationBar.topItem);
    NSLog(@"items = %@", self.navigationController.navigationBar.items);
    NSLog(@"self.navigationItem = %@", self.navigationItem);
    NSLog(@"self.tabBarItem = %@", self.tabBarItem);
}

/*
 2023-05-19 16:54:04.243522+0800 ZJIOS[11057:5304424] topItem0 = <UINavigationItem: 0x7fa655e0d1f0> title='UIKit' style=navigator
 2023-05-19 16:54:04.246466+0800 ZJIOS[11057:5304424] topItem1 = <UINavigationItem: 0x7fa655e0d1f0> title='self-Title1' style=navigator
 2023-05-19 16:54:04.246717+0800 ZJIOS[11057:5304424] items = (
     "<UINavigationItem: 0x7fa655e0d1f0> title='self-Title1' style=navigator"
 )
 2023-05-19 16:54:04.246876+0800 ZJIOS[11057:5304424] self.navigationItem = <UINavigationItem: 0x7fa655e0d1f0> title='self-Title1' style=navigator
 2023-05-19 16:54:04.247106+0800 ZJIOS[11057:5304424] self.tabBarItem = <UITabBarItem: 0x7fa657908530> title='self-Title1' image=<UIImage:0x600003174750 anonymous {22, 22} renderingMode=alwaysOriginal> selected

 ## 修改self.title, navi的title和tabBar的title都改了
 ## self.navigationItem和navigationBar.topItem是同一个
 */
- (void)test1 {
    //    The navigation item at the top of the navigation bar’s stack.
    NSLog(@"topItem0 = %@", self.navigationController.navigationBar.topItem);
    self.title = @"self-Title1";
    NSLog(@"topItem1 = %@", self.navigationController.navigationBar.topItem);
    
    NSLog(@"items = %@", self.navigationController.navigationBar.items);
    NSLog(@"self.navigationItem = %@", self.navigationItem);
    NSLog(@"self.tabBarItem = %@", self.tabBarItem);
}

/*
 2023-05-19 16:55:29.179911+0800 ZJIOS[11108:5306340] topItem0 = <UINavigationItem: 0x7f918390e2f0> title='UIKit' style=navigator
 2023-05-19 16:55:29.180707+0800 ZJIOS[11108:5306340] topItem1 = <UINavigationItem: 0x7f918390e2f0> title='topItem-title' style=navigator
 2023-05-19 16:55:29.180950+0800 ZJIOS[11108:5306340] items = (
     "<UINavigationItem: 0x7f918390e2f0> title='topItem-title' style=navigator"
 )
 2023-05-19 16:55:29.181128+0800 ZJIOS[11108:5306340] self.navigationItem = <UINavigationItem: 0x7f918390e2f0> title='topItem-title' style=navigator
 2023-05-19 16:55:29.181366+0800 ZJIOS[11108:5306340] self.tabBarItem = <UITabBarItem: 0x7f917ff09b70> title='UIKit' image=<UIImage:0x600000e705a0 anonymous {22, 22} renderingMode=alwaysOriginal> selected
 
 ## 修改topItem.title, navi的title改了, tabBar的title不受影响
 */
- (void)test2 {
    NSLog(@"topItem0 = %@", self.navigationController.navigationBar.topItem);
    self.navigationController.navigationBar.topItem.title = @"topItem-title";
    NSLog(@"topItem1 = %@", self.navigationController.navigationBar.topItem);
    
    NSLog(@"items = %@", self.navigationController.navigationBar.items);
    NSLog(@"self.navigationItem = %@", self.navigationItem);
    NSLog(@"self.tabBarItem = %@", self.tabBarItem);
}

/*
 2023-05-19 17:13:38.727821+0800 ZJIOS[11582:5324228] topItem0 = <UINavigationItem: 0x7fec3600ce10> title='UIKit' style=navigator
 2023-05-19 17:13:38.731028+0800 ZJIOS[11582:5324228] topItem1 = <UINavigationItem: 0x7fec3600ce10> title='self-Title1' style=navigator
 2023-05-19 17:13:38.731792+0800 ZJIOS[11582:5324228] topItem2 = <UINavigationItem: 0x7fec3600ce10> title='topItem-title' style=navigator
 2023-05-19 17:13:38.732098+0800 ZJIOS[11582:5324228] self.tabBarItem = <UITabBarItem: 0x7fec363065d0> title='self-Title1' image=<UIImage:0x6000013a0120 anonymous {22, 22} renderingMode=alwaysOriginal> selected

 
 ## 先修改self.title再修改topItem.title, navi的title为topItem的title,tabBar的title为self.title
 ## 修改topItem不改tabBar的title
 */
- (void)test3 {
    NSLog(@"topItem0 = %@", self.navigationController.navigationBar.topItem);
    self.title = @"self-Title1";
    NSLog(@"topItem1 = %@", self.navigationController.navigationBar.topItem);
    self.navigationController.navigationBar.topItem.title = @"topItem-title";
    NSLog(@"topItem2 = %@", self.navigationController.navigationBar.topItem);
    NSLog(@"self.tabBarItem = %@", self.tabBarItem);
}

/*
 2023-05-19 17:11:14.720774+0800 ZJIOS[11511:5321608] topItem0 = <UINavigationItem: 0x7fac14713c10> title='UIKit' style=navigator
 2023-05-19 17:11:14.721592+0800 ZJIOS[11511:5321608] topItem1 = <UINavigationItem: 0x7fac14713c10> title='topItem-title1' style=navigator
 2023-05-19 17:11:14.724633+0800 ZJIOS[11511:5321608] topItem2 = <UINavigationItem: 0x7fac14713c10> title='self-Title1' style=navigator
 2023-05-19 17:11:14.724912+0800 ZJIOS[11511:5321608] self.tabBarItem = <UITabBarItem: 0x7fac15412be0> title='self-Title1' image=<UIImage:0x6000016eccf0 anonymous {22, 22} renderingMode=alwaysOriginal> selected
 
 ## 先修改topItem.title再修改self.title, navi和tabBar的title都为self.title,
 ## 所以同时设置了topItem和self.title,navi的title以之后设置的title为准
 */
- (void)test4 {
    NSLog(@"topItem0 = %@", self.navigationController.navigationBar.topItem);
    self.navigationController.navigationBar.topItem.title = @"topItem-title1";
    NSLog(@"topItem1 = %@", self.navigationController.navigationBar.topItem);
    self.title = @"self-Title1";
    NSLog(@"topItem2 = %@", self.navigationController.navigationBar.topItem);
    NSLog(@"self.tabBarItem = %@", self.tabBarItem);

    [self performSelector:@selector(changeTabBarTitle) withObject:nil afterDelay:3];
}

/*
 2023-05-19 17:25:29.674333+0800 ZJIOS[11932:5337383] self.tabBarItem0 = <UITabBarItem: 0x7fcdfdc09f70> title='self-Title1' image=<UIImage:0x600001809050 anonymous {22, 22} renderingMode=alwaysOriginal> selected
 2023-05-19 17:25:29.676699+0800 ZJIOS[11932:5337383] self.tabBarItem1 = <UITabBarItem: 0x7fcdfdc09f70> title='tabBarTitle' image=<UIImage:0x600001809050 anonymous {22, 22} renderingMode=alwaysOriginal> selected
 2023-05-19 17:25:29.677078+0800 ZJIOS[11932:5337383] self.tabBarItem2 = <UITabBarItem: 0x7fcdfdc09f70> title='tabBarTitle' image=<UIImage:0x600001809050 anonymous {22, 22} renderingMode=alwaysOriginal> selected
 2023-05-19 17:25:29.678946+0800 ZJIOS[11932:5337383] self.tabBarItem3 = <UITabBarItem: 0x7fcdfdc09f70> title='self-Title2' image=<UIImage:0x600001809050 anonymous {22, 22} renderingMode=alwaysOriginal> selected
 
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
