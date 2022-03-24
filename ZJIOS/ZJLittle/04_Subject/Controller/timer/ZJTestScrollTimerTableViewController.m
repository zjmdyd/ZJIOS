//
//  ZJTestScrollTimerTableViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/1/26.
//

#import "ZJTestScrollTimerTableViewController.h"
#import "NSTimer+ZJBlockTimer.h"

@interface ZJTestScrollTimerTableViewController ()

@property (nonatomic, weak) NSTimer *timer;

@end

@implementation ZJTestScrollTimerTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test2];
}

/*
 设置成UITrackingRunLoopMode时,timer只会在滑动scrollView时触发
 */
- (void)test3 {
    self.timer = [NSTimer zj_timerWithTimeInterval:2 repeats:YES addToRunLoopWithMode:UITrackingRunLoopMode block:^(NSTimer * _Nonnull timer) {
        NSLog(@"执行timer的方法:%@", timer);
        NSLog(@"currentMode = %@", [NSRunLoop currentRunLoop].currentMode);
    }];
}

/*
 解决timer不准确: 设置成NSRunLoopCommonModes
 滑动scrollView是在UITrackingRunLoopMode, 设置成NSRunLoopCommonModes时,不会出现timer暂停现象
 */
- (void)test2 {
    self.timer = [NSTimer zj_timerWithTimeInterval:2 repeats:YES addToRunLoopWithMode:NSRunLoopCommonModes block:^(NSTimer * _Nonnull timer) {
        NSLog(@"执行timer的方法:%@", timer);
        NSLog(@"currentMode = %@", [NSRunLoop currentRunLoop].currentMode);
    }];
}

/*
 timer不准确: NSTimer 的runloop类型是NSDefaultRunloopMode 主线程中， 界面的刷新也在主线程中，
 UIScrollview滑动的过程中是在UITrackingRunLoopMode中，当我们在手指滑动过程中，系统会将NSDefaultRunloopMode 更改为NSTrackingRunloopMode，所以会出现NSTimer短暂暂停的现象
 */
- (void)test1 {
    self.timer = [NSTimer zj_scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"执行timer的方法:%@", timer);
        NSLog(@"currentMode = %@", [NSRunLoop currentRunLoop].currentMode);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SystemTableViewCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SystemTableViewCell];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%zd行", indexPath.row];
//    NSLog(@"UITableViewCell__currentMode = %@", [NSRunLoop currentRunLoop].currentMode);

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    [self.timer invalidate];
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
