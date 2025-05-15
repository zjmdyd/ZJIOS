//
//  ZJTestScrollTimerTableViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/1/26.
//

#import "ZJTestScrollTimerTableViewController.h"
#import "NSTimer+ZJBlockTimer.h"

@interface ZJTestScrollTimerTableViewController ()

@property (nonatomic, assign) NSInteger index;

@end

@implementation ZJTestScrollTimerTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test2];
}

/*
 timer不准确: NSTimer 的runloop类型是NSDefaultRunloopMode 主线程中， 界面的刷新也在主线程中，
 UIScrollview滑动的过程中是在UITrackingRunLoopMode中，当我们在手指滑动过程中，系统会将NSDefaultRunloopMode 更改为NSTrackingRunloopMode，所以会出现NSTimer暂停的现象
 */
- (void)test0 {
    __weak typeof(self) weak_self = self;
    self.timer = [NSTimer zj_scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        weak_self.index++;
        NSLog(@"执行timer的方法:%@, index = %zd", timer, weak_self.index);
        NSLog(@"currentMode = %@", [NSRunLoop currentRunLoop].currentMode);
    }];
}

/*
 解决timer不准确: 设置成NSRunLoopCommonModes
 滑动scrollView是在UITrackingRunLoopMode, 设置成NSRunLoopCommonModes时,不会出现timer暂停现象
 */
- (void)test1 {
    __weak typeof(self) weak_self = self;
    self.timer = [NSTimer zj_timerWithTimeInterval:1 repeats:YES addToRunLoopWithMode:NSRunLoopCommonModes block:^(NSTimer * _Nonnull timer) {
        weak_self.index++;
        NSLog(@"执行timer的方法:%@, index = %zd", timer, weak_self.index);
        NSLog(@"currentMode = %@", [NSRunLoop currentRunLoop].currentMode);
    }];
}

/*
 设置成UITrackingRunLoopMode时,timer只会在滑动scrollView时触发,其他模式下不触发
 此种情形可以用来记录滑动列表的时间
 */
- (void)test2 {
    __weak typeof(self) weak_self = self;
    self.timer = [NSTimer zj_timerWithTimeInterval:1 repeats:YES addToRunLoopWithMode:UITrackingRunLoopMode block:^(NSTimer * _Nonnull timer) {
        weak_self.index++;;
        NSLog(@"执行timer的方法:%@, index = %zd", timer, weak_self.index);
        NSLog(@"currentMode = %@", [NSRunLoop currentRunLoop].currentMode);
    }];
}

/*
 ‌NSRunLoopCommonModes‌是指在NSTimer的调度中使用的模式，它等效于NSDefaultRunLoopMode和NSEventTrackingRunLoopMode的结合。这种模式允许定时器在默认模式下运行，同时也能在用户界面事件（如拖动操作）发生时切换到跟踪模式，确保定时器的执行不会受到干扰。

 NSRunLoopCommonModes的作用
 NSRunLoopCommonModes的主要作用是确保定时器在默认模式下正常运行，同时能够在用户界面事件发生时切换到跟踪模式，从而保证定时器的稳定执行。当使用scheduledTimerWithTimeInterval方法创建定时器时，定时器会被加入到当前线程的Run Loop中，默认模式为NSDefaultRunLoopMode。如果当前线程是主线程（UI线程），某些UI事件（如UIScrollView的拖动操作）会将Run Loop切换到NSEventTrackingRunLoopMode模式。在这个过程中，默认模式中的事件不会被执行，因此定时器也不会执行。为了解决这个问题，可以使用NSRunLoopCommonModes模式，将定时器加入到当前Run Loop中，这样定时器就不会被UI事件干扰‌
 1。

 NSRunLoopCommonModes的使用场景
 NSRunLoopCommonModes的使用场景主要包括：

 ‌‌主线程中的定时器‌：在主线程中创建定时器时，为了避免定时器被UI事件干扰，可以使用NSRunLoopCommonModes模式。
 ‌‌需要跨模式运行的定时器‌：在某些情况下，定时器需要在不同的模式下运行，NSRunLoopCommonModes可以满足这种需求。
 通过使用NSRunLoopCommonModes，可以确保定时器在默认模式下运行，同时也能在需要时切换到跟踪模式，从而提供更稳定和可靠的定时器服务。
 */

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZJBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SystemTableViewCell];
    if (!cell) {
        cell = [[ZJBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SystemTableViewCell];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%zd行", indexPath.row];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
