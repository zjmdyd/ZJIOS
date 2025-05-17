//
//  ZJTestDocumentTableViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/5/2.
//

#import "ZJTestDocumentTableViewController.h"
#import "UITableView+ZJTableView.h"
#import "ZJScrollViewDefines.h"
#import "NSObject+ZJDocument.h"

@interface ZJTestDocumentTableViewController ()

@end

@implementation ZJTestDocumentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
}

- (void)initAry {
    self.vcType = ZJBaseTableViewTypeExecute;
    self.cellTitles = @[@[@"NSHomeDirectory", @"sandbox", @"测试完整路径"], @[@"写入和读取文件", @"删除文件", @"加密文件名写入", @"加密文件名删除"], @[@"writeToFile:atomically:"], @[@"test .csv"], @[@"NSJSONWritingOptions/NSJSONReadingOptions"]];
    self.values = @[@[@"test0", @"test1", @"test2"], @[@"test3", @"test4", @"test5", @"test6"], @[@"test7"], @[@"test8"], @[@"test9"]];
}

/*
 Documents: 这个目录存放用户数据。存放用户可以管理的文件；iTunes备份和恢复的时候会包括此目录。
 Library: 主要使用它的子文件夹,我们熟悉的NSUserDefaults就存在于它的子目录中。
 Library/Caches: 存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出删除,“删除缓存”一般指的就是清除此目录下的文件。
 Library/Preferences: NSUserDefaults的数据存放于此目录下。
 tmp: App应当负责在不需要使用的时候清理这些文件，系统在App不运行的时候也可能清理这个目录
 */

/* 沙盒路径
 2022-08-16 14:47:14.171234+0800 ZJIOS[5308:109356] homePath = /Users/issuser/Library/Developer/CoreSimulator/Devices/832358D8-0054-40F6-97D1-EF1BD0563E2F/data/Containers/Data/Application/4C7E001A-1B39-44C8-A1B0-928F524D5369
 2022-08-16 14:47:14.171803+0800 ZJIOS[5308:109356] NSDocumentDirectory = (
     "/Users/issuser/Library/Developer/CoreSimulator/Devices/832358D8-0054-40F6-97D1-EF1BD0563E2F/data/Containers/Data/Application/4C7E001A-1B39-44C8-A1B0-928F524D5369/Documents"
 )
 2022-08-16 14:47:14.172098+0800 ZJIOS[5308:109356] NSLibraryDirectory = (
     "/Users/issuser/Library/Developer/CoreSimulator/Devices/832358D8-0054-40F6-97D1-EF1BD0563E2F/data/Containers/Data/Application/4C7E001A-1B39-44C8-A1B0-928F524D5369/Library"
 )
 2022-08-16 14:47:14.172566+0800 ZJIOS[5308:109356] NSCachesDirectory = (
     "/Users/issuser/Library/Developer/CoreSimulator/Devices/832358D8-0054-40F6-97D1-EF1BD0563E2F/data/Containers/Data/Application/4C7E001A-1B39-44C8-A1B0-928F524D5369/Library/Caches"
 2022-08-16 14:47:14.172311+0800 ZJIOS[5308:109356] tmpDir = /Users/issuser/Library/Developer/CoreSimulator/Devices/832358D8-0054-40F6-97D1-EF1BD0563E2F/data/Containers/Data/Application/4C7E001A-1B39-44C8-A1B0-928F524D5369/tmp/

 )
 */
/*
 NSArray<NSString *> * NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory directory, NSSearchPathDomainMask domainMask, BOOL expandTilde);
 directory    NSSearchPathDirectory    指定系统目录类型（如文档、缓存等）
 domainMask    NSSearchPathDomainMask    限定搜索范围（通常用NSUserDomainMask表示用户目录）
 expandTilde    BOOL    是否展开波浪符~为完整路径（建议设为YES）
 */

- (void)test0 {
    NSString *path = NSHomeDirectory();
    NSLog(@"homePath = %@", path);
    NSLog(@"NSUserName = %@", NSUserName());    // Returns the logon name of the current user.
    NSLog(@"NSFullUserName = %@", NSFullUserName());    // Returns a string containing the full name of the current user.
    // 与下面的tmpDir是一个东西
    NSLog(@"NSTemporaryDirectory = %@", NSTemporaryDirectory());    // Returns the path of the temporary directory for the current user.
    NSLog(@"NSOpenStepRootDirectory = %@", NSOpenStepRootDirectory());  // A string identifying the root directory of the user’s system.
    
    NSArray *ary0 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSArray *ary1 = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSArray *ary2 = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *tmpDir = NSTemporaryDirectory();
    NSLog(@"NSDocumentDirectory = %@", ary0);
    NSLog(@"NSLibraryDirectory = %@", ary1);
    NSLog(@"NSCachesDirectory = %@", ary2);
    NSLog(@"tmpDir = %@", tmpDir);
}

- (void)test1 {
    [self showVCWithName:@"ZJTestSandboxViewController"];
}

/* 测试是否显示完整路径
   路径前缀都是一样的,都是NSHomeDirectory()

 2022-05-02 11:38:25.366239+0800 ZJIOS[18084:474839] ary0 = (
     "/Users/issuser/Library/Developer/CoreSimulator/Devices/85CBF745-8847-4843-95E6-D53262D1B3D9/data/Containers/Data/Application/487B0709-B902-4AE1-80A9-E29C6FC51407/Documents"
 )
 2022-05-02 11:38:25.366426+0800 ZJIOS[18084:474839] ary1 = (
     "~/Documents"
 )
 */
- (void)test2 {
    NSArray *ary0 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSArray *ary1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, NO);
    NSLog(@"ary0 = %@", ary0);
    NSLog(@"ary1 = %@", ary1);
}

- (void)test3 {
//    NSArray *strs = @[@"helloWorld"];
    NSString *strs = @"helloWorld";
    
    // 写入文件
    [strs writeToFileWithPathComponent:@"hello" suffix:@".json"];
    
    // 读取文件
    id value = [NSObject readFileWithPathComponent:@"hello" suffix:@".json"];
    NSLog(@"value = %@", value);
}

- (void)test4 {
    // 删除文件
    [NSObject removeFileWithPathComponent:@"hello" suffix:@".json"];
}

- (void)test5 {
    NSArray *strs = @[@"helloWorld"];
//    NSString *strs = @"helloWorld";
    NSLog(@"isValidJSONObject = %d", [NSJSONSerialization isValidJSONObject:strs]);
    
    // 写入文件, 文件名加密
    [strs writeToFileWithPathComponent:@"hello" needEncodeFileName:YES suffix:@".json"];
    
    // 读取文件
    id value = [NSObject readFileWithPathComponent:@"hello" needEncodFileName:YES suffix:@".json"];
    NSLog(@"value = %@", value);
}

- (void)test6 {
    // 删除文件, 文件名加密
    [NSObject removeFileWithPathComponent:@"hello" needEncodFileName:YES suffix:@".json"];
}

/*
 atomically：这个参数意思是如果为YES则保证文件的写入原子性,就是说会先创建一个临时文件,直到文件内容写入成功再导入到目标文件里.
 */
- (void)test7 {
    NSDictionary *dic = @{@"key_1" : @"value_1"};
    
    ZJDocumentWriteCofig *config = [ZJDocumentWriteCofig new];
    config.fileName = @"testUseAuxiliaryFile";
    config.documentType = ZJDocumentTypeJson;
    [dic writeToFileWithDocumentConfig:config atomicallyType:YES atomically:YES];
    
    // 读取文件
    id value = [NSObject readFileWithPathComponent:@"testUseAuxiliaryFile" suffix:@".json"];
    NSLog(@"value = %@", value);
}

/*
 CSV，即逗号分隔值（Comma-Separated Values）。有时也称为字符分隔值，因为分隔字符也可以不是逗号，可以是分号;），其文件以纯文本形式存储表格数据（数字和文本）。
 这种文件格式经常用来作为不同程序之间的数据交互的格式。
 CSV格式数据的结构类似表格，不同的记录占用一行，一行中的字段用“，”（逗号）分隔。
 在xcode中, csv格式的文件是一种占内存很小的文本文档,它的特点:

 开头是不留空 ，以行为单位。
 每条记录占一行，以逗号为分隔符。列为空也要表达其存在。
 可含或不含列名，如果含列名则居文件第一行。
 一行数据不跨行，无空行。
 字段中包含有逗号符，该字段必须用双引号括起来。
 字段中包含有换行符，该字段必须用双引号括起来。
 字段前后包含有空格，该字段必须用双引号括起来。（ a b c ==> "a b c"）
 字段中如果有双引号，该字段必须用双引号括起来。（ 我说："abc"。 ==> "我说：""abc"""。)
 */
- (void)test8 {
    NSString *str = @"11111,22222,33333,44444\n";
    NSMutableString *csvString = [NSMutableString string];
    for (int i = 0; i< 10; i ++) {
         [csvString appendString:str];
    }
    
    NSString *fileNameStr = @"likee.csv";
    NSString *docPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileNameStr];
    NSLog(@"docPath:%@", docPath);
    
    NSData *data = [csvString dataUsingEncoding:NSUTF8StringEncoding];
    [data writeToFile:docPath atomically:YES];
}

/*
 一、NSJSONReadingOptions 主要枚举值及作用
 ‌‌选项‌    ‌作用‌    ‌兼容性‌
 NSJSONReadingMutableContainers    返回的可变容器（NSMutableDictionary/NSMutableArray）    iOS 5.0+ / macOS 10.7+
 NSJSONReadingMutableLeaves    返回的字符串为 NSMutableString 类型（实际效果有限，iOS 7+ 可能无效）    iOS 5.0+
 NSJSONReadingAllowFragments    允许顶层对象为非容器类型（如字符串、数字等有效 JSON 片段）    iOS 5.0+
 NSJSONReadingJSON5Allowed      是iOS 15+/macOS 12.0+ 引入的 NSJSONReadingOptions 枚举选项，用于支持解析符合 JSON5 规范的扩展格式数据。
 NSJSONReadingTopLevelDictionaryAssumed 是 iOS 15+/macOS 12.0+ 引入的 NSJSONReadingOptions 新选项，用于优化 JSON 解析时的类型推断逻辑。其
 
 NSJSONReadingJSON5Allowed 功能特性:
 ‌‌宽松语法支持‌
 允许单行（//）和多行()注释
 键名可不加引号或使用单引号（如 {name: "Alice"}）
 支持数字增强格式（如 .5、0xFF、Infinity）
 ‌‌兼容性扩展‌
 尾随逗号（如 [1, 2,]）和字符串换行
 顶层可解析非容器类型（类似 NSJSONReadingAllowFragments）
 
 NSJSONReadingTopLevelDictionaryAssumed 功能特性:
 ‌‌类型推断优化‌
 当 JSON 数据实际为字典但未显式指定返回类型时，自动假定顶层对象为 NSDictionary 而非 NSArray35
 避免因类型不匹配导致的强制类型转换崩溃1
 ‌‌性能提升‌
 减少运行时类型检查开销，解析速度提升约 5-10%（实测数据）
 
 二、使用场景对比
 ‌‌可变容器需求‌
 若需修改解析后的字典/数组，必须使用 NSJSONReadingMutableContainers，否则直接修改会触发异常,     但很多时候是不需要改变的
 ‌非标准 JSON 解析‌
 当 JSON 最外层是单个字符串或数字时，需启用 NSJSONReadingAllowFragments
 字符串可变性‌
 NSJSONReadingMutableLeaves 理论上可使字符串可变，但实际测试中可能无效（依赖系统版本)
 三、注意事项
 ‌‌默认行为‌：不指定选项时（options: []），返回的容器和字符串均为不可变对象。
 ‌‌错误处理‌：解析失败会抛出 NSError，建议配合 try-catch 使用。
 ‌‌组合使用‌：多个选项可通过按位或（|）组合，如 [.mutableContainers, .allowFragments]
 */

// 测试序列化非数组和字典对象
// NSJSONWritingPrettyPrinted crash
// NSJSONWritingSortedKeys crash
// NSJSONWritingFragmentsAllowed ok
// NSJSONWritingWithoutEscapingSlashes  crash
- (void)test9 {
    NSError *wError;
    NSData *value =  [NSJSONSerialization dataWithJSONObject:@{@"key": @"name", @"value": @"张三"} options:NSJSONWritingFragmentsAllowed error:&wError];
    NSLog(@"value = %@", value);
    if (!wError) {
        NSLog(@"序列化成功");
    }else {
        NSLog(@"序列化失败:%@", wError);
    }
    NSError *rError;
    id obj = [NSJSONSerialization JSONObjectWithData:value options:NSJSONReadingMutableContainers error:&rError];
    NSLog(@"obj = %@", obj);
    if (!rError) {
        NSLog(@"反序列化成功");
    }else {
        NSLog(@"反序列化失败:%@", rError);
    }
//    [value writeToFileWithPathComponent:@"dataWriteFragmentsAllowed" suffix:@"json"];
//    id back = [NSObject readFileWithPathComponent:@"dataWriteFragmentsAllowed" suffix:@"json"];
//    NSLog(@"data_back = %@", back);     // data_back = 1
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
