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
    /*
        延时的代码放在主线程的话会造成主界面延时加载, 即for循环结束之后(viewDidLoad ---> viewDidAppear方法)页面才显示出来
     */
    /*
    for (int i = 0; i < 5; i++) {
        [NSThread sleepForTimeInterval:1];
        NSLog(@"线程0");
    }
    */
    
    /*
        NSOperation是抽象类,系统定义的两个子类:NSBlockOperation / NSInvocationOperation
        注意线程要添
     */

    /*
        NSBlockOperation
        开启子线程:界面一边加载, 一边执行子线程
     */
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"线程1");
        }
    }];

    /*
        NSInvocationOperation
     */
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run) object:nil];
    /*
        线程队列：NSOperationQueue
        opration添加到队列当中时,此线程开始执行
     */
    NSOperationQueue *myQ = [[NSOperationQueue alloc] init];
    
    [myQ setMaxConcurrentOperationCount:1];         //  设置最大允许同时执行的线程数, 设为1即为串行,哪个线程先进队列就先执行完在执行后面的进程
    /*
        添加依赖:先执行op2, op2执行完之后再执行op1
        注意:添加依赖必须在线程加进线程队列之前执行才有效果
     */
    [op1 addDependency:op2];
    [myQ addOperation:op1];
    [myQ addOperation:op2];
}

- (void)run {
    for (int i = 0; i < 5; i++) {
        [NSThread sleepForTimeInterval:1];
        NSLog(@"线程2");
    }
}

- (void)test {
//    NSOperation *op;
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
