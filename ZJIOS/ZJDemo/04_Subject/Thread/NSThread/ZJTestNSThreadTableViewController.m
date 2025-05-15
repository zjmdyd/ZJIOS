//
//  ZJTestNSThreadTableViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/12/16.
//

#import "ZJTestNSThreadTableViewController.h"

@interface ZJTestNSThreadTableViewController ()

@property (nonatomic, strong) NSThread *thread;

@end

@implementation ZJTestNSThreadTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
}

- (void)initAry {
    self.vcType = ZJBaseTableViewTypeExecute;
    self.cellTitles = @[@"test0", @"test1", @"test2", @"test3", @"test4"];
}

/*
 任务的执行速度的影响因素:CPU性能,任务的复杂度,任务的优先级,线程的状态
 
 NSQualityOfService‌是iOS开发中的一个概念，用于指定任务的质量服务（Quality of Service，QoS）级别。通过设置不同的QoS级别，可以影响任务的优先级和调度方式，从而优化应用的性能和能效。

 QoS级别的分类及其应用场景
 在iOS中，QoS级别主要分为以下几类：

 ‌‌User-interactive‌：适用于与用户交互的任务，如用户界面操作和动画。这些任务需要快速响应，避免界面冻结。
 ‌‌User-initiated‌：用户启动的任务，如打开文档或点击界面控件。这些任务需要快速完成，以继续用户交互。
 ‌‌Utility‌：适用于不需要立即完成但周期性执行的任务，如数据下载或导入。这些任务可以在响应能力、性能和能效之间取得平衡。
 ‌‌Background‌：后台任务，如索引建立或数据同步。这些任务对用户不可见，主要关注能源效率。
 QoS级别的设置方法
 在iOS中，可以通过NSOperationQueue或GCD（Grand Central Dispatch）来设置任务的QoS级别。例如，使用NSOperationQueue时，可以设置qualityOfService属性：
 
 QoS级别对性能和能效的影响
 通过合理设置QoS级别，可以优化应用的性能和能效：

 ‌‌User-interactive‌和‌User-initiated‌级别适合需要快速响应的任务，确保用户界面的流畅性和交互的即时性。
 ‌‌Utility‌级别适用于那些可以稍微延迟但不影响用户体验的任务，如数据下载或缓存更新，可以在性能和能效之间取得平衡。
 */
- (void)test0 {
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(thread1) object:nil];
    thread1.qualityOfService = NSQualityOfServiceBackground;
    [thread1 start];

    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(thread2) object:nil];
    thread2.qualityOfService = NSQualityOfServiceUserInteractive;    // 优先级越高先执行, 任务队列空闲时会先执行thread1
    [thread2 start];
}

- (void)thread1 {
    NSLog(@"thread1执行了");
}

// thread2先执行
- (void)thread2 {
    NSLog(@"thread2执行了");
}

// 静态实例化‌：创建后自动启动线程
- (void)test1 {
    // thread1Event执行了:hhh
    [NSThread detachNewThreadSelector:@selector(thread1Event:) toTarget:self withObject:@"hhh"];
}

- (void)thread1Event:(id)obj {
    NSLog(@"thread1Event执行了:%@", obj);
}

- (void)test2 {
    //创建线程
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadEvent) object:nil];
    //设置线程的名称
    [self.thread setName:@"线程A"];
    [self.thread start];
}

- (void)threadEvent {
    //获取线程
    NSThread *current = [NSThread currentThread];
    NSLog(@"test---打印线程---%@", self.thread);
    NSLog(@"test---线程开始---%@", current);

// 可以使用sleepUntilDate:或sleepForTimeInterval:方法暂停线程
    NSLog(@"接下来，子线程阻塞2秒");
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:2.0];
    [NSThread sleepUntilDate:date]; // 或[NSThread sleepForTimeInterval:2.0];

    for (int i = 0; i < 10; i++) {
        NSLog(@"线程--%d--%@", i, current);
        if (5 == i) {
            // 结束线程: 当当前线程死亡之后,这个线程中的代码都不会被执行.
            [NSThread exit];
//            调用cancel方法标记线程为取消状态，但不会立即停止线程。
//            [current cancel];
        }
    }
    NSLog(@"test---线程结束---%@", current);   // 不会执行，因为执行过[NSThread exit]方法
}

/*
    test restart thread
    注意：人死不能复生，线程死了也不能复生（重新开启），如果在线程死亡之后，再次尝试重新开启线程，则程序会挂。
*/
- (void)test3 {
    // 记得先执行test2()
    NSLog(@"self.thread = %@", self.thread);
    NSLog(@"isCancelled = %d", self.thread.isCancelled);    // isCancelled = 0
    NSLog(@"isExecuting = %d", self.thread.isExecuting);    // isExecuting = 0
    NSLog(@"isFinished = %d", self.thread.isFinished);      // isFinished = 1
    //重新开启已经exit的线程 会crash
//    [self.thread start];
    
    for (int i = 0; i < 10; i++) {
        NSLog(@"i*i = %d", i*i);    // 子线程阻塞/睡眠 不会影响主线程,在test2()睡眠期间,可以正常运行test3()
    }
}

- (void)test4 {
    [self showVCWithNibName:@"ZJTestNSThreadDemoViewController"];
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
