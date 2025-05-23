//
//  ZJTestPushTransitionTableViewController.m
//  ZJTest
//
//  Created by ZJ on 2019/4/11.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJTestPushTransitionTableViewController.h"
#import "UINavigationController+ZJNaviController.h"
#import "UIViewController+ZJViewController.h"

@interface ZJTestPushTransitionTableViewController ()

@end

@implementation ZJTestPushTransitionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
    [self initSettiing];
}

- (void)initAry {
    self.cellTitles = @[@"FromLeft", @"FromRight", @"FromBottom", @"FromTop"];
    self.values = @[kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromBottom, kCATransitionFromTop];
}

- (void)initSettiing {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZJBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SystemTableViewCell];
    if (!cell) {
        cell = [[ZJBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SystemTableViewCell];
    }
    cell.textLabel.text = self.cellTitles[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"push";
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc = [UIViewController createVCWithName:@"ZJTestPopTransitionTableViewController"];
    [self.navigationController pushViewController:vc transitionType:kCATransitionReveal subType:self.values[indexPath.row]];
}

/*
 CATransitionType 核心解析与类型大全
 一、官方支持的过渡类型
 ‌‌基础四种类型‌
 CATransition 的 type 属性支持以下标准过渡效果：
 ‌‌kCATransitionFade‌：淡入淡出（默认效果），旧视图渐隐，新视图渐显。
 ‌‌kCATransitionMoveIn‌：新视图从指定方向滑入覆盖旧视图，旧视图保持原位。
 ‌‌kCATransitionPush‌：新视图将旧视图推出屏幕，类似导航控制器的页面切换效果。
 ‌‌kCATransitionReveal‌：旧视图向指定方向滑动，逐渐露出下方的新视图。
 ‌‌扩展类型示例‌
 尽管苹果未正式公开，但实际可用的隐藏类型包括（需注意版本兼容性）：

 ‌‌cube‌：立方体翻转效果，通过 subtype 指定旋转轴方向（如 kCATransitionFromLeft）。
 ‌‌oglFlip‌：平面翻转，模拟3D效果中的Y轴翻转。
 ‌‌suckEffect‌：类似液体被吸入的效果，新视图从中心点扩散呈现6。
 ‌‌rippleEffect‌：波纹扩散效果，旧视图如水面被扰动后消失
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
