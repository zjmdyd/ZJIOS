//
//  ZJTestPreMacroTableViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/10/17.
//

#import "ZJTestPreMacroTableViewController.h"

@interface ZJTestPreMacroTableViewController ()

@end

@implementation ZJTestPreMacroTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
}

- (void)initAry {
    self.vcType = ZJBaseTableViewTypeExecute;
    self.cellTitles = @[@"__LINE__", @"__FILE__", @"__func__&&_cmd", @"空指针常量", @"设置多个target"];
    self.values = @[@"test0", @"test1", @"test2", @"test3", @"test4"];
}

//源码文件中的行号
- (void)test0 {
    NSLog(@"%d", __LINE__); // 55
}

//当前源代码文件全路径 －－>宏在预编译时会替换成当前的源文件名
- (void)test1 {
    NSLog(@"%s", __FILE__);
//    源码文件的名称
    NSLog(@"%@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent]); // ZJTestNSLogViewController.m
}

- (void)test2 {
    NSLog(@"%s", __func__);                     // -[ZJTestNSLogViewController test1]
    NSLog(@"%@", NSStringFromSelector(_cmd));   // test1
}

- (void)test3 {
    int *p = NULL, q = 10;
    p = &q;
    printf("a= %d\n", *p);
}

/*
 步骤:
 1.复制target,修改target名称
 2.Manage Scheme,修改scheme名称
 3.修改***copy-info.plist名称,再修改plist文件路径,与原来的info.plist文件路径保持一样
 4.配置plist路径，点击新的target,然后在Built Setting 中搜索 info.plist 找到配置项 修改为新info.plist的路径($(SRCROOT)/*//*/*)
 5.Build Setting搜索preprocessor Macros可配置宏
*/
- (void)test4 {
#ifdef PROD_ENV
#ifdef DEBUG
    NSLog(@"net_debug版本");
#else
    NSLog(@"net_release版本");
#endif
#else
#ifdef DEBUG
    NSLog(@"com_debug版本");
#else
    NSLog(@"com_release版本");
#endif
#endif
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
