//
//  ZJNSOperationViewController.m
//  ZJFoundation
//
//  Created by YunTu on 15/8/10.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ZJNSOperationViewController.h"

@interface ZJNSOperationViewController ()

@end

@implementation ZJNSOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%s", __func__);
    [self initAry];
}

- (void)initAry {
    self.vcType = ZJBaseTableViewTypeExecute;
    self.cellTitles = @[@"test0", @"test1", @"test2", @"test3", @"test4", @"test5", @"test6"];
}

/*
 延时的代码放在主线程的话会造成主界面延时加载, 即for循环结束之后(viewDidLoad ---> viewDidAppear方法)页面才显示出来
 */
- (void)test0 {
    [self run:@"线程0"];
}

/*
 NSOperation是抽象类, 系统定义的两个子类:NSBlockOperation / NSInvocationOperation
 */
- (void)test1 {
    // 但也不会报错,只是无法实现功能
    NSOperation *op = [[NSOperation alloc] init];
    [op start];
}

// NSBlockOperation
- (void)test2 {
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        [self run:@"线程1"];
    }];
    // 监听任务完成,需要在调用start方法之前实现监听方法,否则无效
    op1.completionBlock = ^{
        NSLog(@"Operation1 finished");
    };
    [op1 start];    // 直接调用start方法,会在当前线程执行,如在主线程调用则会阻塞主线程
}

// NSInvocationOperation
- (void)test3 {
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run:) object:@"线程2"];
    // 监听任务完成,需要在调用start方法之前实现监听方法,否则无效
    op2.completionBlock = ^{
        NSLog(@"Operation2 finished");
    };
    [op2 start];     // 直接调用start方法,会在当前线程执行,如在主线程调用则会阻塞主线程
}
/*
 注意事项:
 避免直接调用 start‌：除非明确需同步执行，否则应通过队列管理。
 ‌‌资源释放‌：取消操作时需在 main 方法中检查 isCancelled。
 ‌‌主线程更新‌：通过 [NSOperationQueue mainQueue] 返回主队列更新 UI
 */

/*
 结合 NSOperationQueue 使用, 队列会自动管理操作的执行顺序和线程分配
 可以一边加载页面(在主线程执行), 一边执行子线程的事件,页面返回线程也不会停止,线程执行完页面才会销毁
 */
- (void)test4 {
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"self = %@", self);
        [self run:@"线程1"];
    }];
    op1.queuePriority = NSOperationQueuePriorityVeryLow;

    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run:) object:@"线程2"];
    // 设置优先级,在并发队列里面还是会交叉运行
    op2.queuePriority = NSOperationQueuePriorityVeryHigh;
    /*
        线程队列：NSOperationQueue, opration添加到队列当中时,此线程开始执行
     */
    NSOperationQueue *myQ = [[NSOperationQueue alloc] init];
    // 设置最大允许同时执行的线程数, 设为1即为串行,哪个线程先进队列就先执行完,再执行后面的进程
    [myQ setMaxConcurrentOperationCount:2];
    [myQ addOperation:op1];
    [myQ addOperation:op2];
}

// 控制任务依赖: addDependency
- (void)test5 {
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        [self run:@"线程1"];
    }];
    
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run:) object:@"线程2"];
    /*
        线程队列：NSOperationQueue, opration添加到队列当中时,此线程开始执行
     */
    NSOperationQueue *myQ = [[NSOperationQueue alloc] init];
    // 设置最大允许同时执行的线程数, 设为1即为串行,哪个线程先进队列就先执行完,再执行后面的进程
    [myQ setMaxConcurrentOperationCount:1];
    
    /*
        添加依赖:先执行op2, op2执行完之后再执行op1
        注意:添加依赖必须在线程加进线程队列之前执行才有效果
     */
    [op1 addDependency:op2];
    // 批量添加, 参数2:If YES, the current thread is blocked until all of the specified operations finish executing
    [myQ addOperations:@[op1, op2] waitUntilFinished:NO];
}

- (void)run:(NSString *)msg {
    for (int i = 0; i < 5; i++) {
        [NSThread sleepForTimeInterval:1];
        NSLog(@"%@", msg);
    }
}

- (void)test6 {
    [self showVCWithNibName:@"ZJNSOperationDownLoaderDemoVC"];
}

/*
 -[ZJNSOperationViewController viewDidLoad]
 -[ZJNSOperationViewController viewWillAppear:]
 -[ZJNSOperationViewController viewDidAppear:]
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s", __func__);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%s", __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
