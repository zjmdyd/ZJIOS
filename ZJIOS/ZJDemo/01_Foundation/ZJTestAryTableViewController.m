//
//  ZJTestAryTableViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/11/22.
//

#import "ZJTestAryTableViewController.h"
#import "NSArray+ZJArray.h"

@interface ZJTestAryTableViewController ()

@end

@implementation ZJTestAryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cellTitles = @[@"test0", @"test1", @"test2"];
}

/*
 2022-05-14 22:44:41.740172+0800 ZJIOS[6928:229514] (
     00,
     01,
     02,
     03,
     04,
     05,
     06,
     07,
     08,
     09,
     10,
     11
 )
 */
- (void)test0 {
    NSLog(@"%@", [NSArray timeStringWithType:TimeStringType12Hour]);
}

/*
 2023-04-11 15:31:08.936192+0800 ZJIOS[15382:333809] 1/2/3/4
 2023-04-11 15:31:08.936368+0800 ZJIOS[15382:333809] 2/3
 */
- (void)test1 {
    NSArray *ary = @[@"1", @"2", @"3", @"4"];
    NSLog(@"%@", [ary joinToStringWithSeparateString:@"/"]);
    NSLog(@"%@", [ary joinToStringWithSeparateString:@"/" range:NSMakeRange(1, 2)]);
}

- (void)test2 {
    NSArray *ary = @[@"0099", @"2233", @"", @" "];
    if ([ary containsObject:@"0099"]) {
        NSLog(@"数组包含字符串方法成立");      // 数组包含字符串方法成立
    }else {
        NSLog(@"数组包含字符串方法不成立");
    }
    
    if ([ary containsObject:@""]) {         // 数组包含空字符串方法成立
        NSLog(@"数组包含空字符串方法成立");
    }else {
        NSLog(@"数组包含空字符串方法不成立");
    }
    
    if ([ary containsObject:@" "]) {        // 数组包含空格字符串方法成立
        NSLog(@"数组包含空格字符串方法成立");
    }else {
        NSLog(@"数组包含空格字符串方法不成立");
    }
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
