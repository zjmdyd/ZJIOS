//
//  ZJTestDocumentTableViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/5/2.
//

#import "ZJTestDocumentTableViewController.h"
#import "UIViewController+ZJViewController.h"
#import "UITableView+ZJTableView.h"
#import "ZJScrollViewDefines.h"
#import "NSObject+ZJDocument.h"

@interface ZJTestDocumentTableViewController ()

@end

@implementation ZJTestDocumentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
    [self initSetting];
}

- (void)initAry {
    
}

- (void)initSetting {
    self.cellTitles = @[@[@"sandbox"], @[@"测试完整路径"], @[@"写入文件", @"删除文件", @"加密文件名写入", @"加密文件名删除"]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *ary = self.cellTitles[section];
    return ary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZJBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SystemTableViewCell];
    if (!cell) {
        cell = [[ZJBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SystemTableViewCell];
    }
    NSArray *ary = self.cellTitles[indexPath.section];
    cell.textLabel.text = ary[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DefaultCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return DefaultSectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return DefaultSectionHeaderHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *selString = [NSString stringWithFormat:@"test%zd", indexPath.section + indexPath.row];
    SEL sel = NSSelectorFromString(selString);
    
    if ([self respondsToSelector:sel]) {
        NSLog(@"有此方法:%@", selString);
        [self performSelector:sel];
    }else {
        NSLog(@"无此方法:%@", selString);
    }
}

/*
 Documents: 这个目录存放用户数据。存放用户可以管理的文件；iTunes备份和恢复的时候会包括此目录。
 Library: 主要使用它的子文件夹,我们熟悉的NSUserDefaults就存在于它的子目录中。
 Library/Caches: 存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出删除,“删除缓存”一般指的就是清除此目录下的文件。
 Library/Preferences: NSUserDefaults的数据存放于此目录下。
 tmp: App应当负责在不需要使用的时候清理这些文件，系统在App不运行的时候也可能清理这个目录
 */

/* 沙盒路径
 2022-05-02 11:41:22.659609+0800 ZJIOS[18154:477658] homePath = /Users/issuser/Library/Developer/CoreSimulator/Devices/85CBF745-8847-4843-95E6-D53262D1B3D9/data/Containers/Data/Application/E98F6EE0-87DD-4AB0-9F4E-8563C3BF7B8E
 2022-05-02 11:41:22.659861+0800 ZJIOS[18154:477658] NSCachesDirectory = (
     "/Users/issuser/Library/Developer/CoreSimulator/Devices/85CBF745-8847-4843-95E6-D53262D1B3D9/data/Containers/Data/Application/E98F6EE0-87DD-4AB0-9F4E-8563C3BF7B8E/Library/Caches"
 )
 2022-05-02 11:41:22.659983+0800 ZJIOS[18154:477658] NSLibraryDirectory = (
     "/Users/issuser/Library/Developer/CoreSimulator/Devices/85CBF745-8847-4843-95E6-D53262D1B3D9/data/Containers/Data/Application/E98F6EE0-87DD-4AB0-9F4E-8563C3BF7B8E/Library"
 )
 2022-05-02 11:41:22.660089+0800 ZJIOS[18154:477658] tmpDir = /Users/issuser/Library/Developer/CoreSimulator/Devices/85CBF745-8847-4843-95E6-D53262D1B3D9/data/Containers/Data/Application/E98F6EE0-87DD-4AB0-9F4E-8563C3BF7B8E/tmp/
 */
- (void)test0 {
    NSString *path = NSHomeDirectory();
    NSLog(@"homePath = %@", path);
    
    NSArray *ary0 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSArray *ary1 = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSArray *ary2 = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *tmpDir = NSTemporaryDirectory();
    NSLog(@"NSDocumentDirectory = %@", ary0);
    NSLog(@"NSLibraryDirectory = %@", ary1);
    NSLog(@"tmpDir = %@", tmpDir);
    NSLog(@"NSCachesDirectory = %@", ary2);
    
    [self showVCWithName:@"ZJTestSandboxViewController"];
}

/* 测试是否显示完整路径
 2022-05-02 11:38:25.366239+0800 ZJIOS[18084:474839] ary0 = (
     "/Users/issuser/Library/Developer/CoreSimulator/Devices/85CBF745-8847-4843-95E6-D53262D1B3D9/data/Containers/Data/Application/487B0709-B902-4AE1-80A9-E29C6FC51407/Documents"
 )
 2022-05-02 11:38:25.366426+0800 ZJIOS[18084:474839] ary1 = (
     "~/Documents"
 )
 */
- (void)test1 {
    NSArray *ary0 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSArray *ary1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, NO);
    NSLog(@"ary0 = %@", ary0);
    NSLog(@"ary1 = %@", ary1);
}

- (void)test2 {
//    NSArray *strs = @[@"helloWorld"];
    NSString *strs = @"helloWorld";
    
    // 写入文件
    [strs writeToFileWithPathComponent:@"hello" suffix:@".json"];
    
    // 读取文件
    id value = [NSObject readFileWithPathComponent:@"hello" suffix:@".json"];
    NSLog(@"value = %@", value);
}

- (void)test3 {
    // 删除文件
    [NSObject removeFileWithPathComponent:@"hello" suffix:@".json"];
}

- (void)test4 {
    NSArray *strs = @[@"helloWorld"];
//    NSString *strs = @"helloWorld";
    NSLog(@"isValidJSONObject = %d", [NSJSONSerialization isValidJSONObject:strs]);
    
    // 写入文件, 文件名加密
    [strs writeToFileWithPathComponent:@"hello" needEncodeFileName:YES suffix:@".json"];
    
    // 读取文件
    id value = [NSObject readFileWithPathComponent:@"hello" needDeserialize:YES suffix:@".json"];
    NSLog(@"value = %@", value);
}

- (void)test5 {
    // 删除文件, 文件名加密
    [NSObject removeFileWithPathComponent:@"hello" needDeserialize:YES suffix:@".json"];
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
