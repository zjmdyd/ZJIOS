//
//  ZJTestStringViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/11/23.
//

#import "ZJTestStringViewController.h"
#import "NSString+ZJString.h"

@interface ZJTestStringViewController ()

@end

@implementation ZJTestStringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test2];
}

/*
 2022-01-11 16:07:21.029427+0800 ZJIOS[54224:1342679] str1: 0x10f43bf98, hello
 2022-01-11 16:07:21.029668+0800 ZJIOS[54224:1342679] str2: 0x6000000cf300, hello+111
 
 ***stringByAppendingString会生成一个全新的变量
 */
- (void)test3 {
    NSString *str1 = @"hello";
    NSString *str2 = [str1 stringByAppendingString:@"+111"];
    NSLog(@"str1: %p, %@", str1, str1);
    NSLog(@"str2: %p, %@", str2, str2);
}

/*
 继承关系:
 NSTaggedPointerString(栈区)      ---> NSString
 __NSCFConstantString(数据常量区)  ---> __NSCFString (堆区) --->NSMutableString --->NSString
 
 对于NSStringFromClass()方法
 字符串较短的class,系统会对其进行比较特殊的内存管理,NSObject字符串比较短,直接存储在栈区,类型为NSTaggedPointerString,不论你NSStringFromClass多少次,得到的都是同一个内存地址的string;但对于较长的class,则为__NSCFString类型,而NSCFString存储在堆区,每次NSStringFromClass都会得到不同内存地址的string
 
 __NSCFConstantString类型的字符串,存储在数据区,即使当前控制器被dealloc释放了,存在于这个控制器的该字符串所在内存仍然不会被销毁.通过快捷方式创建的字符串,无论字符串多长或多短,都是__NSCFConstantString类型,存储在数据区.
 */

/*
 2022-01-18 16:50:03.625951+0800 ZJIOS[3734:113728] haha, 0x100d1efd8, __NSCFConstantString
 2022-01-18 16:50:03.626174+0800 ZJIOS[3734:113728] haha, 0x100d1efd8, __NSCFConstantString
 2022-01-18 16:50:03.626259+0800 ZJIOS[3734:113728] haha, 0x100d1efd8, __NSCFConstantString
 2022-01-18 16:50:03.626363+0800 ZJIOS[3734:113728] haha, 0x8c40371903ebe94d, NSTaggedPointerString
 2022-01-18 16:50:03.626475+0800 ZJIOS[3734:113728] haha, 0x60000173adc0, __NSCFString
 */
- (void)test2 {
    static NSString *a = @"haha";
    NSString *b = @"haha";
    NSString *c = @"haha";
    NSString *d = [[NSString alloc] initWithFormat:@"%@", @"haha"];
    NSMutableString *e = b.mutableCopy;
    NSLog(@"%@, %p, %@", a, a, a.class);
    NSLog(@"%@, %p, %@", b, b, b.class);
    NSLog(@"%@, %p, %@", c, c, c.class);
    NSLog(@"%@, %p, %@", d, d, d.class);
    NSLog(@"%@, %p, %@", e, e, e.class);
}

/*
 2022-01-10 16:39:56.361375+0800 ZJIOS[41584:1018052] invertString = fedcba
 2022-01-10 16:39:56.361619+0800 ZJIOS[41584:1018052] invertStringWithSegmentLenth = defabc
 */
- (void)test1 {
    NSString *str = @"abcdef";
    NSLog(@"invertString = %@", [str invertString]);
    NSLog(@"invertStringWithSegmentLenth = %@", [str invertStringWithSegmentLenth:3]);
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
