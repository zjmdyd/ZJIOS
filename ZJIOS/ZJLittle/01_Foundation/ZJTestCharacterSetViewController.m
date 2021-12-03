//
//  ZJTestCharacterSetViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/11/29.
//

#import "ZJTestCharacterSetViewController.h"

@interface ZJTestCharacterSetViewController ()

@end

@implementation ZJTestCharacterSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test1];
}
/*
 URL编码--->percent-encode 百分号编码
 RFC3986文档规定，URL中只允许包含:
 英文字符 : a-zA-Z
 数字: 0-9
 -_.~ 4个特殊字符.
 保留字符: ! * ' ( ) ; : @ & = + $ , / ? # [ ]
 对于非ASCII字符,需要使用ASCII字符集的超集进行编码得到相应的字节，然后对每个字节执行百分号编码。 对于Unicode字符，RFC文档建议使用utf-8对其进行编码得到相应的字节，然后对每个字节执行百分号编码。如“中文”使用UTF-8字符集得到 的字节为0xE4 0xB8 0xAD 0xE6 0x96 0x87，经过Url编码之后得到“%E4%B8%AD%E6%96%87”。
 */

/*
 2021-12-01 19:29:24.393425+0800 ZJIOS[15376:268598]
 urlAllow = %68%74%74%70%73%3A//%77%77%77%2E%62%61%69%64%75%2E%63%6F%6D?%6E%61%6D%65=%E5%B0%8F%E6%98%8E&%61%67%65=%32%30
 可以看出除了?&=/ ,其他字符都被编码了.
 
 2021-12-01 19:39:18.291539+0800 ZJIOS[15587:276019]
 url_invert_allow = https:%2F%2Fwww.baidu.com%3Fname%3D%E5%B0%8F%E6%98%8E%26age%3D20
 */
- (void)test1 {
    NSString *originUlr = @"https://www.baidu.com?name=小明&age=20";
    NSCharacterSet *defaultCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"?&=/ "];
    NSString *urlAllow = [[originUlr copy] stringByAddingPercentEncodingWithAllowedCharacters:defaultCharacterSet];
    NSLog(@"urlAllow = %@", urlAllow);
    NSCharacterSet *invertCharacterSet = defaultCharacterSet.invertedSet;
    NSString *url_invert_allow = [[originUlr copy] stringByAddingPercentEncodingWithAllowedCharacters:invertCharacterSet];
    NSLog(@"url_invert_allow = %@", url_invert_allow);
    NSString *decodeString = [url_invert_allow stringByRemovingPercentEncoding];
    NSLog(@"decodeString = %@", decodeString);
}

/*
 分割:空字符串会占用数组元素
 -->(
     "",
     aa
 )
 -->(
     "",
     "",
     aa
 )
 */
- (void)test0 {
    NSString *string1 = @"1aa";
    NSString *string2 = @"11aa";
    NSLog(@"-->%@", [string1 componentsSeparatedByString:@"1"]);
    NSLog(@"-->%@", [string2 componentsSeparatedByString:@"1"]);
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
