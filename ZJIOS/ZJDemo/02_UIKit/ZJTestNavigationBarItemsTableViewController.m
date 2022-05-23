//
//  ZJTestNavigationBarItemsTableViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/5/17.
//

#import "ZJTestNavigationBarItemsTableViewController.h"
#import "UIViewController+ZJViewController.h"
#import "ZJScrollViewDefines.h"
#import "UITableView+ZJTableView.h"

@interface ZJTestNavigationBarItemsTableViewController ()

@property (nonatomic, assign) NSInteger selectBarStyleRow;
@property (nonatomic, assign) BOOL animation;
@property (nonatomic, assign) BOOL hiddenNavi;

@end

int zj_times;

@implementation ZJTestNavigationBarItemsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
    [self initSetting];
}

- (void)initAry {
    
}

- (void)initSetting {
    self.selectBarStyleRow = 0;
    self.cellTitles = @[@[@"UIBarStyleDefault", @"UIBarStyleBlack"], @[@"navigationBarHidden", @"animated"], @[@"items", @"navigationItem.backBarButtonItem", @"super.navigationItem"]];
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
    
    if (indexPath.section == 0) {
        if (self.selectBarStyleRow == indexPath.row) {
            cell.detailTextLabel.text = @"当前选中style";
        }else {
            cell.detailTextLabel.text = @"";
        }
        cell.accessoryView = nil;
    }else {
        if (indexPath.section == 1) {
            UISwitch *swh = [UITableView accessorySwitchWithTarget:self];
            swh.tag = indexPath.row;
            if (indexPath.row == 0) {
                swh.on = self.hiddenNavi;
            }else {
                swh.on = self.animation;
            }
            cell.accessoryView = swh;
        }else {
            cell.accessoryView = nil;
        }
        cell.detailTextLabel.text = nil;
    }
    
    return cell;
}

- (void)switchEvent:(UISwitch *)sender {
    if (sender.tag == 0) {
        self.hiddenNavi = sender.isOn;
        [self.navigationController setNavigationBarHidden:self.hiddenNavi animated:self.animation];
    }else {
        self.animation = sender.isOn;
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
    
    if (indexPath.section == 0) {
        self.selectBarStyleRow = indexPath.row;
        [self.tableView reloadData];
        [self test0];
    }else if(indexPath.section == 2) {
        NSString *selString = [NSString stringWithFormat:@"test%zd", indexPath.section - 1 + indexPath.row];
        SEL sel = NSSelectorFromString(selString);
        
        if ([self respondsToSelector:sel]) {
            NSLog(@"有此方法:%@", selString);
            [self performSelector:sel];
        }else {
            NSLog(@"无此方法:%@", selString);
        }
    }else {
        
    }
}

/*
 当barStyle=UIBarStyleDefault时
    隐藏和显示navigationBar，状态栏文字颜色无变化
 
 当初始barStyle=UIBarStyleBlack时，navigationBarHidden=NO, 执行以下步骤:
    1.当navigationBarHidden=NO-->YES时，状态栏颜色文字以preferredStatusBarStyle方法返回为准,如果当前控制器没实现则为黑色(UIBarStyleDefault时的颜色),此时无导航栏
    2.当navigationBarHidden=YES-->NO时，状态栏文字变为白色(UIBarStyleBlack), 导航栏文字颜色也为UIBarStyleBlack状态下的文字(白色),此时不会调用preferredStatusBarStyle方法
    3.barStyle=UIBarStyleBlack-->UIBarStyleDefault,状态栏颜色文字变为黑色(UIBarStyleDefault时的颜色),导航栏依旧保持白色文字
    4.navigationBarHidden=NO-->YES,状态栏颜色文字以preferredStatusBarStyle方法返回为准,此时无导航栏
    5.navigationBarHidden=YES-->NO(barStyle=UIBarStyleDefault), 状态栏颜色文字变为黑色(UIBarStyleDefault时的颜色)此时不会调用preferredStatusBarStyle方法,导航栏文字颜色变为黑色

 总结:
 当导航栏navigationBarHidden=NO时，修改barStyle不会改变导航栏文字颜色，只会改变状态栏颜色文字
 当导航栏navigationBarHidden=YES时，修改barStyle不会改变导航栏文字颜色(导航栏已不可见)，也不会改变状态栏颜色文字(保持UIBarStyleDefault黑色)
 当导航栏navigationBarHidden=YES-->NO时，导航栏文字颜色和状态栏文字颜色根据barStyle显示: UIBarStyleDefault都为黑色, UIBarStyleBlack时都为白色,
 */
- (void)test0 {
    self.navigationController.navigationBar.barStyle = self.selectBarStyleRow == 0 ? UIBarStyleDefault : UIBarStyleBlack;
}

/*
 UINavigationBar通过UINavigationItem堆栈按照如下方式来决定展示在UINavigationBar中的内容

 # 位于中间的标题会根据下方顺序选择展示的内容

 如果topItem设置了标题视图(titleView属性), 则展示标题视图
 如果topItem设置了标题文字(title属性), 则展示标题文字
 如果以上都未设置, 则展示空白
 
 # 位于右侧的按钮会根据下方顺序选择展示的内容

 如果topItem设置了右侧按钮(rightBarButtonItem属性), 则展示右侧按钮
 如果以上都未设置, 则展示空白
 
 # 位于左侧的按钮会根据下方顺序选择展示的内容

 如果topItem设置了左侧按钮(leftBarButtonItem属性), 则展示左侧按钮
 如果backItem设置了返回按钮(backBarButtonItem属性), 则展示返回按钮
 如果backItem设置了标题文字(title属性), 则展示利用标题文字封装的返回按钮
 如果以上都未设置, 则展示利用文字"Back"封装的返回按钮
 导航栏的title过长可能不会显示back的title(过长会挤压backItem的title)
 注: 如果UINavigationItem堆栈中只有一个UINavigationItem, 则不会展示返回按钮(就像首页不会显示返回按钮)
 */
/*
 2022-05-23 15:07:00.409457+0800 ZJIOS[6971:212183] items = (
     "<UINavigationItem: 0x7fb9e512b5d0> title='back1'",
     "<UINavigationItem: 0x7fb9e5609c80> title='hh'"
 )
 2022-05-23 15:07:00.409664+0800 ZJIOS[6971:212183] topItem = <UINavigationItem: 0x7fb9e5609c80> title='hh'
 2022-05-23 15:07:00.409830+0800 ZJIOS[6971:212183] backItem = <UINavigationItem: 0x7fb9e512b5d0> title='back1'
 2022-05-23 15:07:00.409996+0800 ZJIOS[6971:212183] self.navigationItem = <UINavigationItem: 0x7fb9e5609c80> title='hh', titleView = (null)
 */
- (void)test1 {
    NSLog(@"%s", __func__);
        
    // 过长会挤压backItem的title,此时修改成短title有效果, 但backItem在title没有改变的情况下不会改变,title值改变了会重新展示backItem的文字
    self.navigationController.navigationBar.topItem.title = @"hh";
    zj_times++;
    if (@available(iOS 11.0, *)) {
//        多了backButtonTitle属性是为了不影响返回父VC后的title显示,因为由test3()可知backItem和super.navigationItem是同一个item
        self.navigationController.navigationBar.backItem.backButtonTitle = [NSString stringWithFormat:@"back%d", zj_times];
    } else {
        // 会影响父VC的title显示,修改了backItem的title也会影响super.navigationItem的title
        self.navigationController.navigationBar.backItem.title = [NSString stringWithFormat:@"back%d", zj_times];
    }
    [self getItems];
}

- (void)test2 {
    NSLog(@"%s", __func__);
    //    The default value of this property is nil,注意backBarButtonItem和backItem不是一回事
    NSLog(@"self.navigationItem.backBarButtonItem = %@", self.navigationItem.backBarButtonItem);    // null
    NSLog(@"super.navigationItem.backBarButtonItem = %@", [self preControllerWithIndex:1].navigationItem.backBarButtonItem);    // null
}

/*
 2022-05-23 15:05:45.260692+0800 ZJIOS[6971:212183] self.navigationItem = <UINavigationItem: 0x7fb9e5609c80> title='ZJTestNavigationBarItemsTableViewController', titleView = (null)
 2022-05-23 15:05:45.260859+0800 ZJIOS[6971:212183] super.navigationItem = <UINavigationItem: 0x7fb9e512b5d0> title='UIKit-Title', titleView = (null)
 */
- (void)test3 {
    UIViewController *superVC = [self preControllerWithIndex:1];
    
    NSLog(@"self.navigationItem = %@, titleView = %@", self.navigationItem, self.navigationItem.titleView);
    // super.navigationIte与self.navigationBar.backItem是同一个item
    NSLog(@"super.navigationItem = %@, titleView = %@", superVC.navigationItem, superVC.navigationItem.titleView);
}

/*
 2022-05-23 15:02:42.457809+0800 ZJIOS[6971:212183] items = (
     "<UINavigationItem: 0x7fb9e512b5d0> title='UIKit-Title'"
 )
 2022-05-23 15:02:42.457955+0800 ZJIOS[6971:212183] topItem = <UINavigationItem: 0x7fb9e512b5d0> title='UIKit-Title'
 2022-05-23 15:02:42.458059+0800 ZJIOS[6971:212183] backItem = (null)
 2022-05-23 15:02:42.458235+0800 ZJIOS[6971:212183] self.navigationItem = <UINavigationItem: 0x7fb9e5609c80> title='ZJTestNavigationBarItemsTableViewController', titleView = (null)
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"%s", __func__);
    [self getItems];
    NSLog(@"self.tabBarItem = %@", self.tabBarItem);    // 与superVC的tabBarItem不是同一个
}

/*
 2022-05-23 15:02:43.059818+0800 ZJIOS[6971:212183] items = (
     "<UINavigationItem: 0x7fb9e512b5d0> title='UIKit-Title'",
     "<UINavigationItem: 0x7fb9e5609c80> title='ZJTestNavigationBarItemsTableViewController'"
 )
 2022-05-23 15:02:43.059999+0800 ZJIOS[6971:212183] topItem = <UINavigationItem: 0x7fb9e5609c80> title='ZJTestNavigationBarItemsTableViewController'
 2022-05-23 15:02:43.060172+0800 ZJIOS[6971:212183] backItem = <UINavigationItem: 0x7fb9e512b5d0> title='UIKit-Title'
 2022-05-23 15:02:43.060309+0800 ZJIOS[6971:212183] self.navigationItem = <UINavigationItem: 0x7fb9e5609c80> title='ZJTestNavigationBarItemsTableViewController', titleView = (null)
 */
/*
 viewWillAppear-->viewDidAppear,items发生了变化,topItem和backItem的指向发生了改变
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSLog(@"%s", __func__);
    [self getItems];
//    NSLog(@"tabBarItem = %@", self.tabBarItem);
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

// 默认情况下状态栏根据导航栏的barStyle来显示状态
// 此方法被调用需要隐藏导航栏
- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.selectBarStyleRow == 0 ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
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
