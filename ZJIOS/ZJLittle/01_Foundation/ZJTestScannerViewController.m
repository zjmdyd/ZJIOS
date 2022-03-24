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
    
    [self test8];
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
    
    while (NO == [scanner isAtEnd]) {
        NSString *str;
        if ([scanner scanString:@"abc" intoString:&str]) {
            NSLog(@"str = %@, loc = %zd", str, scanner.scanLocation);
            break;
        }else {
            NSLog(@"未找到, loc = %zd", scanner.scanLocation);
            scanner.scanLocation++;
        }
    }
}

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
    while (NO == [scanner isAtEnd]) {
        NSString *str;
        if ([scanner scanUpToCharactersFromSet:numSet intoString:&str]) {
            int num;
            if ([scanner scanInt:&num]) {
                NSLog(@"num = %d, num_before_str = %@", num, str);
            }
        }
    }
}

// 2022-01-20 17:31:03.046752+0800 ZJIOS[18169:581697] str = abc
- (void)test6 {
    NSString *numString = @"abc1mm2c3d4e5f6";
    NSScanner *scanner = [NSScanner scannerWithString:numString];
    NSCharacterSet *numSet = [NSCharacterSet decimalDigitCharacterSet];
    while (NO == [scanner isAtEnd]) {
        NSString *str;
        if ([scanner scanUpToCharactersFromSet:numSet intoString:&str]) {
            NSLog(@"str = %@", str);
        }
    }
}

/*
 scanUpToCharactersFromSet:intoString：扫描字符串直到遇到NSCharacterSet字符集的字符时停止，
 指针指向的地址存储的内容为遇到跳过字符集字符之前的内容
 
 2022-01-20 17:29:09.230430+0800 ZJIOS[18095:579412] str = abcdef
 */
- (void)test5 {
    NSString *numString = @"abcdef6";
    NSScanner *scanner = [NSScanner scannerWithString:numString];
    NSCharacterSet *numSet = [NSCharacterSet decimalDigitCharacterSet];
    while (NO == [scanner isAtEnd]) {
        NSString *str;
        if ([scanner scanUpToCharactersFromSet:numSet intoString:&str]) {
            NSLog(@"str = %@", str);
        }
    }
}

/*
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
 scanCharacterFromSet是指扫描指定字符集合元素组合成的字符串，intoString指的是扫描出来的结果
 2022-01-20 16:38:26.370172+0800 ZJIOS[17139:545308] AABB
 2022-01-20 16:38:26.370344+0800 ZJIOS[17139:545308] CCDD
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
        NSLog(@"%@", str);
    }
}

/*
 scanner的每个扫描方法都返回是否成功，如果返回成功则scanLocation会往前移动相对应的位置（就是扫出来的内容的长度）,如果返回NO则scanLocation不会变化
 会产生死循环，因为第一个是字母，扫描数字不成功，scanLocation一直保持0，然后atEnd都是NO，所以while语句一直执行
 */
- (void)test1 {
    NSString *numString = @"a1b2c3d4e5f6";
    NSScanner *scanner = [NSScanner scannerWithString:numString];
    NSInteger value;
    while (![scanner isAtEnd]) {
        [scanner scanInteger:&value];
        NSLog(@"%zd, %zu", value, scanner.scanLocation);
    }
}

- (void)test0 {
    NSString *str = @"123";
    if ([NSScanner isPureInt:str]) {
        NSLog(@"整形数据");
    }else {
        NSLog(@"非整形数据");
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
