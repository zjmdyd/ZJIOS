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
 
 参数说明：
 
 queue：队列
 
 block：任务
 
 （2）用异步的方式执行任务 dispatch_async(dispatch_queue_t queue, dispatch_block_t block);
 
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
    [self initSetting];
}

- (void)initAry {
    self.cellTitles = @[@"test0", @"test1", @"test2", @"test3", @"test4", @"test5", @"testDispatch_group", @"testDispatch_group2", @"testBlockMainThread", @"test_dispatch_apply"];
}

- (void)initSetting {
    
}

/*
    用异步函数往并发队列中添加任务
    同时开启三个子线程:3个子线程会 并发执行
 */
- (void)test0 {
    //1.获得全局的并发队列 : 使用dispatch_get_global_queue函数获得全局的并发队列
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //2.添加任务到队列中，就可以执行任务
    //异步函数：具备开启新线程的能力
    dispatch_async(queue, ^{
        for (int i = 0; i < 100; i++) {
            NSLog(@"下载图片1----%@", [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 100; i++) {
            NSLog(@"下载图片2----%@", [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 100; i++) {
            NSLog(@"下载图片3----%@", [NSThread currentThread]);
        }
    });
    
    //执行主线程:异步任务不会阻塞主线程
    NSLog(@"主线程----%@", [NSThread mainThread]);
}

/*
    用异步函数往并发队列中添加任务
    同时开启三个子线程:3个子线程会 并发执行
 */
- (void)test1 {
    //1.获得全局的并发队列 : 使用dispatch_get_global_queue函数获得全局的并发队列
    dispatch_queue_t queue1 =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //2.添加任务到队列中，就可以执行任务
    //异步函数：具备开启新线程的能力
    dispatch_async(queue1, ^{
        for (int i = 0; i < 100; i++) {
            NSLog(@"下载图片1----%@", [NSThread currentThread]);
        }
    });
    dispatch_async(queue1, ^{
        for (int i = 0; i < 100; i++) {
            NSLog(@"下载图片2----%@", [NSThread currentThread]);
        }
    });
// DISPATCH_QUEUE_PRIORITY_LOW并不会让该任务放在最后执行,同样是会并发执行
    dispatch_queue_t queue2 =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_async(queue2, ^{
        for (int i = 0; i < 100; i++) {
            NSLog(@"下载图片3----%@", [NSThread currentThread]);
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
        for (int i = 0; i < 100; i++) {
            NSLog(@"下载图片1----%@", [NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 100; i++) {
            NSLog(@"下载图片2----%@", [NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 100; i++) {
            NSLog(@"下载图片3----%@", [NSThread currentThread]);
        }
    });
    
    //执行主线程
    NSLog(@"主线程----%@", [NSThread mainThread]);
    
    //3.释放资源 (MRC)
    // dispatch_release(queue);
}

/*
    用同步函数往并发队列中添加任务
    不会开启新的线程，并发队列失去了并发的功能
 */
- (void)test3 {
    //创建并行队列
    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //2.添加任务到队列中执行
    dispatch_sync(queue, ^{
        for (int i = 0; i < 100; i++) {
            NSLog(@"下载图片1----%@", [NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 100; i++) {
            NSLog(@"下载图片2----%@", [NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 100; i++) {
            NSLog(@"下载图片3----%@", [NSThread currentThread]);
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
        NSLog(@"下载图片1----%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"下载图片2----%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"下载图片3----%@", [NSThread currentThread]);
    });
    
    //执行主线程
    NSLog(@"主线程----%@",[NSThread mainThread]);
}

/*
    异步线程和同步线程混合使用
 */
- (void)test5 {
    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);    // 都在主线程里面执行

    dispatch_async(queue, ^{
        //2.添加任务到队列中执行:三个线程1、2、3串行执行
        dispatch_sync(queue, ^{
            for (int i = 0; i < 100; i++) {
                NSLog(@"下载图片1----%@", [NSThread currentThread]);
            }
        });
        dispatch_sync(queue, ^{
            for (int i = 0; i < 100; i++) {
                NSLog(@"下载图片2----%@", [NSThread currentThread]);
            }
        });
        dispatch_sync(queue, ^{
            for (int i = 0; i < 100; i++) {
                NSLog(@"下载图片3----%@", [NSThread currentThread]);
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
        for (int i = 0; i < 10; i++) {
            NSLog(@"task one");
        }
    });
    
    dispatch_group_async(group, globalQueue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"task two");
        }
    });
    
    dispatch_group_async(group, globalQueue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"task three");
        }
    });
    
    // 3个任务会并发执行
    //得到线程执行完的通知
    dispatch_group_notify(group, globalQueue, ^{
        NSLog(@"dispatch_group_notify_completed");
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"dispatch_group_wait_completed");

    dispatch_async(globalQueue, ^{
        NSLog(@"task four");    // dispatch_group_wait_completed 之后才执行
    });
    // 因为你在使用的是同步的 dispatch_group_wait ，它会阻塞当前线程，所以你要用 dispatch_async 将整个方法放入后台队列以避免阻塞主线程。
    // 输出的顺序与添加进队列的顺序无关，因为队列是Concurrent Dispatch Queue，但“dispatch_group_wait_completed”的输出一定是在后面的
}

- (void)testDispatch_group2 {
    dispatch_group_t group1 = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group1, globalQueue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"task one");
        }
    });
    
    dispatch_group_async(group1, globalQueue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"task two");
        }
    });
    
    // 2个任务会并发执行
    //得到线程执行完的通知
    dispatch_group_notify(group1, globalQueue, ^{
        NSLog(@"dispatch_group1_notify_completed");
    });
    
    dispatch_group_wait(group1, DISPATCH_TIME_FOREVER);
    NSLog(@"dispatch_group1_wait_completed");

    // 第二个group
    dispatch_group_t group2 = dispatch_group_create();
    dispatch_group_async(group2, globalQueue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"task three");
        }
    });
    
    dispatch_group_async(group2, globalQueue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"task four");
        }
    });
    //得到线程执行完的通知
    dispatch_group_notify(group2, globalQueue, ^{
        NSLog(@"dispatch_group2_notify_completed");
    });
}

/*
 阻塞主线程:
 */
- (void)testBlockMainThread {
    dispatch_queue_t queue1 = dispatch_get_main_queue();
    dispatch_sync(queue1, ^{    // 会造成死锁
        NSLog(@"222 Hello?");
    });
    
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

- (void)test_dispatch_apply {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    NSLog(@"began");
    dispatch_apply(10, queue, ^(size_t iteration) {
        NSLog(@"iteration = %zd, %@", iteration, [NSThread currentThread]);
    });
    
    // dispatch_apply会阻塞当前线程，打印end不会立即执行。
    NSLog(@"end");
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *funcName = self.cellTitles[indexPath.row];
    SEL sel = NSSelectorFromString(funcName);
    if (indexPath.item == 3 || indexPath.item == 6 || indexPath.item == 7) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self performSelector:sel];
        });
    }else {
        [self performSelector:sel];
    }
    
    NSLog(@"如果执行的任务为同步任务，则需要用异步函数,否则会阻塞主线程方法");
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
