//
//  ZJNScannerViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/8/16.
//

#import "ZJNScannerViewController.h"
#import "NSScanner+ZJScanner.h"

@interface ZJNScannerViewController ()

@end

@implementation ZJNScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test3];
}

// 扫描字符串直到遇到NSCharacterSet字符集的字符时停止，指针指向的地址存储的内容为遇到跳过字符集字符之前的内容
/*
 2021-12-09 15:43:27.553115+0800 ZJIOS[3948:132229] num = 1, str = a
 2021-12-09 15:43:27.553479+0800 ZJIOS[3948:132229] num = 2, str = bm
 2021-12-09 15:43:27.553589+0800 ZJIOS[3948:132229] num = 3, str = c
 2021-12-09 15:43:27.553680+0800 ZJIOS[3948:132229] num = 4, str = d
 2021-12-09 15:43:27.553757+0800 ZJIOS[3948:132229] num = 5, str = e
 2021-12-09 15:43:27.553849+0800 ZJIOS[3948:132229] num = 6, str = f
 */
- (void)test3 {
    NSString *numString = @"a1bm2c3d4e5f6";
    NSScanner *scanner = [NSScanner scannerWithString:numString];
    NSCharacterSet *numSet = [NSCharacterSet decimalDigitCharacterSet];
    while (NO == [scanner isAtEnd]) {
        NSString *str;
        if ([scanner scanUpToCharactersFromSet:numSet intoString:&str]) {
            int num;
            if ([scanner scanInt:&num]) {
                NSLog(@"num = %d, str = %@", num, str);
            }
        }
    }
}

/*
 scanCharacterFromSet是指扫描指定字符集合元素组合成的字符串，intoString指的是扫描出来的结果
 2021-12-08 18:17:40.241921+0800 ZJIOS[10438:271645] AABB
 2021-12-08 18:17:40.242193+0800 ZJIOS[10438:271645] CCDD
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
    int value;
    while (![scanner isAtEnd]) {
        [scanner scanInt:&value];
        NSLog(@"%d, %lu",value, (unsigned long)scanner.scanLocation);
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
