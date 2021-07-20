//
//  ZJUIKitTableViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/13.
//

#import "ZJUIKitTableViewController.h"
#import "UIViewController+ZJViewController.h"
#import <Vision/Vision.h>

@interface ZJUIKitTableViewController ()

@end

@implementation ZJUIKitTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
//    [self initSetting];
}

- (void)initAry {
    self.titles = @[@"ZJBarButtonItemViewController", @"ZJAlertViewController"];
    
}



- (void)initSetting {
//    NSLog(@"%s", __func__);
    
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SystemTableViewCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SystemTableViewCell];
    }
    cell.textLabel.text = self.titles[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *vcName = self.titles[indexPath.row];
    [self showVCWithName:vcName hidesBottom:YES];
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
