//
//  ZJTestThreadSafeViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/12/19.
//

#import "ZJTestThreadSafeViewController.h"

@interface ZJTestThreadSafeViewController ()

//atomic：原子属性，为setter方法加自旋锁（即为单写多读）

@property (nonatomic, strong) NSString *target;   // 此处用nonatomic会闪退，nonatomic是非线程安全的。
//@property (atomic, strong) NSString *target;

// 定义成weak也可以解决闪退
//@property (nonatomic, weak) NSString *target;

@end

@implementation ZJTestThreadSafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initAry];
}

- (void)initAry {
    self.vcType = ZJBaseTableViewTypeExecute;
    self.cellTitles = @[@"DISPATCH_QUEUE_CONCURRENT", @"@synchronized", @"DISPATCH_QUEUE_SERIAL", @"dispatch_barrier_async", @"dispatch_barrier_async_and_wait", @"test_barrier_async", @"test_barrier_sync"];
    self.values = @[@"test0", @"test1", @"test2", @"test3", @"test4", @"test_barrier_async", @"test_barrier_sync"];
}

/*
 *  网易面试题，闪退原因?
 */
- (void)test0 {
    NSLog(@"c1 = %@", [NSThread currentThread]);    // name = main

    dispatch_queue_t queue = dispatch_queue_create("parallel", DISPATCH_QUEUE_CONCURRENT);  // 并行队列
    for (int i = 0; i < 100000; i++) {
        dispatch_async(queue, ^{
//            self.target = [NSString stringWithFormat:@"i->%d", i]; // 会闪退
        });
    }
    NSLog(@"c2 = %@", [NSThread currentThread]);    // name = main,
    NSLog(@"self.target = %@", self.target);
    NSLog(@"结束");
}
/*
 @synchronized加锁
 */
- (void)test1 {
    NSLog(@"c1 = %@", [NSThread currentThread]);    // name = main

    dispatch_queue_t queue = dispatch_queue_create("parallel", DISPATCH_QUEUE_CONCURRENT);  // 并行队列
    for (int i = 0; i < 100000; i++) {
        dispatch_async(queue, ^{
            @synchronized (self) {
                self.target = [NSString stringWithFormat:@"i->%d", i];
            }
        });
    }
    NSLog(@"c2 = %@", [NSThread currentThread]);    // name = main,
    NSLog(@"self.target = %@", self.target);
    NSLog(@"结束");
}

// 修改为串行队列，还会阻塞主线程
- (void)test2 {
    NSLog(@"c1 = %@", [NSThread currentThread]);    // name = main
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("serial", DISPATCH_QUEUE_SERIAL);  // 串行队列

    for (int i = 0; i < 5; i++) {
        NSLog(@"for_i = %d, %@", i, [NSThread currentThread]);    // 此处是在主线程执行, 所以会阻塞主线程,但是不会闪退
        dispatch_group_async(group, queue, ^{
            NSLog(@"i = %d, %@", i, [NSThread currentThread]);    // 此处是子线程
            self.target = [NSString stringWithFormat:@"i->%d", i];
        });
    }
    //得到线程执行完的通知
    dispatch_group_notify(group, queue, ^{
        NSLog(@"dispatch_group_notify_completed, %@", [NSThread currentThread]);
        NSLog(@"self.target_notify = %@", self.target);
    });
    // DISPATCH_TIME_FOREVER会阻塞当前线程,所以不要在主线程执行dispatch_group_wait
    dispatch_async(queue, ^{
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        NSLog(@"dispatch_group_wait_completed, %@", [NSThread currentThread]);
        NSLog(@"self.target_wait = %@", self.target);
    });
    
    NSLog(@"c2 = %@", [NSThread currentThread]);    // name = main,
    NSLog(@"self.target = %@", self.target);
    NSLog(@"结束");
}

/*
 dispatch_barrier_async 是 GCD（Grand Central Dispatch）中用于控制并发队列任务执行顺序的栅栏函数，其核心特性和用法如下：
 一、核心机制
 ‌‌任务隔离‌
 在自定义并发队列（DISPATCH_QUEUE_CONCURRENT）中，该函数会等待其‌之前提交的所有任务完成‌后执行自身任务，并确保‌后续任务等待其执行完毕‌才继续。
 ‌‌异步提交‌：函数立即返回，不阻塞当前线程。不会阻塞主线程
 ‌‌栅栏效应‌：实现任务间的“隔离带”，避免数据竞争。
 ‌‌无效场景‌
 全局队列（dispatch_get_global_queue）和串行队列中使用时栅栏功能失效，任务按普通异步任务处理。

 二、典型应用场景
 ‌‌读写锁模拟‌
 保护共享资源（如数据库、文件），确保写操作独占执行。
 ‌‌任务依赖管理‌
 需严格按顺序执行的任务链中插入关键操作
 队列类型‌：必须为自定义并发队列，串行队列或全局队列无效
 
 */
- (void)test3 {
    NSLog(@"c1 = %@", [NSThread currentThread]);    // name = main

    dispatch_queue_t queue = dispatch_queue_create("parallel", DISPATCH_QUEUE_CONCURRENT);  // 并行队列
    for (int i = 0; i < 5; i++) {
        dispatch_barrier_async(queue, ^{
            NSLog(@"i = %d, %@", i, [NSThread currentThread]);    //
            self.target = [NSString stringWithFormat:@"i->%d", i];
        });
    }
    NSLog(@"c2 = %@", [NSThread currentThread]);    // name = main,
    NSLog(@"self.target = %@", self.target);
    NSLog(@"结束");
}

/*
 dispatch_barrier_async_and_wait
 异步将任务提交到并发队列，但会阻塞当前线程直到该任务完成，会阻塞主线程
 */
- (void)test4 {
    NSLog(@"c1 = %@", [NSThread currentThread]);    // name = main

    dispatch_queue_t queue = dispatch_queue_create("parallel", DISPATCH_QUEUE_CONCURRENT);  // 并行队列
    for (int i = 0; i < 5; i++) {
        if (@available(iOS 12.0, *)) {
            // 直接在主线程,会阻塞
            dispatch_barrier_async_and_wait(queue, ^{
                NSLog(@"i = %d, %@", i, [NSThread currentThread]);    //
                self.target = [NSString stringWithFormat:@"i->%d", i];
            });
        } else {
            dispatch_barrier_async(queue, ^{
                NSLog(@"i = %d, %@", i, [NSThread currentThread]);    //
                self.target = [NSString stringWithFormat:@"i->%d", i];
            });
        }
    }
    NSLog(@"c2 = %@", [NSThread currentThread]);    // name = main,
    NSLog(@"self.target = %@", self.target);
    NSLog(@"结束");
}

/*
 
 崩溃原因分析1: 多线程资源竞争‌

 由于使用DISPATCH_QUEUE_CONCURRENT创建并行队列，循环中的dispatch_async会将任务分发到多个线程12
 多个线程同时执行self.target的赋值操作，触发非线程安全的nonatomic属性修改（MRC下涉及release和retain操作）
 ‌‌野指针访问风险‌

 当多个线程同时执行[_target release]时，可能导致对象被多次释放（如旧值的引用计数被多个线程减到负数）
 后续访问已释放内存时触发EXC_BAD_ACCESS错误
 
 崩溃原因分析2
 噢，看来是对已释放的对象再次发送了release信息。
 
 我又留意到，这个对象是Strong修饰的。  // @property (atomic, strong) NSString *target;
 
 那么他的Setter方法在MRC上就相当于
 
 - (void)setTarget:(NSString *)target {
    [target retain];//先保留新值
    [_target release];//再释放旧值
    _target = target;//再进行赋值
 }
 那么什么时候会导致过多调用release呢，因为这是个并行队列+异步。
 
 那么假如队列A执行到步奏2，还没到步骤3时，队列B也执行到步骤2，那么这个对象就会被过度释放，导致向已释放内存对象发送消息而崩溃。
 
 后来我想怎么可以修改这段代码变为不崩溃的呢？
 1.使用串行队列
 将set方法改成在串行队列中执行就行，这样即使异步，但所有block操作追加在队列最后依次执行。
 
 2. 使用atomic
 atomic关键字相当于在setter方法加锁，这样每次执行setter都是线程安全的，但这只是单独针对setter方法而言的狭义的线程安全。
 
 3.使用weak关键字
 weak的setter没有保留新值或者保留旧值的操作，所以不会引发重复释放。当然这个时候要看具体情况能否使用weak，可能值并不是所需要的值。
 
 从而我们可以总结到，线程安全有以下几种方法：
 
 单线程串行访问
 访问加锁
 使用不进行额外操作的关键字（weak）
 使用值类型
 然而这只是保证了基本的线程安全（不崩溃），若是需要保证访问出符合预期的数据，则需要采用GCD的barrier或者自己在合适的时机加锁。
 */

/*
 该函数会等待它之前提交的所有任务完成‌后执行自身任务，并确保‌后续任务等待它执行完毕‌才继续
 
 需要注意的是queue的选择，需要是自己创建的，dispatch_queue_create并且是concurrent的queue，
 不能是serial或者全局的global concurrent queues
 */
- (void)test_barrier_async {
    NSLog(@"dispatch_barrier --- begin");
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        //追加任务1
        NSLog(@"追加任务1");
        for (int i = 0; i < 5; ++i) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:1];
            //打印当前线程
            NSLog(@"任务1-->i = %d,---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        //追加任务2
        NSLog(@"追加任务2");
        for (int i = 0; i < 5; ++i) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:2];
            //打印当前线程
            NSLog(@"任务2-->i = %d,---%@", i, [NSThread currentThread]);
        }
    });
//    异步栅栏则跟async函数一样，开启新线程，不会阻塞当前线程,
//    执行顺序是:任务1和任务2并发执行, 栅栏函数任务, 任务3任务4并发执行
    dispatch_barrier_async(queue, ^{
        //追加栅栏函数任务
        NSLog(@"追加栅栏函数任务");
        for (int i = 0; i < 5; ++i) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:1];
            //打印当前线程
            NSLog(@"barrier---i = %d, %@", i, [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        //追加任务3
        NSLog(@"追加任务3");
        for (int i = 0; i < 5; ++i) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:1];
            //打印当前线程
            NSLog(@"任务3-->i = %d,---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        //追加任务4
        NSLog(@"追加任务4");
        for (int i = 0; i < 5; ++i) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:1];
            //打印当前线程
            NSLog(@"任务4-->i = %d,---%@", i, [NSThread currentThread]);
        }
    });
    
    //不会被阻塞，不需要等待，直接执行
    NSLog(@"dispatch_barrier --- end");
}

/*
 使用建议
 需要精确取消控制时优先选用 NSOperationQueue
 定时器管理使用 dispatch_source_cancel() + dispatch_source_set_event_handler 组合
 避免对非定时器源调用 dispatch_cancel()（可能引发崩溃）
 */
- (void)test_barrier_sync {
    NSLog(@"dispatch_barrier --- begin");
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        //追加任务1
        NSLog(@"追加任务1");
        for (int i = 0; i < 5; ++i) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:1];
            //打印当前线程
            NSLog(@"任务1-->i = %d,---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        //追加任务2
        NSLog(@"追加任务2");
        for (int i = 0; i < 5; ++i) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:1];
            //打印当前线程
            NSLog(@"任务2-->i = %d,---%@", i, [NSThread currentThread]);
        }
    });
//  同步栅栏,会阻塞线程,如果dispatch_barrier_sync在主线调用则会阻塞主线程，dispatch_barrier_sync栅栏函数执行完才会释放主线程
//  任务3和任务4会在栅栏函数执行完毕再执行
    dispatch_barrier_sync(queue, ^{
        //追加栅栏函数任务
        NSLog(@"追加栅栏函数任务");
        for (int i = 0; i < 5; ++i) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:1];
            //打印当前线程
            NSLog(@"barrier-->i = %d,---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        //追加任务3
        NSLog(@"追加任务3");
        for (int i = 0; i < 5; ++i) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:1];
            //打印当前线程
            NSLog(@"任务3-->i = %d,---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        //追加任务4
        NSLog(@"追加任务4");
        for (int i = 0; i < 5; ++i) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:1];
            //打印当前线程
            NSLog(@"任务4-->i = %d,---%@", i, [NSThread currentThread]);
        }
    });
    
    //同步栅栏和sync函数一样，不会开启新线程，end是在同步之后打印的
    NSLog(@"dispatch_barrier --- end");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
