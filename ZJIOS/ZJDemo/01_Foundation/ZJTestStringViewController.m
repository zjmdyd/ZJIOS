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
    
    [self test0];
}

/*
 NSTaggedPointerString(栈区)      ---> NSString
 __NSCFConstantString(数据常量区)  ---> __NSCFString (堆区) --->NSMutableString --->NSString

 */

// 2022-05-12 18:24:45.931031+0800 ZJIOS[10209:377440] __NSCFConstantString->__NSCFString->NSMutableString->NSString:0x1018db3d0
// 2022-05-12 18:24:45.931228+0800 ZJIOS[10209:377440] NSTaggedPointerString->NSString->NSObject->(null):0xe53eb7a9d7f35e53
// 2022-05-12 18:24:45.931323+0800 ZJIOS[10209:377440] __NSCFString->NSMutableString->NSString->NSObject:0x600003ab0680

/*
 CFShowStr((CFStringRef)str2);
 
 Length 36
 IsEightBit 1
 HasLengthByte 1
 HasNullByte 1
 InlineContents 1
 Allocator SystemDefault
 Mutable 0
 Contents 0x600003141290
 */
- (void)test0 {
    NSString *str0 = @"a";
    NSLog(@"%@->%@->%@->%@:%p", [str0 class], [[str0 class] superclass], [[[str0 class] superclass] superclass] ,[[[[str0 class] superclass] superclass] superclass], str0);
    
    NSString *str1 = [NSString stringWithFormat:@"b"];
    NSLog(@"%@->%@->%@->%@:%p", [str1 class], [[str1 class] superclass], [[[str1 class] superclass] superclass] ,[[[[str1 class] superclass] superclass] superclass], str1);

    NSString *str2 = [NSString stringWithFormat:@"Kraftfahrzeughaftpflichtversicherung"];
    NSLog(@"%@->%@->%@->%@:%p", [str2 class], [[str2 class] superclass], [[[str2 class] superclass] superclass] ,[[[[str2 class] superclass] superclass] superclass], str2);
    
    CFShowStr((CFStringRef)str2);
    
    if ([str2 respondsToSelector:@selector(appendString:)]) {
        NSLog(@"可以调用appendString:");    
        if ([str2 isKindOfClass:[NSMutableString class]]) {
            NSLog(@"str2是可变字符串");
//            [((NSMutableString *)str2) appendString:@"123"];    // Attempt to mutate immutable object with appendString:
        }
    }else {
        NSLog(@"不可以调用appendString:");
    }
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
- (void)test1 {
    NSString *string1 = @"1aa";
    NSString *string2 = @"11aa";
    NSLog(@"-->%@", [string1 componentsSeparatedByString:@"1"]);
    NSLog(@"-->%@", [string2 componentsSeparatedByString:@"1"]);
}

/*
 2022-01-10 16:39:56.361375+0800 ZJIOS[41584:1018052] invertString = fedcba
 2022-01-10 16:39:56.361619+0800 ZJIOS[41584:1018052] invertStringWithSegmentLenth = defabc
 */
- (void)test2 {
    NSString *str = @"abcdef";
    NSLog(@"invertString = %@", [str invertString]);
    NSLog(@"invertStringWithSegmentLenth = %@", [str invertStringWithSegmentLenth:3]);
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
 NSString是一个类簇，也就是说NSString只是一个公共接口，实际实现的类是不同的
 */

/*
 2022-01-18 16:50:03.625951+0800 ZJIOS[3734:113728] haha, 0x100d1efd8, __NSCFConstantString
 2022-01-18 16:50:03.626174+0800 ZJIOS[3734:113728] haha, 0x100d1efd8, __NSCFConstantString
 2022-01-18 16:50:03.626259+0800 ZJIOS[3734:113728] haha, 0x100d1efd8, __NSCFConstantString
 2022-01-18 16:50:03.626363+0800 ZJIOS[3734:113728] haha, 0x8c40371903ebe94d, NSTaggedPointerString
 2022-01-18 16:50:03.626475+0800 ZJIOS[3734:113728] haha, 0x60000173adc0, __NSCFString
 */
- (void)test3 {
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
 2022-01-11 16:07:21.029427+0800 ZJIOS[54224:1342679] str1: 0x10f43bf98, hello
 2022-01-11 16:07:21.029668+0800 ZJIOS[54224:1342679] str2: 0x6000000cf300, hello+111
 
 ***stringByAppendingString会生成一个全新的变量
 */
- (void)test4 {
    NSString *str1 = @"hello";
    NSString *str2 = [str1 stringByAppendingString:@"+111"];
    NSLog(@"str1: %p, %@", str1, str1);
    NSLog(@"str2: %p, %@", str2, str2);
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
