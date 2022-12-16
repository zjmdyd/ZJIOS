//
//  ZJGCDViewController.m
//  ZJFoundation
//
//  Created by YunTu on 15/8/10.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ZJGCDViewController.h"

@interface ZJGCDViewController () {
    BOOL _threadIsValid;
}

@property (nonatomic, strong) NSThread *thread;
@property (atomic, strong) NSString *target;

@end

@implementation ZJGCDViewController

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
    self.cellTitles = @[@"testThreadRestart", @"test0", @"test1", @"test2", @"test3", @"test4", @"test5", @"testDispatch_group", @"testDispatchAfter", @"testBlockMainThread", @"test6"];
}

- (void)initSetting {
    //创建线程
    self.thread    = [[NSThread alloc] initWithTarget:self selector:@selector(test0) object:nil];
    _threadIsValid = YES;
    //设置线程的名称
    [self.thread setName:@"线程A"];
}

/*
    当手指按下的时候，开启线程
    注意：人死不能复生，线程死了也不能复生（重新开启），如果在线程死亡之后，再次点击屏幕尝试重新开启线程，则程序会挂。
*/
- (void)testThreadRestart {
    //开启线程
    if (_threadIsValid) {
        [self.thread start];
    }
    
    for (int i = 0; i < 100; i++) {
        NSLog(@"i*i = %d", i*i);    // 子线程阻塞/睡眠 不会影响主线程
    }
}

- (void)test0 {
    //获取线程
    NSThread *current = [NSThread currentThread];
    NSLog(@"test---打印线程---%@", self.thread.name);
    NSLog(@"test---线程开始---%@", current.name);

    //设置线程阻塞1，阻塞2秒
    NSLog(@"接下来，线程阻塞2秒");
//    [NSThread sleepForTimeInterval:2.0];

    //第二种设置线程阻塞2，以当前时间为基准阻塞4秒
    NSLog(@"接下来，线程阻塞4秒");
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:2.0];
    [NSThread sleepUntilDate:date];
    
    for (int i = 0; i < 20; i++) {
        NSLog(@"线程--%d--%@",i, current.name);
        if (5 == i) {
            _threadIsValid = NO;
            //结束线程: 当当前线程死亡之后,这个线程中的代码都不会被执行.
            [NSThread exit];
        }
    }
    NSLog(@"test---线程结束---%@", current.name);
}

/*
    用异步函数往并发队列中添加任务
    同时开启三个子线程:3个子线程会 并发执行
 */
- (void)test1 {
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
    
    //打印主线程
    NSLog(@"主线程----%@", [NSThread mainThread]);
}

/*
    用异步函数往串行队列中添加任务
    会开启线程，但是只开启一个线程,3个任串行执行
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
    
    //打印主线程
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
    
    //打印主线程
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
    
    //打印主线程
    NSLog(@"主线程----%@",[NSThread mainThread]);
}

/*
    异步线程和同步线程混合使用
 */
- (void)test5 {
    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);    // 都在主线程里面执行

    dispatch_async(queue, ^{
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
    });
    
    //打印主线程
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
    
    //得到线程执行完的通知
    dispatch_group_notify(group, globalQueue, ^{
        NSLog(@"completed");
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"completed2");

    dispatch_async(globalQueue, ^{
        NSLog(@"task four");    // completed2之后才执行
    });
    // 因为你在使用的是同步的 dispatch_group_wait ，它会阻塞当前线程，所以你要用 dispatch_async 将整个方法放入后台队列以避免阻塞主线程。
    // 输出的顺序与添加进队列的顺序无关，因为队列是Concurrent Dispatch Queue，但“completed”的输出一定是在最后的：
}

- (void)testDispatchAfter {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));    // 1 NSEC_PER_SEC表示的是秒数，它还提供了NSEC_PER_MSEC表示毫秒
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){                                 // 2
        [self.navigationItem setPrompt:@"Add photos with faces to Googlyify them!"];
    });
}

/*
 阻塞主线程:
 */
- (void)testBlockMainThread {
    dispatch_queue_t queue1 = dispatch_get_main_queue();
    dispatch_sync(queue1, ^{
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


/**
 *  网易面试题
 */
- (void)test6 {
    NSLog(@"c1 = %@", [NSThread currentThread]);    // name = main
    dispatch_queue_t queue = dispatch_queue_create("parallel", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i < 1000 ; i++) {
//        NSLog(@"ci = %@", [NSThread currentThread]);

        dispatch_async(queue, ^{
            NSLog(@"cj = %@", [NSThread currentThread]);

            self.target = [NSString stringWithFormat:@"ksddkjalkjd%d", i];
        });
    }
    NSLog(@"c2 = %@", [NSThread currentThread]);    // name = main,
    NSLog(@"结束");
}
/**
 噢，看来是对已释放的对象再次发送了release信息。
 
 我又留意到，这个对象是Strong修饰的。
 
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
    if (indexPath.item == 7) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self performSelector:sel];
        });
    }else {
        [self performSelector:sel];
    }
    
    NSLog(@"执行多线程方法");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
