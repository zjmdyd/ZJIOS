//
//  ZJTestCharacterSetViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/11/29.
//

#import "ZJTestCharacterSetViewController.h"
#import "UITextField+ZJTextField.h"

@interface ZJTestCharacterSetViewController ()

@end

@implementation ZJTestCharacterSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test3];
}

/*
 */
- (void)test0 {
    NSString *str = @"hello-毛***NSChar主acterSet*w**席我";
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"-w我毛主席"];
    NSArray *setArr = [str componentsSeparatedByCharactersInSet:characterSet];
    NSString *resultStr = [setArr componentsJoinedByString:@""];
    NSLog(@"拆分后的字符串数组------%@@", setArr);
    NSLog(@"resultStr = %@", resultStr);    // hello***NSCharacterSet***
}

/*
 2022-05-07 11:12:25.896850+0800 ZJIOS[4370:110121] set_ary----(
     "",
     "",
     sjf,
     "",
     sf,
     "",
     "",
     s
 )
 
 2022-05-07 11:20:01.697221+0800 ZJIOS[4562:118111] invertedSet_ary----(
     12,
     "",
     "",
     3,
     "",
     45,
     "",
     678,
     "",
     9999,
     ""
 )
 */

/*
 拆分字符串规则:
 分隔符的相邻出现会在结果中产生空字符串
 如果字符串以分隔符开头或结尾，则第一个或最后一个子字符串分别为空
 */
/*
 拆分12sjf3kk45sf678dd9999s
 "", "", sjf, kk, "", sf, "", "", dd, "", "", "", s
 比如拆分sf678dd这段
 拆分时消耗掉一个数字,本来是678三个分割符,消耗掉一个还剩两个相邻的的分隔符，所以sf678dd拆分为:sf, "", "", dd,出现两个空字符串
 拆分开头和结尾类似,只有一点不同的是开头或结尾是分隔符的话会则为空,比如12sjf这段,两个分隔符消耗掉一个还剩一个,另一个是因为是以分隔符开头,所以12sjf拆分为:"", "", sjf,
 */
- (void)test1 {
    NSString *str = @"12sjf3kk45sf678dd9999s";
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSLog(@"set_ary----%@", [str componentsSeparatedByCharactersInSet:set]);
    NSCharacterSet *invertedSet = set.invertedSet;
    NSLog(@"invertedSet_ary----%@", [str componentsSeparatedByCharactersInSet:invertedSet]);
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

/* log输出
 2022-01-18 18:23:15.185759+0800 ZJIOS[7531:185321] urlAllow = %68%74%74%70%73%3A//%77%77%77%2E%62%61%69%64%75%2E%63%6F%6D?%6E%61%6D%65=%E5%B0%8F%E6%98%8E&%61%67%65=%32%30
 // 可以看出除了?&=/ ,其他字符都被编码了.
 2022-01-18 18:23:15.185985+0800 ZJIOS[7531:185321] url_invert_allow = https:%2F%2Fwww.baidu.com%3Fname%3D%E5%B0%8F%E6%98%8E%26age%3D20
 2022-01-18 18:24:35.999978+0800 ZJIOS[7573:186792] decodeString = https://www.baidu.com?name=小明&age=20
 */
- (void)test2 {
    NSString *originUlr = @"https://www.baidu.com?name=小明&age=20";
    NSCharacterSet *defaultCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"?&=/ "];
    NSString *urlAllow = [originUlr stringByAddingPercentEncodingWithAllowedCharacters:defaultCharacterSet];
    NSLog(@"urlAllow = %@", urlAllow);
    
    NSCharacterSet *invertCharacterSet = defaultCharacterSet.invertedSet;
    NSString *url_invert_allow = [originUlr stringByAddingPercentEncodingWithAllowedCharacters:invertCharacterSet];
    NSLog(@"url_invert_allow = %@", url_invert_allow);
    NSString *decodeString = [url_invert_allow stringByRemovingPercentEncoding];
    NSLog(@"decodeString = %@", decodeString);
}

// textFielf只能输入数字
- (void)test3 {
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    tf.center = self.view.center;
    tf.delegate = tf;
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.textType = ZJTextFieldTextTypeNumber;
    tf.containedPoint = YES;
    [self.view addSubview:tf];
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
