//
//  ZJTestJsonTableViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/5/5.
//

#import "ZJTestJsonTableViewController.h"
#import "ZJScrollViewDefines.h"
#import "NSObject+ZJDocument.h"

@interface ZJTestJsonTableViewController ()

@property (nonatomic, strong) NSArray *writeTypes;
@property (nonatomic, strong) NSArray *readTypes;

@end

@implementation ZJTestJsonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
    [self test0];
    [self test1];
    [self testStringWritingFragmentsAllowed];
//    [self testMutableLeaves];
}

/*
 NSJSONWritingPrettyPrinted = (1UL << 0) //是将生成的json数据格式化输出，这样可读性高，不设置则输出的json字符串就是一整行。(自己原生打印输出，一般选用这个可读性比较高)；
 
 NSJSONWritingSortedKeys //输出的json字符串就是一整行（如果要往后台传或者字典转json然后加密，就不能格式化，会有换行符和空格）；这个枚举是iOS11后才出的，iOS11之前我们可以用kNilOptions来替代
 
 NSJSONWritingFragmentsAllowed 允许写入片段
 
 NSJSONWritingWithoutEscapingSlashes 不转义斜线
 */

- (void)initAry {
    self.sectionTitles = @[@"NSJSONWritingPrettyPrinted", @"NSJSONWritingSortedKeys", @"NSJSONWritingFragmentsAllowed", @"NSJSONWritingWithoutEscapingSlashes"];
    self.cellTitles = @[@"", @"NSJSONReadingMutableContainers", @"NSJSONReadingMutableLeaves", @"NSJSONReadingFragmentsAllowed"];
    self.writeTypes = @[@(NSJSONWritingPrettyPrinted), @(NSJSONWritingSortedKeys), @(NSJSONWritingFragmentsAllowed), @(NSJSONWritingWithoutEscapingSlashes)];
    self.readTypes = @[@(NSJSONReadingMutableContainers), @(NSJSONReadingMutableLeaves), @(NSJSONReadingFragmentsAllowed)];
}

- (void)test0 {
    NSLog(@"self.writeTypes = %@", self.writeTypes);
    
    NSData *data = [@"hhhh" dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"data_isValidJSONObject = %d", [NSJSONSerialization isValidJSONObject:data]);   // data_isValidJSONObject = 0
}

// 测试序列化非数组和字典对象
// NSJSONWritingPrettyPrinted crash
// NSJSONWritingFragmentsAllowed ok
- (void)test1 {
    NSError *wError;
    NSData *value =  [NSJSONSerialization dataWithJSONObject:@1 options:NSJSONWritingFragmentsAllowed error:&wError];
    NSLog(@"value = %@", value);
    if (!wError) {
        NSLog(@"序列化成功");
    }else {
        NSLog(@"序列化失败:%@", wError);
    }
    [value writeToFileWithPathComponent:@"dataWriteFragmentsAllowed" suffix:@"json"];
    id back = [NSObject readFileWithPathComponent:@"dataWriteFragmentsAllowed" suffix:@"json"];
    NSLog(@"data_back = %@", back);     // data_back = 1
}

- (void)testStringWritingFragmentsAllowed {
    [@"Test stringWritingFragmentsAllowed" writeToFileWithPathComponent:@"stringWritingFragmentsAllowed" suffix:@"json"];
    id back = [NSObject readFileWithPathComponent:@"stringWritingFragmentsAllowed" suffix:@"json"];
    NSLog(@"string_back = %@", back);   // string_back = Test stringWritingFragmentsAllowed
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SystemTableViewCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SystemTableViewCell];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"write";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"type = %@", self.sectionTitles[indexPath.section]];
    }else {
        cell.textLabel.text = @"read";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"type = %@", self.cellTitles[indexPath.row]];
    }
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
    
    if (indexPath.row == 0) {   // write
        [self write:indexPath];
    }else {
        [self read:indexPath];
    }
}

- (void)write:(NSIndexPath *)indexPath {
    NSDictionary *dic = @{@"content1" : @"  If obj can’t produce valid JSON, NSJSONSerialization throws an exception. \\nThis exception occurs prior to parsing and represents a programming error, not an internal error. Before calling this method, you should check whether the input can produce valid JSON by using.",
                          @"content2" : @"  NSJSONWritingFragmentsAllowed Specifies that the parser /// should allow top-level objects that aren’t arrays or dictionaries",
                          @"content3"  : @"NSJSONWritingPrettyPrinted Specifies that the output \\ uses white space and indentation to make the resulting data more readable."
    };
    NSError *wError;
    
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        NSLog(@"格式正确");
    }else {
        NSLog(@"格式错误");
    }
    NSUInteger type = [self.writeTypes[indexPath.section] unsignedIntegerValue];
    NSLog(@"sec = %zd, type = %lu", indexPath.section, (unsigned long)type);
    NSData *value =  [NSJSONSerialization dataWithJSONObject:dic options:type error:&wError];
    
    if (!wError) {
        NSLog(@"序列化成功");
    }else {
        NSLog(@"序列化失败");
    }
    ZJDocumentWriteCofig *config = [ZJDocumentWriteCofig new];
    config.fileName = [NSString stringWithFormat:@"%@_content", self.sectionTitles[indexPath.section]];
    config.needEncodFileName = NO;
    config.documentType = ZJDocumentTypeJson;
    config.jsonWriteOptions = type;
    
    // 写入文件
    [value writeToFileWithDocumentConfig:config];
}

/*
 typedef NS_OPTIONS(NSUInteger, NSJSONReadingOptions) {
 //Specifies that arrays and dictionaries are created as mutable objects.
 //指定数组和字典作为可变对象创建。
 NSJSONReadingMutableContainers = (1UL << 0),
 
 //Specifies that leaf strings in the JSON object graph are created as instances of NSMutableString.
 //指定JSON对象图中的叶字符串是作为NSMutableString的实例创建的。返回的JSON对象中字符串的值为NSMutableString，目前在iOS 7上测试不好用，应该是个bug，参见：
 (https://stackoverflow.com/questions/19345864/nsjsonreadingmutableleaves-option-is-not-working)
 NSJSONReadingMutableLeaves = (1UL << 1),
 
 //Specifies that the parser should allow top-level objects that are not an instance of NSArray or NSDictionary.
 //指定解析器应该允许非NSArray或NSDictionary实例的顶级对象。
 NSJSONReadingFragmentsAllowed = (1UL << 2),
 
 NSJSONReadingAllowFragments //已弃用，使用NSJSONReadingFragmentsAllowed替代
 }
 */
- (void)read:(NSIndexPath *)indexPath {
    NSUInteger type = [self.readTypes[indexPath.row-1] unsignedIntegerValue];
    NSLog(@"index = %zd, type = %lu", indexPath.row, (unsigned long)type);
    
    ZJDocumentReadCofig *config = [ZJDocumentReadCofig new];
    config.fileName = [NSString stringWithFormat:@"%@_content", self.sectionTitles[indexPath.section]];
    config.needEncodFileName = NO;
    config.documentType = ZJDocumentTypeJson;
    config.jsonReadOptions = type;
    
    // 读取文件
    id value = [NSObject readFileWithDocumentConfig:config];
    // 当readOptions是NSJSONReadingMutableContainers时read的结果是mutable变量
    NSLog(@"value = %@, mutable = %d", value, [value isKindOfClass:[NSMutableDictionary class]]);
}

// 序列化失败
- (void)testFailJson {
    NSString *str = @"mm";
    NSError *error;
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    if (error) {
        NSLog(@"error = %@", error);    // JSON text did not start with array or object and option to allow fragments not set
    }else {
        [dict setObject:@"male" forKey:@"sex"];
    }
}

- (void)testMutableLeaves {
    NSDictionary *dict = @{@"key": @"value", @"key2": @"value2"};
    NSError *wError;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&wError];
    if (wError) {
        NSLog(@"error = %@", wError);
    }else {
        NSError *rError;
        NSDictionary *dict1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&rError];
        if (rError) {
            NSLog(@"rError = %@", rError);
        }else {
            NSLog(@"dict1_mutable = %d", [dict1 isKindOfClass:[NSMutableDictionary class]]);    // dict1_mutable = 0
            NSMutableString *ms =  [dict1 objectForKey:@"key"];
            if ([ms isKindOfClass:[NSMutableString class]]) {
                ms.string = @"ss";
            }else {
                NSLog(@"NSJSONReadingMutableLeaves不起作用");   // NSJSONReadingMutableLeaves不起作用
            }
        }
    }
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
