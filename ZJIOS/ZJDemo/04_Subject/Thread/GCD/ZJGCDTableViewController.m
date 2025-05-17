//
//  ZJGCDTableViewController.m
//  ZJFoundation
//
//  Created by YunTu on 15/8/10.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ZJGCDTableViewController.h"

@interface ZJGCDTableViewController ()

@end

@implementation ZJGCDTableViewController

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
    [self initSetting];
}

- (void)initAry {
    self.cellTitles = @[@"testGCDBasic", @"testThreadSafe", @"testDispatchSemaphore"];
    self.vcNames = @[@"ZJTestGCDBasicTableViewController", @"ZJTestThreadSafeViewController", @"ZJTestDispatchSemaphoreTableViewController"];
}

- (void)initSetting {
    
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

    NSString *name = self.vcNames[indexPath.row];
    [self showVCWithName:name];
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
