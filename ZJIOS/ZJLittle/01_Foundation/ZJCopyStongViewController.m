//
//  ZJCopyStongViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/12.
//

#import "ZJCopyStongViewController.h"

@interface ZJCopyStongViewController ()

/// 可变数组只能用copy不能用strong，copy出来的数组是不可变的，会导致数组操作失败程序奔溃
@property (nonatomic, strong) NSMutableArray *ary;

@property (nonatomic, copy) NSString *cpStr;
@property (nonatomic, strong) NSString *stgStr;


@end

@implementation ZJCopyStongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ary = [NSMutableArray array];
    [self.ary addObject:@"first element"];
    NSLog(@"ary = %@", self.ary);
    
//    [self test0];
//    [self test2];
//    [self test3];
    [self test4];
}
/*
 内存地址由低到高分别为:程序区-->数据区-->堆区-->栈区
 其中堆区分配内存从低往高分配,栈区分配内存从高往低分配
 1.继承关系:
 NSTaggedPointerString(栈区)      ---> NSString
 __NSCFConstantString(数据常量区)  ---> __NSCFString (堆区) --->NSMutableString --->NSString
 */
/*
 2021-06-18 23:27:38.994167+0800 ZJIOS[19172:1707660] str1--aa, 0x600001c5c030, __NSCFString
 2021-06-18 23:27:38.994295+0800 ZJIOS[19172:1707660] str2--aa, 0xf03a815896ca2295, NSTaggedPointerString
 2021-06-18 23:27:38.994395+0800 ZJIOS[19172:1707660] str1--aabb, 0x600001c5c030, __NSCFString
 2021-06-18 23:27:38.994558+0800 ZJIOS[19172:1707660] str2--aa, 0xf03a815896ca2295, NSTaggedPointerString
 
 2021-06-18 23:27:38.994688+0800 ZJIOS[19172:1707660] self.cpStr--aabb, 0xf03a815eb0ea2293, NSTaggedPointerString
 2021-06-18 23:27:38.994803+0800 ZJIOS[19172:1707660] self.stgStr--aabb, 0x600001c5c030, __NSCFString
 */
- (void)test0 {
    NSMutableString *str1 = @"aa".mutableCopy;
    NSString *str2 = [str1 copy];
    NSLog(@"str1--%@, %p, %@", str1, str1, [str1 class]);
    NSLog(@"str2--%@, %p, %@", str2, str2, [str2 class]);
    [str1 appendString:@"bb"];
    NSLog(@"str1--%@, %p, %@", str1, str1, [str1 class]);
    NSLog(@"str2--%@, %p, %@", str2, str2, [str2 class]);
    
    self.cpStr = str1;
    self.stgStr = str1;
    NSLog(@"self.cpStr--%@, %p, %@", self.cpStr, self.cpStr, [self.cpStr class]);
    NSLog(@"self.stgStr--%@, %p, %@", self.stgStr, self.stgStr, [self.stgStr class]);
}

/*
 2021-06-17 10:27:26.349876+0800 ZJIOS[12237:984986] 0x10b05b3e8--0x7ffee4bad578--hello baby!
 2021-06-17 10:27:26.350010+0800 ZJIOS[12237:984986] 0x10b05b3e8--0x7fc7c1725e60--hello baby!
 2021-06-17 10:27:26.350176+0800 ZJIOS[12237:984986] 0x10b05b3e8--0x7fc7c1725e58--hello baby!
 */
- (void)test1 {
    NSString *originStrinng = @"hello baby!";
    self.stgStr = originStrinng;
    self.cpStr = originStrinng;
    NSLog(@"%p--%p--%@", originStrinng, &originStrinng, originStrinng.class);
    NSLog(@"%p--%p--%@", self.stgStr, &_stgStr, self.stgStr.class);
    NSLog(@"%p--%p--%@", self.cpStr, &_cpStr, self.cpStr.class);
}

//2021-06-14 17:07:44.957035+0800 ZJIOS[3262:245227] 0x1029870f0--0x7ffeed27d588--hello baby!
//2021-06-14 17:07:44.957187+0800 ZJIOS[3262:245227] 0x1029870f0--0x7fee5e40aef8--hello baby!
//2021-06-14 17:07:44.957308+0800 ZJIOS[3262:245227] 0x1029870f0--0x7fee5e40af00--hello baby!
- (void)test2 {
    NSString *originStrinng = @"hello baby!";
    _stgStr = originStrinng;
    _cpStr = originStrinng;
    NSLog(@"%p--%p--%@", originStrinng, &originStrinng, originStrinng);
    NSLog(@"%p--%p--%@", self.stgStr, &_stgStr, self.stgStr);
    NSLog(@"%p--%p--%@", self.cpStr, &_cpStr, self.cpStr);
}

//2021-06-14 17:13:56.763880+0800 ZJIOS[3319:250028] 0x600001328cf0--0x7ffedfe0a588--hello meiemi
//2021-06-14 17:13:56.764022+0800 ZJIOS[3319:250028] 0x600001328cf0--0x7fc631507cb8--hello meiemi
//2021-06-14 17:13:56.764150+0800 ZJIOS[3319:250028] 0x600001328cf0--0x7fc631507cc0--hello meiemi
- (void)test3 {
    NSMutableString *originStrinng = @"hello baby!".mutableCopy;
    _stgStr = originStrinng;
    _cpStr = originStrinng;
    [originStrinng setString:@"hello meiemi"];
    NSLog(@"%p--%p--%@", originStrinng, &originStrinng, originStrinng);
    NSLog(@"%p--%p--%@", self.stgStr, &_stgStr, self.stgStr);
    NSLog(@"%p--%p--%@", self.cpStr, &_cpStr, self.cpStr);
}

//2021-09-15 17:01:52.620591+0800 ZJIOS[9518:262421] 0x600001330ff0--0x7ffee90adb08--hello baby!
//2021-09-15 17:01:52.620846+0800 ZJIOS[9518:262421] 0x600001330ff0--0x7ffb8ed289f0--hello baby!
//2021-09-15 17:01:52.621086+0800 ZJIOS[9518:262421] 0x600001d17ac0--0x7ffb8ed289e8--hello baby!

//2021-09-15 17:01:52.621331+0800 ZJIOS[9518:262421] 0x600001330ff0--0x7ffee90adb08--hello meiemi
//2021-09-15 17:01:52.621528+0800 ZJIOS[9518:262421] 0x600001330ff0--0x7ffb8ed289f0--hello meiemi
//2021-09-15 17:01:52.621728+0800 ZJIOS[9518:262421] 0x600001d17ac0--0x7ffb8ed289e8--hello baby!
- (void)test4 {
    // 第三种场景：用NSMutableString点语法赋值
    NSMutableString *originStrinng = @"hello baby!".mutableCopy;
    self.stgStr = originStrinng;
    self.cpStr = originStrinng;
    NSLog(@"%p--%p--%@", originStrinng, &originStrinng, originStrinng);
    NSLog(@"%p--%p--%@", self.stgStr, &_stgStr, self.stgStr);
    NSLog(@"%p--%p--%@", self.cpStr, &_cpStr, self.cpStr);
    [originStrinng setString:@"hello meiemi"];
    NSLog(@"%p--%p--%@", originStrinng, &originStrinng, originStrinng);
    NSLog(@"%p--%p--%@", self.stgStr, &_stgStr, self.stgStr);
    NSLog(@"%p--%p--%@", self.cpStr, &_cpStr, self.cpStr);
}

/*
 _copyyStr指针指向的地址不再是_originStr的地址
 当我们用self.copyyStr = originStr赋值时，会调用coppyStr的setter方法，而_copyyStr = originStr 赋值时给_copyyStr实例变量直接赋值，并不会调用copyyStr的setter方法，而在setter方法中有一个非常关键的语句：
 _cpStr = [cpStr copy];
 第三种场景中用self.cpStr = originStr 赋值时，调用cpStr的setter方法，setter方法对传入的cpStr做了次深拷贝生成了一个新的对象赋值给_cpStr，所以_cpStr指向的地址和对象值都不再和originStr相同。
 总结:
 当原字符串是NSString时，由于是不可变字符串，所以，不管使用strong还是copy修饰，都是指向原来的对象，copy操作只是做了一次浅拷贝。
 而当源字符串是NSMutableString时，strong只是将源字符串的引用计数加1，而copy则是对原字符串做了次深拷贝，从而生成了一个新的对象，并且copy的对象指向这个新对象。另外需要注意的是，这个copy属性对象的类型始终是NSString，而不是NSMutableString，如果想让拷贝过来的对象是可变的，就要使用mutableCopy。
 所以，如果源字符串是NSMutableString的时候，使用strong只会增加引用计数。
 但是copy会执行一次深拷贝，会造成不必要的内存浪费。而如果原字符串是NSString时，strong和copy效果一样，就不会有这个问题。
 但是，我们一般声明NSString时，也不希望它改变，所以一般情况下，建议使用copy，这样可以避免NSMutableString带来的错误。
 */
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
