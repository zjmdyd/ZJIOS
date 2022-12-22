//
//  ZJTestDispatchSemaphoreTableViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/12/20.
//

#import "ZJTestDispatchSemaphoreTableViewController.h"

@interface ZJTestDispatchSemaphoreTableViewController () {
    int _count;
    dispatch_semaphore_t _semahpore;
}

@end

@implementation ZJTestDispatchSemaphoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
    [self initSetting];
}

- (void)initAry {
    self.cellTitles = @[@"test0", @"test1", @"test1_no_semahpore", @"test2_semahpore"];
}

- (void)initSetting {
    
}

/*
 Dispatch Semaphore在实际开发中主要用于
 保持线程同步，将异步执行任务转为同步执行任务
 保证线程安全，为线程加锁
 */

/*
 dispatch_semaphore_signal：发送一个信号，信号量+1
 dispatch_semaphore_wait：信号量减1，信号总量小于0时会一直等待（阻塞所在线程），否则就可以正常运行
 */
- (void)test0 {
    NSLog(@"began:%@", [NSThread currentThread]);   // 打印1
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_semaphore_t semahpore = dispatch_semaphore_create(0);
    __block int num = 0;
    dispatch_async(queue, ^{
        NSLog(@"异步线程:%@", [NSThread currentThread]);     // 打印3
        num = 10;
        // semaphore + 1，此时semaphore 为0，正在被阻塞的线程（主线程）恢复继续执行
        dispatch_semaphore_signal(semahpore);
    });
    NSLog(@"before_wait:%@", [NSThread currentThread]); // 打印2, 打印2之后信号量变为-1进入阻塞状态
    dispatch_semaphore_wait(semahpore, DISPATCH_TIME_FOREVER);  // semaphore < 0，当前线程阻塞，进入等待状态
    NSLog(@"结束:%@", [NSThread currentThread]);          // 打印4
}

- (void)test1 {
    NSLog(@"began:%@", [NSThread currentThread]);   // 打印1
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_semaphore_t semahpore = dispatch_semaphore_create(0);
    __block int num = 0;
    dispatch_async(queue, ^{
        NSLog(@"异步线程:%@", [NSThread currentThread]);     // 打印3
        num = 10;
        // semaphore + 1，此时semaphore 为0，正在被阻塞的线程（主线程）恢复继续执行
//        dispatch_semaphore_signal(semahpore);
    });
    NSLog(@"before_wait:%@", [NSThread currentThread]); // 打印2, 打印2之后信号量变为-1进入阻塞状态
    /*
     dispatch_semaphore_wait timeout参数的作用：设置timeout （超时），在超时后自动放行，如果是超时引起的，返回值是非0
     */
    dispatch_semaphore_wait(semahpore, DISPATCH_TIME_FOREVER);  // semaphore < 0，当前线程阻塞，进入等待状态
    NSLog(@"结束:%@", [NSThread currentThread]);          // 打印4
}

- (void)test1_no_semahpore {
    NSLog(@"began:%@", [NSThread currentThread]);
    
    _count = 20;
    dispatch_queue_t queueA = dispatch_queue_create("A", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queueB = dispatch_queue_create("B", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queueA, ^{
        [self saleTickNoSafe];
    });
    dispatch_async(queueB, ^{
        [self saleTickNoSafe];
    });
}

- (void)saleTickNoSafe {
    while (1) {
        if (_count > 0) {   // 有票，继续卖
            _count--;
            NSLog(@"剩余票数:%d, 窗口:%@", _count, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:0.05];
        }else {
            NSLog(@"门票已卖完");
            break;
        }
    }
}

- (void)test2_semahpore {
    NSLog(@"began:%@", [NSThread currentThread]);
    _semahpore = dispatch_semaphore_create(1);
    
    _count = 20;
    
    dispatch_queue_t queueA = dispatch_queue_create("A", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queueB = dispatch_queue_create("B", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queueA, ^{
        NSLog(@"异步线程A");
        [self saleTickSafe];
    });
    dispatch_async(queueB, ^{
        NSLog(@"异步线程B");
        [self saleTickSafe];
    });
}

/*
 执行步骤:
 窗口A买票,执行操作1，信号量1-->0，可继续，当并发的线程窗口B执行到此时,执行操作1，信号量0-->-1，窗口B线程阻塞
 窗口A执行完卖票后，执行操作2，信号量-1-->0，释放资源，此前阻塞的窗口B继续执行任务，
 并发任务，窗口A继续卖票，执行操作1，收紧资源, 此时分两种情况:窗口B如果未卖完票，则窗口A需要等待窗口B卖完票，释放资源后才能卖票，
 如果窗口B已经卖完票，则窗口A可正常卖票
 重复此上步骤，
 */
- (void)saleTickSafe {
    NSLog(@"窗口:%@", [NSThread currentThread]);

    while (1) {
        NSLog(@"操作1:信号量减1收紧资源, 窗口:%@", [NSThread currentThread]);
        dispatch_semaphore_wait(_semahpore, DISPATCH_TIME_FOREVER); // 操作1:信号量减1
        if (_count > 0) {
            _count--;
            NSLog(@"剩余票数:%d, 窗口:%@", _count, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:0.2];
            NSLog(@"操作2:信号量加1释放资源，窗口:%@", [NSThread currentThread]);
            dispatch_semaphore_signal(_semahpore);      // 操作2:信号量加1
        }else {
            NSLog(@"门票已卖完");
            dispatch_semaphore_signal(_semahpore);      // 操作3:信号量加1
            break;
        }
    }
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

    NSString *funcName = self.cellTitles[indexPath.row];
    SEL sel = NSSelectorFromString(funcName);
    [self performSelector:sel];
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
