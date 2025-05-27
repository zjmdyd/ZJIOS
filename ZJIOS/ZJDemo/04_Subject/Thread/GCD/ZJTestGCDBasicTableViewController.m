//
//  ZJTestGCDBasicTableViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/12/20.
//

#import "ZJTestGCDBasicTableViewController.h"

@interface ZJTestGCDBasicTableViewController ()

@end

@implementation ZJTestGCDBasicTableViewController

/*
 1.GCD中有2个用来执行任务的函数
 
 说明：把右边的参数（任务）提交给左边的参数（队列）进行执行。
 （1）用同步的方式执行任务 dispatch_sync(dispatch_queue_t queue, dispatch_block_t block);
 （2）用异步的方式执行任务 dispatch_async(dispatch_queue_t queue, dispatch_block_t block);
 参数说明：
 queue：队列
 block：任务

 2.同步和异步的区别
 同步：在当前线程中执行
 异步：在另一条线程中执行

补充说明:
     同步和异步决定了要不要开启新的线程
     同步：在当前线程中执行任务，不具备开启新线程的能力
     异步：在新的线程中执行任务，具备开启新线程的能力
 
     并发和串行决定了任务的执行方式
     并发：多个任务并发（同时）执行
     串行：一个任务执行完毕后，再执行下一个任务
 */

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initAry];
}

- (void)initAry {
    self.vcType = ZJBaseTableViewTypeExecute;
    self.cellTitles = @[@"test0", @"test1", @"test2", @"test3", @"test4", @"test5", @"test6", @"testDispatch_group", @"test_dispatch_group_enter", @"testDispatch_group2", @"testBlockMainThread", @"test_dispatch_apply"];
}


- (void)keepAlive {
    @autoreleasepool {
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run]; // 线程不会退出
    }
}

/*
    用异步函数往并发队列中添加任务
    同时开启三个子线程:3个子线程会 并发执行
 
 每个线程有且仅有一个RunLoop对象与之关联
 */
- (void)test0 {
    //1.获得全局的并发队列 : 使用dispatch_get_global_queue函数获得全局的并发队列
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //2.添加任务到队列中，就可以执行任务
    //异步函数：具备开启新线程的能力
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"下载图片1----%@", [NSThread currentThread]);
            NSLog(@"currentRunLoop1 = %@", [NSRunLoop currentRunLoop]);
            [NSThread sleepForTimeInterval:1];
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"下载图片2----%@", [NSThread currentThread]);
            NSLog(@"currentRunLoop2 = %@", [NSRunLoop currentRunLoop]);
            [NSThread sleepForTimeInterval:1];
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"下载图片3----%@", [NSThread currentThread]);
            NSLog(@"currentRunLoop3 = %@", [NSRunLoop currentRunLoop]);
            [NSThread sleepForTimeInterval:1];
        }
    });
    
    //执行主线程:异步任务不会阻塞主线程
    NSLog(@"主线程----%@", [NSThread mainThread]);
}

/*
 队列优先级
 */
- (void)test1 {
    //1.获得全局的并发队列 : 使用dispatch_get_global_queue函数获得全局的并发队列
    dispatch_queue_t queue1 =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //2.添加任务到队列中，就可以执行任务
    //异步函数：具备开启新线程的能力
    dispatch_async(queue1, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"下载图片1----%@", [NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
    });
    dispatch_async(queue1, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"下载图片2----%@", [NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
    });
    
// DISPATCH_QUEUE_PRIORITY_HIGH并不会让该任务放在最先执行,同样是会并发执行
    dispatch_queue_t queue2 =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);

    dispatch_async(queue2, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"下载图片3----%@", [NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
    });
    
    //执行主线程:异步任务不会阻塞主线程
    NSLog(@"主线程----%@", [NSThread mainThread]);
}

/*
    用异步函数往串行队列中添加任务
    会开启线程，但是只开启一个线程,3个任务串行执行
  */
- (void)test2 {
    //创建串行队列 : 使用dispatch_queue_create函数创建串行队列
    dispatch_queue_t  queue = dispatch_queue_create("wendingding", NULL);
    //第一个参数为串行队列的名称，是c语言的字符串
    //第二个参数为队列的属性，一般来说串行队列不需要赋值任何属性，所以通常传空值（NULL）
    
    //2.添加任务到队列中执行
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"下载图片1----%@", [NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"下载图片2----%@", [NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"下载图片3----%@", [NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
    });
    
    //执行主线程
    NSLog(@"主线程----%@", [NSThread mainThread]);
    
    // 3.释放资源 (MRC)
    // dispatch_release(queue);
}

/*
    用同步函数往并发队列中添加任务
    不会开启新的线程，并发队列失去了并发的功能
 */

- (void)test3 {
    //创建并行队列
    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //2.添加任务到队列中执行, 为什么在主线程中执行?
    /*
     As a performance optimization, this function executes blocks on the current thread whenever possible, with one exception: Blocks submitted to the main dispatch queue always run on the main thread.
     */
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"下载图片1----%@", [NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"下载图片2----%@", [NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"下载图片3----%@", [NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
    });
    
    //执行主线程
    NSLog(@"主线程----%@", [NSThread mainThread]);
}

/*
    用同步函数往串行队列中添加任务
    不会开启新的线程
 */
- (void)test4 {
    NSLog(@"用同步函数往串行队列中添加任务");
    
    //创建串行队列
    dispatch_queue_t  queue = dispatch_queue_create("wendingding", NULL);
    
    //2.添加任务到队列中执行
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"下载图片1----%@", [NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"下载图片2----%@", [NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"下载图片3----%@", [NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
    });
    
    //执行主线程
    NSLog(@"主线程----%@", [NSThread mainThread]);
}

/*
 手动创建串行(DISPATCH_QUEUE_SERIAL)和并行(DISPATCH_QUEUE_CONCURRENT)队列
 */
- (void)test5 {
    NSLog(@"用同步函数往并行队列中添加任务");
    //创建并行队列    为什么还是在主线程中执行?
    dispatch_queue_t  queue = dispatch_queue_create("wendingding", DISPATCH_QUEUE_CONCURRENT);
    
    //2.添加任务到队列中执行
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"下载图片1----%@", [NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"下载图片2----%@", [NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"下载图片3----%@", [NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
    });
    
    //执行主线程
    NSLog(@"主线程----%@", [NSThread mainThread]);
}

/*
    异步线程和同步线程混合使用
 */
- (void)test6 {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    // 只会开启一个线程
    dispatch_async(queue, ^{
        //2.添加任务到队列中执行:三个任务1、2、3串行执行
        dispatch_sync(queue, ^{
            for (int i = 0; i < 5; i++) {
                NSLog(@"下载图片1----%@", [NSThread currentThread]);
                [NSThread sleepForTimeInterval:1];
            }
        });
        dispatch_sync(queue, ^{
            for (int i = 0; i < 5; i++) {
                NSLog(@"下载图片2----%@", [NSThread currentThread]);
                [NSThread sleepForTimeInterval:1];
            }
        });
        dispatch_sync(queue, ^{
            for (int i = 0; i < 5; i++) {
                NSLog(@"下载图片3----%@", [NSThread currentThread]);
                [NSThread sleepForTimeInterval:1];
            }
        });
    });
    
    //执行主线程
    NSLog(@"主线程----%@", [NSThread mainThread]);
}

- (void)testDispatch_group {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, globalQueue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"下载图片1----%@", [NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
    });
    
    dispatch_group_async(group, globalQueue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"下载图片2----%@", [NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
    });
    
    dispatch_group_async(group, globalQueue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"下载图片3----%@", [NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
    });
    
    // 3个任务会并发执行
    //得到线程执行完的通知
    dispatch_group_notify(group, globalQueue, ^{
        NSLog(@"dispatch_group_notify_completed, %@", [NSThread currentThread]);
    });
    // DISPATCH_TIME_FOREVER会阻塞当前线程,所以不要在主线程执行dispatch_group_wait
    dispatch_async(globalQueue, ^{
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        NSLog(@"dispatch_group_wait_completed, %@", [NSThread currentThread]);
    });

    dispatch_async(globalQueue, ^{
        NSLog(@"task four, %@", [NSThread currentThread]);
    });
    NSLog(@"当前线程:%@", [NSThread currentThread]);
}
/*
 dispatch_group_wait是GCD中用于同步等待任务组完成的函数，其核心机制和使用规范如下：
 ‌‌基础功能‌
 阻塞当前线程直到组内所有任务完成或超时
 与dispatch_group_notify的异步回调形成互补
 通过返回值区分等待结果（0表示成功，非0表示超时）
 ‌‌参数说明‌
 long dispatch_group_wait(dispatch_group_t group, dispatch_time_t timeout);
 group：要监视的调度组对象
 timeout：
 DISPATCH_TIME_NOW：立即返回当前状态
 DISPATCH_TIME_FOREVER：永久阻塞直到任务完成
 自定义时间值（如dispatch_time(DISPATCH_TIME_NOW, 3*NSEC_PER_SEC)）

 ‌注意事项‌
 主线程调用会导致界面卡顿
 必须保证dispatch_group_enter与dispatch_group_leave调用次数严格匹配
 与dispatch_group_notify混用时注意线程竞争
 ‌‌调试建议‌
 使用DISPATCH_TIME_NOW快速检测组状态
 超时场景应配合错误处理逻辑
 避免在串行队列的目标队列上调用
 该函数通常用于需要同步等待异步任务结果的场景，如批量网络请求完成后进行数据聚合
 
 dispatch_group_enter
 该函数通常用于需要精确控制异步任务生命周期的场景，如网络请求批处理。调试时可使用dispatch_group_wait进行超时检测
 */

- (void)test_dispatch_group_enter {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    // 手动管理任务计数（必须配对使用）
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        /* 异步任务 */
        for (int i = 0; i < 10; i++) {
            NSLog(@"下载图片%d----%@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
        dispatch_group_leave(group);
        NSLog(@"dispatch_group_leave调用了");  // for循环执行完才会执行打印
    });
    
    NSLog(@"dispatch_group_enter会不会阻塞主线程呀?");   // 不会阻塞
    
    // 会异步执行
    dispatch_async(queue, ^{
        NSLog(@"任务2");
        // 同步等待（超时5秒）
        long result = dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, 5*NSEC_PER_SEC));
        NSLog(@"dispatch_group_wait返回, %@", [NSThread currentThread]);

        if (result != 0) {
            NSLog(@"任务超时未完成");
        }
    });
}

- (void)testDispatch_group2 {
    dispatch_group_t group1 = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group1, globalQueue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"task one:%d, %@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
    });
    
    dispatch_group_async(group1, globalQueue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"task two:%d, %@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
    });
    
    // 2个任务会并发执行
    //得到线程执行完的通知
    dispatch_group_notify(group1, globalQueue, ^{
        NSLog(@"dispatch_group1_notify_completed, %@", [NSThread currentThread]);
    });
    
    dispatch_async(globalQueue, ^{
        dispatch_group_wait(group1, DISPATCH_TIME_FOREVER);
        NSLog(@"dispatch_group1_wait_completed, %@", [NSThread currentThread]);
    });

    // 第二个group,两个group会并发执行
    dispatch_group_t group2 = dispatch_group_create();
    dispatch_group_async(group2, globalQueue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"task three:%d, %@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
    });
    
    dispatch_group_async(group2, globalQueue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"task four:%d, %@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
    });
    //得到线程执行完的通知
    dispatch_group_notify(group2, globalQueue, ^{
        NSLog(@"dispatch_group2_notify_completed, %@", [NSThread currentThread]);
    });
    dispatch_async(globalQueue, ^{
        dispatch_group_wait(group2, DISPATCH_TIME_FOREVER);
        NSLog(@"dispatch_group2_wait_completed, %@", [NSThread currentThread]);
    });
}

/*
 死锁风险‌
 在串行队列（包括主队列）中嵌套调用dispatch_sync会导致死锁
 // 危险示例（主线程调用时死锁）
 dispatch_sync(dispatch_get_main_queue(), ^{  任务  });
 阻塞主线程:
 */
- (void)testBlockMainThread {
    dispatch_queue_t queue1 = dispatch_get_main_queue();
//    dispatch_sync(queue1, ^{    // 会造成死锁
//        NSLog(@"222 Hello?");
//    });
    
    NSLog(@"aaaaaaa");
}

/*
    总结:同步函数不具备开启线程的能力，无论是什么队列都不会开启线程；异步函数具备开启线程的能力，开启几条线程由队列决定（串行队列只会开启一条新的线程，并发队列会开启多条线程）。
    GCD的数据类型在ARC的环境下不需要再做release。
    CF（core Foundation）的数据类型在ARC环境下还是需要做release。
    异步函数具备开线程的能力，但不一定会开线程
    并发和并行:
        并发和并行又有区别，并行是指两个或者多个事件在同一时刻发生；而并发是指两个或多个事件在同一时间间隔内发生。
        在操作系统中，并发是指一个时间段中有几个程序都处于已启动运行到运行完毕之间，且这几个程序都是在同一个处理机上运行，但任一个时刻点上只有一个程序在处理机上运行。
     
        ①程序与计算不再一一对应，一个程序副本可以有多个计算
        ②并发程序之间有相互制约关系，直接制约体现为一个程序需要另一个程序的计算结果，间接制约体现为多个程序竞争某一资源，如处理机、缓冲区等。
        ③并发程序在执行中是走走停停，断续推进的。
*/

/*
 ‌基础特性‌
 同步执行所有迭代任务，阻塞当前线程直到所有任务完，执行指定次数的block迭代,并发队列时迭代并行执行（顺序不确定）
 迭代索引通过size_t参数传递给block，范围是[0, iterations-1]
 默认使用与当前队列优先级匹配的全局并发队列（DISPATCH_APPLY_AUTO）
 ‌‌队列行为差异‌
 ‌‌并发队列‌：迭代并行执行，顺序不确定
 ‌‌串行队列‌：退化为顺序执行，等同于for循环
 ‌‌主队列‌：导致界面卡顿，需避免直接使用
 */
- (void)test_dispatch_apply {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    NSLog(@"began");
    // 并发队列,迭代并执行，顺序不确定
    dispatch_async(queue, ^{
        dispatch_apply(1000, queue, ^(size_t iteration) {
            NSLog(@"iteration = %zd, %@", iteration, [NSThread currentThread]);
        });
        // 会在dispatch_apply任务执行完毕后才会执行
        dispatch_async(queue, ^{
            NSLog(@"dispatch_apply后面的任务, %@", [NSThread currentThread]);
        });
    });
    
    // dispatch_apply会阻塞当前线程，打印end不会立即执行。可以再包一层dispatch_async就不会阻塞
    NSLog(@"end");
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
