//
//  ZJTestLockTableViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/12/20.
//

#import "ZJTestLockTableViewController.h"

@interface ZJTestLockTableViewController ()

@end

@implementation ZJTestLockTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initAry];
    [self initSetting];
}

- (void)initAry {
    self.cellTitles = @[@"testGCDBasic", @"testBarrier", @"testThreadSafe", @"testDispatchSemaphore"];
    self.vcNames = @[@"ZJTestGCDBasicTableViewController", @"ZJTestGCDBarrierTableViewController", @"ZJTestThreadSafeViewController", @"ZJTestDispatchSemaphoreTableViewController"];
}

- (void)initSetting {
    
}

/*
 自旋锁与互斥锁
 自旋锁
 是一种用于保护多线程共享资源的锁，与一般互斥锁不同之处在于 当自旋锁尝试获取锁时以忙等的形式不断的循环检查锁是否可用。当上一个线程的任务没有执行完毕的时候（被锁住），那么下一个线程就会一直等待（不会睡眠），当上一个线程的任务执行完毕，下一个线程会立即执行。
 在多CPU环境中，对持有锁较短的程序来说，使用自旋锁代替一般的互斥锁往往能够提高串程序的性能。
 互斥锁
 当上一个线程的任务没有执行完毕的时候（被锁住），那么下一个线程会进入睡眠状态等待任务执行完毕。当上一个线程的任务执行完毕，下一个线程会自动会醒然后执行任务。
 总结：
 自旋锁会忙等：所谓忙等，即在访问被锁资源时，调用者线程不会休眠，而是不停循环在那么，直到被锁资源释放锁

 互斥锁会休眠：所谓休眠，即在访问被锁资源时，调用者线程会休眠，此时CPU可以调度其他线程工作。直到被锁资源释放锁，此时会唤醒休眠线程

 自旋锁优缺点：
 自旋锁的优点在于，自旋锁不会引起调用着线程睡眠，所以不会进行线程调度上下文切换 ，自旋锁的效率远高于互斥锁。
 缺点在于，自旋锁一直占用CPU，在为获得锁的情况下，一直运行（自旋）占用着CPU，如果不能在很短的时间内获得锁，那么CPU的效率就会降低。

 自旋锁：atomic、OSSpinLock、dispatch_semaphore_t
 互斥锁：pthread_mutex、@ synchronized、NSLock、NSConditionLock 、NSCondition、NSRecursiveLock
 */

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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *name = self.vcNames[indexPath.row];
    [self showVCWithName:name];
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
