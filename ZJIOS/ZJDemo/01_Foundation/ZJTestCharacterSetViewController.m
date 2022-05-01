//
//  ZJTestCharacterSetViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/11/29.
//

#import "ZJTestCharacterSetViewController.h"

@interface ZJTestCharacterSetViewController ()<UITextFieldDelegate>

@end

@implementation ZJTestCharacterSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test3];
}

// textFielf只能输入数字
- (void)test3 {
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    tf.center = self.view.center;
    tf.delegate = self;
    tf.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:tf];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSString *filterStr = [[string componentsSeparatedByCharactersInSet:charSet.invertedSet] componentsJoinedByString:@""];
    if ([string isEqualToString:filterStr]) {
        return YES;
    }
    
    return NO;
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

/*
 //分割过程(猜想)
 //7sjf78sf990s
 //"",sjf78sf990s
 //"",sjf,8sf990s
 //"",sjf,"",sf990s
 //"",sjf,"",sf,90s
 //"",sjf,"",sf,"",0s
 //"",sjf,"",sf,"","",s
 
 2022-01-18 17:51:49.639844+0800 ZJIOS[4924:152512] set_ary----(
     "",
     sjf,
     "",
     sf,
     "",
     "",
     s
 )
 
 2022-01-18 18:14:15.719672+0800 ZJIOS[7237:175682] invertedSet_ary----(
     7,
     "",
     "",
     78,
     "",
     990,
     ""
 )
 */
- (void)test1 {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSString *str = @"7sjf78sf990s";
    NSLog(@"set_ary----%@", [str componentsSeparatedByCharactersInSet:set]);
    NSCharacterSet *invertedSet = set.invertedSet;
    NSLog(@"invertedSet_ary----%@", [str componentsSeparatedByCharactersInSet:invertedSet]);
}

/*
 需求:有一个字符串:@"今天我们来学习NSCharacterSet我们快乐"，去除字符串中所有的@"今"、@"我"、@"s"。
 */
- (void)test0 {
    NSString *str = @"hello-***NSCharacterSet*w**我";
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"-w我"];
    NSArray *setArr = [str componentsSeparatedByCharactersInSet:characterSet];
    NSString *resultStr = [setArr componentsJoinedByString:@""];
    NSLog(@"拆分后的字符串数组------%@@", setArr);
    NSLog(@"resultStr = %@", resultStr);
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
