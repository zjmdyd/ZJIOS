//
//  ZJTestGCDBarrierTableViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/12/19.
//

#import "ZJTestGCDBarrierTableViewController.h"

@interface ZJTestGCDBarrierTableViewController ()

@end

@implementation ZJTestGCDBarrierTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
    [self initSetting];
}

- (void)initAry {
    self.cellTitles = @[@"test0_async", @"test1_sync"];
}

- (void)initSetting {
    
}

/*
 需要注意的是queue的选择，需要是自己创建的，dispatch_queue_create并且是concurrent的queue，
 不能是serial或者全局的global concurrent queues
 */
- (void)test0 {
    NSLog(@"dispatch_barrier --- begin");
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        //追加任务1
        NSLog(@"追加任务1");
        for (int i = 0; i < 2; ++i) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:2];
            //打印当前线程
            NSLog(@"1---%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        //追加任务2
        NSLog(@"追加任务2");
        for (int i = 0; i < 2; ++i) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:2];
            //打印当前线程
            NSLog(@"2---%@",[NSThread currentThread]);
        }
    });
//    异步栅栏则跟async函数一样，开启新线程，不会阻塞当前线程
    dispatch_barrier_async(queue, ^{
        //追加栅栏函数任务
        NSLog(@"追加栅栏函数任务");
        for (int i = 0; i < 2; ++i) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:2];
            //打印当前线程
            NSLog(@"barrier---%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        //追加任务3
        NSLog(@"追加任务3");
        for (int i = 0; i < 2; ++i) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:2];
            //打印当前线程
            NSLog(@"3---%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        //追加任务4
        NSLog(@"追加任务4");
        for (int i = 0; i < 2; ++i) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:2];
            //打印当前线程
            NSLog(@"4---%@",[NSThread currentThread]);
        }
    });
    
    //不会被阻塞，不需要等待，直接执行
    NSLog(@"dispatch_barrier --- end");
}

- (void)test1 {
    NSLog(@"dispatch_barrier --- begin");
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        //追加任务1
        NSLog(@"追加任务1");
        for (int i = 0; i < 2; ++i) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:2];
            //打印当前线程
            NSLog(@"1---%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        //追加任务2
        NSLog(@"追加任务2");
        for (int i = 0; i < 2; ++i) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:2];
            //打印当前线程
            NSLog(@"2---%@",[NSThread currentThread]);
        }
    });
//  同步栅栏
    dispatch_barrier_sync(queue, ^{
        //追加栅栏函数任务
        NSLog(@"追加栅栏函数任务");
        for (int i = 0; i < 2; ++i) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:2];
            //打印当前线程
            NSLog(@"barrier---%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        //追加任务3
        NSLog(@"追加任务3");
        for (int i = 0; i < 2; ++i) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:2];
            //打印当前线程
            NSLog(@"3---%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        //追加任务4
        NSLog(@"追加任务4");
        for (int i = 0; i < 2; ++i) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:2];
            //打印当前线程
            NSLog(@"4---%@",[NSThread currentThread]);
        }
    });
    
    //同步栅栏和sync函数一样，不会开启新线程，end是在同步之后打印的
    NSLog(@"dispatch_barrier --- end");
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
