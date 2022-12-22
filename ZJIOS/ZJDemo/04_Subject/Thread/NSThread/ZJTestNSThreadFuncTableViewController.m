//
//  ZJTestNSThreadFuncTableViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/12/16.
//

#import "ZJTestNSThreadFuncTableViewController.h"

@interface ZJTestNSThreadFuncTableViewController (){
    BOOL _threadIsValid;
}

@property (nonatomic, strong) NSThread *thread;

@end

@implementation ZJTestNSThreadFuncTableViewController


#pragma mark - UITableViewDataSource

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
    [self initSetting];
}

- (void)initAry {
    self.cellTitles = @[@"test0", @"testRestartThread"];
}

- (void)initSetting {
    //创建线程
    self.thread    = [[NSThread alloc] initWithTarget:self selector:@selector(test1) object:nil];
    _threadIsValid = YES;
    //设置线程的名称
    [self.thread setName:@"线程A"];
}


/*
 任务的执行速度的影响因素:

 CPU
 任务的复杂度
 任务的优先级
 线程的状态
 */
- (void)test0 {
    /*
        create NSThread 法1:
     */
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(thread1) object:nil];
    thread1.threadPriority = .5;
    [thread1 start];
    
    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(thread2) object:nil];
    thread2.threadPriority = .6;    // 优先级越高先执行
    [thread2 start];
}

- (void)thread1 {
    NSLog(@"thread1执行了");
}

// thread2先执行
- (void)thread2 {
    NSLog(@"thread2执行了");
}

/*
    注意：人死不能复生，线程死了也不能复生（重新开启），如果在线程死亡之后，再次尝试重新开启线程，则程序会挂。
*/
- (void)testRestartThread {
    //开启线程
//    if (_threadIsValid) {
        NSLog(@"isCancelled = %d", self.thread.isCancelled);
        NSLog(@"isExecuting = %d", self.thread.isExecuting);
        NSLog(@"isFinished = %d", self.thread.isFinished);
        [self.thread start];
//    }
    
    for (int i = 0; i < 100; i++) {
        NSLog(@"i*i = %d", i*i);    // 子线程阻塞/睡眠 不会影响主线程
    }
}

- (void)test1 {
    //获取线程
    NSThread *current = [NSThread currentThread];
    NSLog(@"test---打印线程---%@", self.thread.name);
    NSLog(@"test---线程开始---%@", current.name);

    //设置线程阻塞1，阻塞2秒
//    NSLog(@"接下来，线程阻塞2秒");
//    [NSThread sleepForTimeInterval:2.0];

    //第二种设置线程阻塞，以当前时间为基准阻塞4秒
    NSLog(@"接下来，子线程阻塞4秒");
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:4.0];
    [NSThread sleepUntilDate:date];
    
    for (int i = 0; i < 20; i++) {
        NSLog(@"线程--%d--%@",i, current.name);
        if (5 == i) {
            _threadIsValid = NO;
            //结束线程: 当当前线程死亡之后,这个线程中的代码都不会被执行.
            [NSThread exit];
        }
    }
    NSLog(@"test---线程结束---%@", current.name);   // 不会执行，因为执行过[NSThread exit]方法
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
