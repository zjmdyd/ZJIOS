//
//  ZJTestStatusBarTableViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/5/21.
//

#import "ZJTestStatusBarTableViewController.h"
#import "ZJScrollViewDefines.h"
#import "UIApplication+ZJApplication.h"

@interface ZJTestStatusBarTableViewController ()

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, strong) UIView *statusBarView;


@end

@implementation ZJTestStatusBarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
    [self initSetting];
}

- (void)initAry {
    
}

- (void)initSetting {
    self.statusBarStyle = UIStatusBarStyleDefault;
    self.cellTitles = @[@[@"UIStatusBarStyleDefault", @"UIStatusBarStyleLightContent", @"UIStatusBarStyleDarkContent"], @[@"隐藏显示导航栏"], @[@"状态栏背景色"]];
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
        cell = [[ZJBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SystemTableViewCell];
    }
    NSArray *ary = self.cellTitles[indexPath.section];
    cell.textLabel.text = ary[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
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
        if (indexPath.row == 0) {
            self.statusBarStyle = UIStatusBarStyleDefault;
        }else if (indexPath.row == 1) {
            self.statusBarStyle = UIStatusBarStyleLightContent;
        }else {
            if (@available(iOS 13.0, *)) {
                self.statusBarStyle = UIStatusBarStyleDarkContent;
            } else {
                self.statusBarStyle = UIStatusBarStyleDefault;
            }
        }
        [self test0];
    }else if (indexPath.section == 1){
        [self test1];
    }else if (indexPath.section == 2){
        [self test2];
    }
}

- (void)test0 {
    //    View controller-based status bar appearance=YES; / (UIViewControllerBasedStatusBarAppearance=YES)
    if ([UIApplication appBoolInfoWithType:AppBoolInfoTypeBasedStatusBarAppearance]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }else {
        // 此方法生效需要在plist文件之中设置View controller-based status bar appearance=NO
        [[UIApplication sharedApplication] setStatusBarStyle:self.statusBarStyle];
    }
}

- (void)test1 {
    self.navigationController.navigationBarHidden = !self.navigationController.isNavigationBarHidden;
}

/*
 从iOS 14开始，刘海屏的状态栏高度不再是固定的44pt，而是根据具体机型有所不同。
 例如，iPhone 11和XR的状态栏高度为48pt，iPhone 12、13非mini系列以及iPhone 14的状态栏高度为47pt，
 iPhone 12、13 mini系列的状态栏高度为50pt，而iPhone 14、15 Pro/Pro Max的状态栏高度为59pt。
 非刘海屏机型的状态栏高度保持为20pt。
 ‌‌状态栏高度可能因iOS版本更新而变化‌：
 随着iOS版本的更新，状态栏高度的处理逻辑可能会有所调整
 */
- (void)test2 {
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager;

        if ([statusBarManager respondsToSelector:@selector(createLocalStatusBar)]) {
            UIView *localStatusBar = [statusBarManager performSelector:@selector(createLocalStatusBar)];
            NSLog(@"localStatusBar = %@", localStatusBar);  // 拿不到，为null            
            
            if (localStatusBar && [localStatusBar respondsToSelector:@selector(statusBar)]) {
                self.statusBarView = [localStatusBar performSelector:@selector(statusBar)];
            }else {
                NSLog(@"statusBarFrame = %@", NSStringFromCGRect(statusBarManager.statusBarFrame));
                self.statusBarView = [[UIView alloc] initWithFrame:statusBarManager.statusBarFrame];
                [[UIApplication sharedApplication].keyWindow addSubview:self.statusBarView];
            }
        }
    } else {
        self.statusBarView = [[UIApplication sharedApplication] valueForKeyPath:@"statusBar"];
    }
    
    self.statusBarView.backgroundColor = [UIColor redColor];
//    self.statusBarView.layer.borderWidth = 1;
//    self.statusBarView.layer.borderColor = [UIColor blueColor].CGColor;
//    UIView *sv = statusBarView.subviews[0];
//    sv.backgroundColor = [UIColor redColor];
//    sv.layer.borderWidth = 1;
//    sv.layer.borderColor = [UIColor blueColor].CGColor;
    NSLog(@"%@", self.statusBarView.superview);
    NSLog(@"%@", self.statusBarView.subviews);
    NSLog(@"statusBarView = %@", self.statusBarView);
}

// 默认情况下状态栏根据导航栏的barStyle来显示状态
// 此方法被调用需要隐藏导航栏,未隐藏不会调用preferredStatusBarStyle方法
- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.statusBarView removeFromSuperview];
    self.statusBarView = nil;
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
