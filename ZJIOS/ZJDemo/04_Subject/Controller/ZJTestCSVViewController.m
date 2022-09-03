//
//  ZJTestCSVViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/8/16.
//

#import "ZJTestCSVViewController.h"

@interface ZJTestCSVViewController ()

@end

@implementation ZJTestCSVViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self test0];
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
 字段中的双引号，用两个双引号表示。（ 我说："abc"。 ==> 我说：""abc""。 ）
 字段中如果有双引号，该字段必须用双引号括起来。（ 我说："abc"。 ==> "我说：""abc""。"
 */
- (void)test0 { 
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
