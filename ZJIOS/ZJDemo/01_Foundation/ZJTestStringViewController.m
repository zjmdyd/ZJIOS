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
    
    [self initAry];
}

- (void)initAry {
    self.vcType = ZJBaseTableViewTypeExecute;
    self.cellTitles = @[@"test0", @"test1", @"test2", @"test3", @"test4", @"test5", @"test6", @"test7", @"test8"];
}

- (void)printEvent:(NSString *)str {
    NSLog(@"str = %@, %@->%@->%@->%@:%p", str, [str class], [[str class] superclass], [[[str class] superclass] superclass] ,[[[[str class] superclass] superclass] superclass], str);
}

/*
 继承关系:
 NSTaggedPointerString(栈区)      ---> NSString
 __NSCFConstantString(数据常量区)  ---> __NSCFString (堆区) --->NSMutableString --->NSString
 
 对于stringWithFormat()方法
 字符串较短的class,系统会对其进行比较特殊的内存管理,NSObject字符串比较短,直接存储在栈区,类型为NSTaggedPointerString,不论你NSStringFromClass多少次,得到的都是同一个内存地址的string;但对于较长的class,则为__NSCFString类型,而NSCFString存储在堆区,每次NSStringFromClass都会得到不同内存地址的string
 
 __NSCFConstantString类型的字符串,存储在数据区,即使当前控制器被dealloc释放了,存在于这个控制器的该字符串所在内存仍然不会被销毁.通过快捷方式创建的字符串,无论字符串多长或多短,都是__NSCFConstantString类型,存储在数据区.
 */
/*
 NSString是一个类簇，也就是说NSString只是一个公共接口，实际实现的类是不同的
 
 __NSTaggedPointerString

 这个类型是标签指针字符串，这是苹果在 64 位环境下对 NSString,NSNumber 等对象做的一些优化。简单来讲可以理解为把指针指向的内容直接放在了指针变量的内存地址中，因为在 64 位环境下指针变量的大小达到了 8 字节足以容纳一些长度较小的内容。于是使用了标签指针这种方式来优化数据的存储方式。从他的引用计数可以看出，这货也是一个释放不掉的单例常量对象。在运行时根据实际情况创建。
 对于 NSString 对象来讲，当非字面值常量的数字，英文字母字符串的长度小于等于 9 的时候会自动成为 NSTaggedPointerString 类型.
 如果有中文或其他特殊符号（可能是非 ASCII 字符）存在的话则会直接成为 ）__NSCFString 类型。
 这种对象被直接存储在指针的内容中，可以当作一种伪对象
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
    [self printEvent:str0];

    NSString *str1 = [NSString stringWithFormat:@"b"];
    [self printEvent:str1];

    NSString *str2 = [NSString stringWithFormat:@"Kraftfahrzeughaftpflichtversicherung"];
    [self printEvent:str2];

    CFShowStr((CFStringRef)str2);
    
    if ([str2 respondsToSelector:@selector(appendString:)]) {
        NSLog(@"可以调用appendString:");    
        if ([str2 isKindOfClass:[NSMutableString class]]) {   //isKindOfClass会检测通过
            NSLog(@"str2是可变字符串");
            // [((NSMutableString *)str2) appendString:@"123"];    // Attempt to mutate immutable object with appendString:
        }else {
            NSLog(@"str2不是可变字符串");
        }
    }else {
        NSLog(@"不可以调用appendString:");
    }
    
    NSString *str0_1 = @"a";    // __NSCFConstantString 与str0同一个地址
    [self printEvent:str0_1];
    
    NSString *str1_1 = [NSString stringWithFormat:@"b"];    // NSTaggedPointerString 与str1同一个地址
    [self printEvent:str1_1];
    
//    __NSCFString  与str2不是同一个地址
    NSString *str2_2 = [NSString stringWithFormat:@"Kraftfahrzeughaftpflichtversicherung"];
    [self printEvent:str2_2];
}

// 经过mutableCopy后都变为栈区的字符串
- (void)test1 {
    NSString *str0 = @"a".mutableCopy;
    [(NSMutableString *)str0 appendString:@"a1"];
    [self printEvent:str0];

    NSString *str1 = [NSString stringWithFormat:@"b"].mutableCopy;
    [(NSMutableString *)str1 appendString:@"b1"];

    [self printEvent:str1];

    NSString *str2 = [NSString stringWithFormat:@"Kraftfahrzeughaftpflichtversicherung"].mutableCopy;
    [self printEvent:str2];

    CFShowStr((CFStringRef)str2);
    
    if ([str2 respondsToSelector:@selector(appendString:)]) {
        NSLog(@"可以调用appendString:");
        if ([str2 isKindOfClass:[NSMutableString class]]) {   //isKindOfClass会检测通过
            NSLog(@"str2是可变字符串");
//            [((NSMutableString *)str2) appendString:@"123"];    // Attempt to mutate immutable object with appendString:
        }else {
            NSLog(@"str2不是可变字符串");
        }
    }else {
        NSLog(@"不可以调用appendString:");
    }
    
    NSString *str0_1 = @"aa1";    // __NSCFConstantString 与str0不是同一个地址
    [self printEvent:str0_1];
    
    NSString *str1_1 = [NSString stringWithFormat:@"bb1"];    // NSTaggedPointerString 与str1不是同一个地址
    [self printEvent:str1_1];
    
//    __NSCFString 与str2不是同一个地址
    NSString *str2_2 = [NSString stringWithFormat:@"Kraftfahrzeughaftpflichtversicherung"];
    [self printEvent:str2_2];
}

/*
 initWithFormat和stringWithFormat创建的字符串内存分配结果一样
 */
- (void)test2 {
//    static NSString *a = @"haha";
    NSString *str0 = @"a";
    [self printEvent:str0];

    NSString *str1 = [[NSString alloc] initWithFormat:@"b"];
    [self printEvent:str1];

    NSString *str2 = [[NSString alloc] initWithFormat:@"Kraftfahrzeughaftpflichtversicherung"];
    [self printEvent:str2];

    CFShowStr((CFStringRef)str2);
    
    if ([str2 respondsToSelector:@selector(appendString:)]) {
        NSLog(@"可以调用appendString:");
        if ([str2 isKindOfClass:[NSMutableString class]]) {   //isKindOfClass会检测通过
            NSLog(@"str2是可变字符串");
//            [((NSMutableString *)str2) appendString:@"123"];    // Attempt to mutate immutable object with appendString:
        }else {
            NSLog(@"str2不是可变字符串");
        }
    }else {
        NSLog(@"不可以调用appendString:");
    }
    
    NSString *str0_1 = @"a";    // __NSCFConstantString 与str0同一个地址
    [self printEvent:str0_1];
    
    NSString *str1_1 = [NSString stringWithFormat:@"b"];    // NSTaggedPointerString 与str1同一个地址
    [self printEvent:str1_1];
    
//    __NSCFString  与str2不是同一个地址
    NSString *str2_2 = [NSString stringWithFormat:@"Kraftfahrzeughaftpflichtversicherung"];
    [self printEvent:str2_2];
}

/*
 分割:空字符串会占用数组元素
 -->(
     "",
     aa
 ), count = 2
 -->(
     "",
     "",
     aa
 ), count = 3
 */
- (void)test3 {
    NSString *string1 = @"1aa";
    NSString *string2 = @"11aa";
    NSArray *ary1 = [string1 componentsSeparatedByString:@"1"];
    NSArray *ary2 = [string2 componentsSeparatedByString:@"1"];
    NSLog(@"-->%@, count = %zd", ary1, ary1.count);
    NSLog(@"-->%@, count = %zd", ary2, ary2.count);
    for (NSString *obj in ary2) {
        NSLog(@"obj = %@, %p", obj, obj);
    }
}

/*
 2023-05-15 00:23:10.339801+0800 ZJIOS[49622:3054184] invertString = gfedcba
 2023-05-15 00:23:10.340127+0800 ZJIOS[49622:3054184] invertStringWithUnitSpan = efgbcda
 */
- (void)test4 {
    NSString *str = @"abcdefg";
    NSLog(@"invertString = %@", [str invertString]);
    NSLog(@"invertStringWithUnitSpan = %@", [str invertStringWithUnitSpan:3]);
}

/*
 str = hello, __NSCFConstantString->__NSCFString->NSMutableString->NSString:0x108cfd0e0
 str = hello+111, __NSCFString->NSMutableString->NSString->NSObject:0x60000324d6b0
 
 ***stringByAppendingString会生成一个全新的变量
 */
- (void)test5 {
    NSString *str1 = @"hello";
    NSString *str2 = [str1 stringByAppendingString:@"+111"];
    [self printEvent:str1];
    [self printEvent:str2];
}

/*
 str = hello, __NSCFConstantString->__NSCFString->NSMutableString->NSString:0x1039820e0
 str = hello baby, __NSCFConstantString->__NSCFString->NSMutableString->NSString:0x1039834c0
 修改不可变字符串，改变了字符串的地址
 */
- (void)test6 {
    NSString *str1 = @"hello";
    [self printEvent:str1];
    str1 = @"hello baby";
    [self printEvent:str1];
}

//  判断可变字符串只能通过copy方法判断，copy出来的地址不相同为可变字符串，否则为不可变
- (void)test7 {
    NSMutableString *str1 = [[NSMutableString alloc] initWithString:@"hello"];
    [self printEvent:str1];
    [str1 appendString:@"111"];
    [self printEvent:str1];
    if([str1 isMemberOfClass:[NSMutableString class]]) {    // isMemberOfClass判断会进入else,判断失败
        NSLog(@"str1是可变字符串");
    }else {
        NSLog(@"str1不是可变字符串");
    }
    
    NSString *str2 = str1.copy;
    [self printEvent:str2];

    if (str1 == str2) {
        NSLog(@"str1不是可变字符串");
    }else {
        NSLog(@"str1是可变字符串");
        [str1 appendString:@"222"];
        [self printEvent:str1];
    }
}

/*
 2022-05-15 16:56:22.052346+0800 ZJIOS[7308:213976] dic = (null)
 非标准json格式会转换失败
 */
- (void)test8 {
    NSString *str = @"hello";
    NSDictionary *dic = [str stringToJson];
    NSLog(@"dic = %@", dic);
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
