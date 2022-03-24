//
//  ZJTestGCDTimerTableViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/1/27.
//

#import "ZJTestGCDTimerTableViewController.h"

@interface ZJTestGCDTimerTableViewController ()

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation ZJTestGCDTimerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test2];
}

- (void)test2 {
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    
    //开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC);
    /** 设置定时器
     * para2: 任务开始时间
     * para3: 任务的间隔
     * para4: 可接受的误差时间，设置0即不允许出现误差
     * Tips: 单位均为纳秒
     */
    dispatch_source_set_timer(timer, start, 1.0 * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
    /** 设置定时器任务
     * 可以通过block方式
     * 也可以通过C函数方式
     */
    dispatch_source_set_event_handler(timer, ^{
        static int index = 0;
        NSLog(@"index: %d", index++);
        NSLog(@"%@", [NSThread currentThread]);
        
        if(index == 5) {
            //终止定时器(如果没有终止方法,则定时器不会启动)
            dispatch_suspend(timer);
        }
    });
    //启动任务，GCD计时器创建后需要手动启动
    dispatch_resume(timer);
}

/*
 GCD定时器完全不受runloop影响，也就是说不会收到手势和UI刷新影响。所以它比NSTimer 更加准确
 */
- (void)test1 {
    static int count = 0;
    // 获得队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 创建一个定时器
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    uint64_t interval = 1.0 * NSEC_PER_SEC;
    dispatch_source_set_timer(self.timer, start, interval, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        NSLog(@"currentThread = %@", [NSThread currentThread]);
        count++;
        if (count == 10) {
            dispatch_cancel(self.timer);
        }
    });
    // 启动
    dispatch_resume(self.timer);
}

/*
 SEC   秒
 PER   每
 NSEC 纳秒
 MSEC 毫秒
 USEC 微秒
 
 #define NSEC_PER_SEC 1000000000ull     // 1秒       1秒=10亿纳秒
 #define NSEC_PER_MSEC 1000000ull       // 1毫秒      1毫秒=100万纳秒
 #define USEC_PER_SEC 1000000ull        // 1毫秒      1秒=100万微秒
 #define NSEC_PER_USEC 1000ull          // 1微秒      1微秒=1000纳秒
 */

- (void)test0 {
    bool a = (NSEC_PER_SEC == NSEC_PER_MSEC*1000);  // 秒<--毫秒
    NSLog(@"a = %d", a);    // a = 1
    
    bool b = (NSEC_PER_SEC == USEC_PER_SEC*1000);   //
    NSLog(@"b = %d", b);    // b = 1
    
    bool c = (NSEC_PER_SEC == NSEC_PER_USEC*1000*1000); // 秒<--微秒
    NSLog(@"c = %d", c);    // c = 1
    
    bool d = (NSEC_PER_MSEC == USEC_PER_SEC);   // 毫秒<--毫秒
    NSLog(@"d = %d", d);    // d = 1
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SystemTableViewCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SystemTableViewCell];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%zd行", indexPath.row];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)dealloc {
    NSLog(@"%s", __func__);
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
