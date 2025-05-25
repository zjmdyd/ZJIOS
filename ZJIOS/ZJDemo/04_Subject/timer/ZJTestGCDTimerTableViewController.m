//
//  ZJTestGCDTimerTableViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/1/27.
//

#import "ZJTestGCDTimerTableViewController.h"

@interface ZJTestGCDTimerTableViewController ()

@end

dispatch_source_t dis_timer;

@implementation ZJTestGCDTimerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test3];
}

/*
 SEC   秒
 PER   每
 NSEC 纳秒
 MSEC 毫秒
 USEC 微秒
 
 #define NSEC_PER_SEC 1000000000ull     // 1秒    10亿纳秒      1秒=10亿纳秒
 #define NSEC_PER_MSEC 1000000ull       // 1毫秒  100万纳秒      1毫秒=100万纳秒
 #define USEC_PER_SEC 1000000ull        // 1秒    100万微秒      1秒=100万微秒
 #define NSEC_PER_USEC 1000ull          // 1微秒  1000纳秒      1微秒=1000纳秒
 */
- (void)test0 {
    bool a = (NSEC_PER_SEC == NSEC_PER_MSEC*1000);      // 10^9 纳秒/秒 <-- 10^6 纳秒/毫秒
    NSLog(@"a = %d", a);    // a = 1
    
    bool b = (NSEC_PER_SEC == USEC_PER_SEC*1000);       // 10^9 纳秒/秒 <-- 10^6 微秒/秒
    NSLog(@"b = %d", b);    // b = 1
    
    bool c = (NSEC_PER_SEC == NSEC_PER_USEC*1000*1000); // 10^9 纳秒/秒 <-- 10^3 纳秒/微秒
    NSLog(@"c = %d", c);    // c = 1
    
    bool d = (NSEC_PER_MSEC == USEC_PER_SEC);           // 10^6 纳秒/毫秒 <-- 10^6 微秒/秒
    NSLog(@"d = %d", d);    // d = 1
}

/*
 GCD定时器完全不受runloop影响，也就是说不会受到手势和UI刷新影响。所以它比NSTimer 更加准确
 ‌(1) type：事件类型‌
 支持以下系统级事件监听：
 ‌‌DISPATCH_SOURCE_TYPE_TIMER‌：定时器（高精度计时）
 ‌‌DISPATCH_SOURCE_TYPE_SIGNAL‌：UNIX 信号（如 SIGTERM）
 ‌‌DISPATCH_SOURCE_TYPE_READ/WRITE‌：文件或 Socket 的 I/O 可读/可写状态
 ‌‌DISPATCH_SOURCE_TYPE_VNODE‌：文件系统事件（删除、重命名等）
 ‌‌DISPATCH_SOURCE_TYPE_PROC‌：进程状态变化（如退出）
 ‌‌DISPATCH_SOURCE_TYPE_DATA_ADD/OR‌：自定义事件（手动触发）
 
 ‌‌(2) handle：事件句柄‌
 根据 type 不同，传入对应的系统资源标识符：
 ‌‌文件描述符‌（DISPATCH_SOURCE_TYPE_READ）：传入 int fd
 ‌‌进程ID‌（DISPATCH_SOURCE_TYPE_PROC）：传入 pid_t
 ‌‌信号值‌（DISPATCH_SOURCE_TYPE_SIGNAL）：传入 int signo
 ‌‌定时器‌（DISPATCH_SOURCE_TYPE_TIMER）：传 0（无实际句柄）
 
 ‌‌(3) mask：事件掩码‌
 进一步细化监听条件47：
 ‌‌DISPATCH_SOURCE_TYPE_PROC‌：可监听 EXIT、FORK 等子事件
 ‌‌DISPATCH_SOURCE_TYPE_VNODE‌：可监听 DELETE、WRITE 等文件操作
 ‌‌其他类型‌：通常传 0（无特殊掩码需求）
 ‌‌(4) queue：回调队列‌
 事件触发时，回调 block 执行的队列（主队列或自定义队列)
 ‌(1) 优势‌
 ‌‌高精度‌：不受 RunLoop 影响（如 NSTimer 在滑动时可能失效）
 ‌‌低开销‌：直接监听系统内核事件（基于 kqueue 或 mach port）
 ‌‌线程安全‌：自动管理事件与队列的同步6
 ‌‌(2) 注意事项‌
 ‌‌资源释放‌：必须调用 dispatch_source_cancel 并实现 cancel_handler 释放资源（如关闭文件描述符）
 ‌‌生命周期管理‌：需强引用 dispatch_source_t 对象，避免提前释放26
 ‌‌自定义事件‌：通过 dispatch_source_merge_data 触发 DATA_ADD/OR 类型事
 */
- (void)test1 {
    // 获得队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 创建一个定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 开始时间, 多少时间后开始
    dispatch_time_t start_time = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC);
    
    uint64_t interval = NSEC_PER_SEC;
    /* 设置定时器
     * param2: 任务开始时间
     * param3: 任务的间隔
     * param4: 可接受的误差时间，设置0即不允许出现误差,系统只会尽可能满足这个需求，无法完全精确
     * Tips: 单位均为纳秒
     */
    dispatch_source_set_timer(timer, start_time, interval, 0);

    __weak typeof(self) weakSelf = self;
    static int count = 0;
    dispatch_source_set_event_handler(timer, ^{
        count++;
        NSLog(@"currentThread = %@, count_1 = %d", [NSThread currentThread], count);
        // 在kCFRunLoopDefaultMode和UITrackingRunLoopMode中切换
        // 滑动事件不会干扰定时器
        NSLog(@"self = %@, currentMode = %@", weakSelf, [NSRunLoop currentRunLoop].currentMode);
        if (!weakSelf) {
            NSLog(@"self销毁,主动调用dispatch_cancel");
            dispatch_source_cancel(timer);
        }
        if (count == 15) {
            NSLog(@"目标任务结束,主动调用dispatch_cancel");
            dispatch_source_cancel(timer);  // 或者调用dispatch_cancel(timer);
            // dispatch_resume(timer); 重启timer , cancel后再重启后会crash
        }
    });
    
    // 启动
    dispatch_resume(timer);
    
    dispatch_source_set_cancel_handler(timer, ^{
        NSLog(@"timer执行了cancel事件");
        count = 0;
    });
}

/*

 
 QoS 等级                         适用场景                                性能影响
 ‌‌QOS_CLASS_USER_INTERACTIVE    用户直接感知的即时操作（如动画）           最高 CPU/GPU 资源占用
 ‌‌QOS_CLASS_USER_INITIATED      用户触发但可稍后完成的任务（如文件保存）    中等优先级，允许短暂延迟
 ‌‌QOS_CLASS_UTILITY             后台计算或下载任务                      低优先级，资源受限时可能被延迟
 
 currentMode = (null); 常见原因
 不在主线程上运行：NSRunLoop 主要与主线程（即 UI 线程）相关联。如果你的代码不在主线程上运行，那么 currentMode 可能会返回 nil
 */
- (void)test2 {
    // 获得队列
//    dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0);
//    并行: DISPATCH_QUEUE_CONCURRENT‌ 串行:DISPATCH_QUEUE_SERIAL
    dispatch_queue_t queue = dispatch_queue_create("com.zj.queue", DISPATCH_QUEUE_SERIAL);

    // 创建一个定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 开始时间, 多少时间后开始
    dispatch_time_t start_time = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC);
    
    uint64_t interval = NSEC_PER_SEC;
    /* 设置定时器
     * param2: 任务开始时间
     * param3: 任务的间隔
     * param4: 可接受的误差时间，设置0即不允许出现误差,系统只会尽可能满足这个需求，无法完全精确
     */
    dispatch_source_set_timer(timer, start_time, interval, 0);
    
    __weak typeof(self) weakSelf = self;
    static int count = 0;
    NSLog(@"count = %p", &count);   // 0x10af2df18
    dispatch_source_set_event_handler(timer, ^{
        @synchronized (self) {
            count++;
        }
        NSLog(@"currentThread = %@, count_2 = %d", [NSThread currentThread], count);
        
        // currentMode = (null),因为不在主线程上运行
        // 滑动事件不会干扰定时器
        NSLog(@"self = %@, currentMode = %@", weakSelf, [NSRunLoop currentRunLoop].currentMode);
        if (!weakSelf) {
            NSLog(@"self销毁,主动调用dispatch_cancel");
            dispatch_source_cancel(timer);
        }
        if (count == 15) {
            NSLog(@"目标任务结束,主动调用dispatch_cancel");
            dispatch_source_cancel(timer);  // 或者调用dispatch_cancel(timer);
        }
        
        if(count == 5) {
            NSLog(@"执行suspend");
            // 暂停定时器
            dispatch_suspend(timer);    // suspend可重新resume
            
            // 2秒后重启timer
            // dispatch_after函数并不是在指定时间后执行处理，而是在指定时间追加到Dispatch Queue
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 2ull * NSEC_PER_SEC);
            dispatch_after(time, queue, ^{
                dispatch_resume(timer);
            });
        }
    });
    
    //启动任务，GCD计时器创建后需要手动启动
    dispatch_resume(timer);
    dispatch_source_set_cancel_handler(timer, ^{
        @synchronized (self) {
            count = 0;
        }
        NSLog(@"currentThread = %@, count_2 = %d", [NSThread currentThread], count);
        NSLog(@"timer执行了cancel事件");
    });
}

- (void)test3 {
    // 获得队列
//    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_queue_t queue = dispatch_queue_create("com.zj.queue", DISPATCH_QUEUE_SERIAL);

    // 创建一个定时器
    dis_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 开始时间     多少时间后开始
    dispatch_time_t start_time = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC);
    
    uint64_t interval = NSEC_PER_SEC;
    /* 设置定时器
     * param2: 任务开始时间
     * param3: 任务的间隔
     * param4: 可接受的误差时间，设置0即不允许出现误差,系统只会尽可能满足这个需求，无法完全精确
     */
    dispatch_source_set_timer(dis_timer, start_time, interval, 0);
    
    /* 设置定时器任务: 可以通过block方式 也可以通过C函数方式
     */
    dispatch_source_set_event_handler_f(dis_timer, (void *)timerEvent);
    
    //启动任务，GCD计时器创建后需要手动启动
    dispatch_resume(dis_timer);
}

void timerEvent(void) {
    static int count = 0;
//    NSLock *lock = [[NSLock alloc] init];
//    [lock lock];
    count++;
//    [lock unlock];
    NSLog(@"currentThread = %@, count = %d", [NSThread currentThread], count);

    //终止定时器
    if (count == 15) {
        NSLog(@"目标任务结束,主动调用dispatch_cancel");
        dispatch_source_cancel(dis_timer);  // 或者调用dispatch_cancel(timer);
    }
    
    if(count == 5) {
        NSLog(@"执行suspend");
        // 暂停定时器
        dispatch_suspend(dis_timer);    // suspend可重新resume
        
        // 2秒后重启timer
        // dispatch_after函数并不是在指定时间后执行处理，而是在指定时间追加到Dispatch Queue
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 2ull * NSEC_PER_SEC);
        dispatch_queue_t queue = dispatch_queue_create("com.zj.queue", DISPATCH_QUEUE_SERIAL);
        dispatch_after(time, queue, ^{
            dispatch_resume(dis_timer);
        });
    }
    
    dispatch_source_set_cancel_handler(dis_timer, ^{
        count = 0;
        NSLog(@"timer执行了cancel事件");
        NSLog(@"currentThread = %@, count_2 = %d", [NSThread currentThread], count);
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10000;
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
