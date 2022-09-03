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
    self.cellTitles = @[@[@"UIStatusBarStyleDefault", @"UIStatusBarStyleLightContent", @"UIStatusBarStyleDarkContent"], @[@"隐藏显示导航栏"], @[@"背景色"]];
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
    }else {
        [self test1];
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

- (void)test2 {
    UIView *statusBarView;
    
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager;
        if([statusBarManager respondsToSelector:@selector(createLocalStatusBar)]) {
            UIView *localStatusBarView = [statusBarManager performSelector:@selector(createLocalStatusBar)];
            statusBarView = [localStatusBarView performSelector:@selector(statusBar)];
        }
    } else {
        statusBarView = [[UIApplication sharedApplication] valueForKeyPath:@"statusBar"];
    }
    statusBarView.backgroundColor = [UIColor redColor];
    statusBarView.layer.borderWidth = 1;
    statusBarView.layer.borderColor = [UIColor blueColor].CGColor;
    UIView *sv = statusBarView.subviews[0];
    sv.backgroundColor = [UIColor redColor];
    sv.layer.borderWidth = 1;
    sv.layer.borderColor = [UIColor blueColor].CGColor;
    NSLog(@"%@", statusBarView.superview);
    NSLog(@"%@", statusBarView.subviews);
    NSLog(@"statusBarView = %@", statusBarView);
}

// 默认情况下状态栏根据导航栏的barStyle来显示状态
// 此方法被调用需要隐藏导航栏
- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
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
