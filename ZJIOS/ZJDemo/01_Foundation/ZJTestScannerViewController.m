//
//  ZJTestScannerViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/8/16.
//

#import "ZJTestScannerViewController.h"
#import "NSScanner+ZJScanner.h"

@interface ZJTestScannerViewController ()

@end

@implementation ZJTestScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
}

- (void)initAry {
    self.vcType = ZJBaseTableViewTypeExecute;
    self.cellTitles = @[@"test0", @"test1", @"test2", @"test3", @"test4", @"test5", @"test6", @"test7", @"test8"];
}

/*
 2023-05-18 18:23:34.877197+0800 ZJIOS[97600:4804423] 非整形数据
 2023-05-18 18:23:34.877443+0800 ZJIOS[97600:4804423] 浮点形数据
 */
- (void)test0 {
    NSString *str = @"123.1";
    
    if ([NSScanner isPureInt:str]) {
        NSLog(@"整形数据");
    }else {
        NSLog(@"非整形数据");
    }
    if ([NSScanner isPureFloat:str]) {
        NSLog(@"浮点形数据");
    }else {
        NSLog(@"非浮点形数据");
    }
}

/*
 scanner的每个扫描方法都返回是否成功，如果返回成功则scanLocation会往前移动相对应的位置（就是扫出来的内容的长度）,如果返回NO则scanLocation不会变化
 如果不设置charactersToBeSkipped,会产生死循环，因为第一个是字母，扫描数字不成功，scanLocation一直保持0，然后atEnd都是NO，所以while语句一直执行
 */
- (void)test1 {
    NSString *numString = @"aa1b2c3d4e5f6";
    NSScanner *scanner = [NSScanner scannerWithString:numString];
    NSCharacterSet *skipSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdef"];
    scanner.charactersToBeSkipped = skipSet;

    NSInteger value;
    while (![scanner isAtEnd]) {
        [scanner scanInteger:&value];
        NSLog(@"%zd, %zu", value, scanner.scanLocation);
    }
}

/*
 scanCharacterFromSet是指扫描指定字符集合元素组合成的字符串，intoString指的是扫描出来的结果
 2022-05-11 17:52:10.481109+0800 ZJIOS[8327:241453] str = AABB, 4
 2022-05-11 17:52:10.481301+0800 ZJIOS[8327:241453] str = CCDD, 9
 */
- (void)test2 {
    NSString *test = @"AABBTCCDD";
    NSScanner *scanner = [NSScanner scannerWithString:test];
    NSCharacterSet *skipSet = [NSCharacterSet characterSetWithCharactersInString:@"T"];
    scanner.charactersToBeSkipped = skipSet;
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"ABCD"];
    NSString *str;
    while (![scanner isAtEnd]) {
        [scanner scanCharactersFromSet:set intoString:&str];
        NSLog(@"str = %@, %zd", str, scanner.scanLocation);
    }
}

/*
死循环, 字母E跳不过
 */
- (void)test3 {
    NSString *test = @"AAEBBTCCDD";
    NSScanner *scanner = [NSScanner scannerWithString:test];
    NSCharacterSet *skipSet = [NSCharacterSet characterSetWithCharactersInString:@"T"];
    scanner.charactersToBeSkipped = skipSet;
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"ABCD"];
    NSString *str;
    while (![scanner isAtEnd]) {
        [scanner scanCharactersFromSet:set intoString:&str];
        NSLog(@"%@", str);
    }
}

/*
 解决上test3循环
 2022-01-20 16:43:28.183125+0800 ZJIOS[17280:549207] AA
 2022-01-20 16:43:28.183306+0800 ZJIOS[17280:549207] BB
 2022-01-20 16:43:28.183407+0800 ZJIOS[17280:549207] CCDD
 */
- (void)test4 {
    NSString *test = @"AAEBBTCCDD";
    NSScanner *scanner = [NSScanner scannerWithString:test];
    NSCharacterSet *skipSet = [NSCharacterSet characterSetWithCharactersInString:@"ET"];
    scanner.charactersToBeSkipped = skipSet;
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"ABCD"];
    NSString *str;
    while (![scanner isAtEnd]) {
        [scanner scanCharactersFromSet:set intoString:&str];
        NSLog(@"%@", str);
    }
}

/*
 scanUpToCharactersFromSet:intoString：扫描字符串直到遇到NSCharacterSet字符集的字符时停止，
 指针指向的内容为遇到停止字符集字符之前的内容
 
 2023-05-18 19:04:43.795287+0800 ZJIOS[98896:4858755] str = abcdef, 6, 满足if条件
 2023-05-18 19:04:43.795503+0800 ZJIOS[98896:4858755] str = (null), 6
 */
- (void)test5 {
    NSString *numString = @"abcdef6";
    NSScanner *scanner = [NSScanner scannerWithString:numString];
    NSCharacterSet *numSet = [NSCharacterSet decimalDigitCharacterSet];
    while (![scanner isAtEnd]) {
        NSString *str;
        if ([scanner scanUpToCharactersFromSet:numSet intoString:&str]) {
            NSLog(@"str = %@, %zd, 满足if条件", str, scanner.scanLocation);
        }else {
            NSLog(@"str = %@, %zd", str, scanner.scanLocation);
            scanner.scanLocation++;
        }
    }
}

/*
 2023-05-18 19:04:53.120015+0800 ZJIOS[98896:4858755] str = abc, 3, 匹配到
 2023-05-18 19:04:53.120225+0800 ZJIOS[98896:4858755] str = (null), 3
 2023-05-18 19:04:53.120383+0800 ZJIOS[98896:4858755] str = mm, 6, 匹配到
 2023-05-18 19:04:53.120515+0800 ZJIOS[98896:4858755] str = (null), 6
 2023-05-18 19:04:53.120682+0800 ZJIOS[98896:4858755] str = c, 8, 匹配到
 2023-05-18 19:04:53.120817+0800 ZJIOS[98896:4858755] str = (null), 8
 2023-05-18 19:04:53.120972+0800 ZJIOS[98896:4858755] str = d, 10, 匹配到
 2023-05-18 19:04:53.121100+0800 ZJIOS[98896:4858755] str = (null), 10
 2023-05-18 19:04:53.121239+0800 ZJIOS[98896:4858755] str = e, 12, 匹配到
 2023-05-18 19:04:53.121385+0800 ZJIOS[98896:4858755] str = (null), 12
 2023-05-18 19:04:53.121582+0800 ZJIOS[98896:4858755] str = f, 14, 匹配到
 2023-05-18 19:04:53.121695+0800 ZJIOS[98896:4858755] str = (null), 14
 */
- (void)test6 {
    NSString *numString = @"abc1mm2c3d4e5f6";
    NSScanner *scanner = [NSScanner scannerWithString:numString];
    NSCharacterSet *numSet = [NSCharacterSet decimalDigitCharacterSet];
    while (![scanner isAtEnd]) {
        NSString *str;
        if ([scanner scanUpToCharactersFromSet:numSet intoString:&str]) {
            NSLog(@"str = %@, %zd, 匹配到", str, scanner.scanLocation);
        }else {
            NSLog(@"str = %@, %zd", str, scanner.scanLocation);
            scanner.scanLocation++;
        }
    }
}

/*
 test7和test8两种方法避免死循环
 */

/*
 2022-01-20 17:33:47.621272+0800 ZJIOS[18289:585885] num = 1, num_before_str = abc
 2022-01-20 17:33:47.621428+0800 ZJIOS[18289:585885] num = 2, num_before_str = mm
 2022-01-20 17:33:47.621549+0800 ZJIOS[18289:585885] num = 3, num_before_str = c
 2022-01-20 17:33:47.621690+0800 ZJIOS[18289:585885] num = 4, num_before_str = d
 2022-01-20 17:33:47.621799+0800 ZJIOS[18289:585885] num = 5, num_before_str = e
 2022-01-20 17:33:47.621903+0800 ZJIOS[18289:585885] num = 6, num_before_str = f
 */
- (void)test7 {
    NSString *numString = @"abc1mm2c3d4e5f6";
    NSScanner *scanner = [NSScanner scannerWithString:numString];
    NSCharacterSet *numSet = [NSCharacterSet decimalDigitCharacterSet];
    while (![scanner isAtEnd]) {
        NSString *str;
        if ([scanner scanUpToCharactersFromSet:numSet intoString:&str]) {
            int num;
            if ([scanner scanInt:&num]) {
                NSLog(@"num = %d, num_before_str = %@", num, str);
            }
        }
    }
}

/*
 2022-01-20 18:12:23.735117+0800 ZJIOS[19156:625489] 未找到, loc = 0
 2022-01-20 18:12:23.735358+0800 ZJIOS[19156:625489] 未找到, loc = 1
 2022-01-20 18:12:23.735465+0800 ZJIOS[19156:625489] 未找到, loc = 2
 2022-01-20 18:12:23.735637+0800 ZJIOS[19156:625489] str = abc, loc = 6
 */
- (void)test8 {
    NSString *numString = @"123abc456";
    NSScanner *scanner = [NSScanner scannerWithString:numString];
    
    while (![scanner isAtEnd]) {
        NSString *str;
        if ([scanner scanString:@"abc" intoString:&str]) {
            NSLog(@"找到, str = %@, loc = %zd", str, scanner.scanLocation);
//            break; // 此处不加break也不会死循环
        }else {
            NSLog(@"未找到, loc = %zd", scanner.scanLocation);
            scanner.scanLocation++;
        }
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
