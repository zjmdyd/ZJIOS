//
//  ZJTestCopyStrongPopertyViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/1/10.
//

#import "ZJTestCopyStrongPopertyViewController.h"

@interface ZJTestCopyStrongPopertyViewController ()

@property (nonatomic, copy) NSString *str_copy;
@property (nonatomic, strong) NSString *str_strong;

@property (nonatomic, copy) NSMutableString *mutStr_copy;
@property (nonatomic, strong) NSMutableString *mutStr_strong;

@end

@implementation ZJTestCopyStrongPopertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
}

- (void)initAry {
    self.vcType = ZJBaseTableViewTypeExecute;
    self.cellTitles = @[@"test0", @"test1", @"test2"];
}

/*
 2023-05-17 19:26:09.710387+0800 ZJIOS[84774:4388516] string源_不可变: 0x600003f1eca0---__NSCFString---呵呵哈哈哈或
 2023-05-17 19:26:09.710603+0800 ZJIOS[84774:4388516] _str_copy:     0x600003f1eca0---__NSCFString---呵呵哈哈哈或
 2023-05-17 19:26:09.710741+0800 ZJIOS[84774:4388516] _str_strong:   0x600003f1eca0---__NSCFString---呵呵哈哈哈或
 2023-05-17 19:26:09.710865+0800 ZJIOS[84774:4388516] _mutStr_copy:   0x600003f1eca0---__NSCFString---呵呵哈哈哈或
 2023-05-17 19:26:09.711011+0800 ZJIOS[84774:4388516] _mutStr_strong: 0x600003f1eca0---__NSCFString---呵呵哈哈哈或
 2023-05-17 19:26:09.711148+0800 ZJIOS[84774:4388516] self.str_copy:      0x600003f1eca0--__NSCFString--呵呵哈哈哈或
 2023-05-17 19:26:09.711295+0800 ZJIOS[84774:4388516] self.str_strong:    0x600003f1eca0--__NSCFString--呵呵哈哈哈或
 2023-05-17 19:26:09.711424+0800 ZJIOS[84774:4388516] self.mutStr_copy:    0x600003f1eca0--__NSCFString--呵呵哈哈哈或
 2023-05-17 19:26:09.711561+0800 ZJIOS[84774:4388516] self.mustr_strong:  0x600003f1eca0--__NSCFString--呵呵哈哈哈或
 2023-05-17 19:26:09.711711+0800 ZJIOS[84774:4388516] -----------修改源------------
 2023-05-17 19:26:09.711860+0800 ZJIOS[84774:4388516] string源_不可变:      0x600003f1bba0---__NSCFString---呵呵哈哈哈或222
 2023-05-17 19:26:09.712038+0800 ZJIOS[84774:4388516] _str_copy:     0x600003f1eca0---__NSCFString---呵呵哈哈哈或
 2023-05-17 19:26:09.712344+0800 ZJIOS[84774:4388516] _str_strong:   0x600003f1eca0---__NSCFString---呵呵哈哈哈或
 2023-05-17 19:26:09.715568+0800 ZJIOS[84774:4388516] _mutStr_copy:   0x600003f1eca0---__NSCFString---呵呵哈哈哈或
 2023-05-17 19:26:09.715717+0800 ZJIOS[84774:4388516] _mutStr_strong: 0x600003f1eca0---__NSCFString---呵呵哈哈哈或
 2023-05-17 19:26:09.715865+0800 ZJIOS[84774:4388516] self.str_copy:      0x600003f1eca0--__NSCFString--呵呵哈哈哈或
 2023-05-17 19:26:09.716011+0800 ZJIOS[84774:4388516] self.str_strong:    0x600003f1eca0--__NSCFString--呵呵哈哈哈或
 2023-05-17 19:26:09.716131+0800 ZJIOS[84774:4388516] self.mutStr_copy:    0x600003f1eca0--__NSCFString--呵呵哈哈哈或
 2023-05-17 19:26:09.716243+0800 ZJIOS[84774:4388516] self.mustr_strong:  0x600003f1eca0--__NSCFString--呵呵哈哈哈或
 */
/*
 源字符串为不可变，无论copy还是strong，都是浅复制，仅复制指针。
 当其修改内容时，会开辟一块新的内存，有新的指针。而self.str_copy 、self.str_strong、 self.mustr_strong 、self.mutStr_copy 指向的地址不会发生改变。
 */
- (void)test0 {
    NSString *string = [NSString stringWithFormat:@"呵呵哈哈哈或"];
    self.str_copy = string;
    self.str_strong = string;
    
    self.mutStr_copy = string;
    self.mutStr_strong = string;
    
    NSLog(@"string源_不可变: %p---%@---%@", string, string.class, string);
    [self printAct];
    
    NSLog(@"-----------修改源------------");
    string = [NSString stringWithFormat:@"呵呵哈哈哈或222"];
    
    NSLog(@"string源_不可变:      %p---%@---%@", string, string.class, string);
    [self printAct];
}

/*
 2023-05-17 19:26:46.292127+0800 ZJIOS[84826:4390393] 源string_mutable:      0x600003779e30---__NSCFString---呵呵哈哈哈或
 2023-05-17 19:26:46.292288+0800 ZJIOS[84826:4390393] _str_copy:     0x6000037795c0---__NSCFString---呵呵哈哈哈或
 2023-05-17 19:26:46.292405+0800 ZJIOS[84826:4390393] _str_strong:   0x600003779e30---__NSCFString---呵呵哈哈哈或
 2023-05-17 19:26:46.292499+0800 ZJIOS[84826:4390393] _mutStr_copy:   0x60000377ae20---__NSCFString---呵呵哈哈哈或
 2023-05-17 19:26:46.292631+0800 ZJIOS[84826:4390393] _mutStr_strong: 0x600003779e30---__NSCFString---呵呵哈哈哈或
 2023-05-17 19:26:46.292764+0800 ZJIOS[84826:4390393] self.str_copy:      0x6000037795c0--__NSCFString--呵呵哈哈哈或
 2023-05-17 19:26:46.292879+0800 ZJIOS[84826:4390393] self.str_strong:    0x600003779e30--__NSCFString--呵呵哈哈哈或
 2023-05-17 19:26:46.293006+0800 ZJIOS[84826:4390393] self.mutStr_copy:    0x60000377ae20--__NSCFString--呵呵哈哈哈或
 2023-05-17 19:26:46.293118+0800 ZJIOS[84826:4390393] self.mustr_strong:  0x600003779e30--__NSCFString--呵呵哈哈哈或
 2023-05-17 19:26:46.293242+0800 ZJIOS[84826:4390393] -----------修改源------------
 2023-05-17 19:26:46.293372+0800 ZJIOS[84826:4390393] 源string_mutable:      0x600003779e30---__NSCFString---呵呵哈哈哈或111
 2023-05-17 19:26:46.293491+0800 ZJIOS[84826:4390393] _str_copy:     0x6000037795c0---__NSCFString---呵呵哈哈哈或
 2023-05-17 19:26:46.293628+0800 ZJIOS[84826:4390393] _str_strong:   0x600003779e30---__NSCFString---呵呵哈哈哈或111
 2023-05-17 19:26:46.297130+0800 ZJIOS[84826:4390393] _mutStr_copy:   0x60000377ae20---__NSCFString---呵呵哈哈哈或
 2023-05-17 19:26:46.297277+0800 ZJIOS[84826:4390393] _mutStr_strong: 0x600003779e30---__NSCFString---呵呵哈哈哈或111
 2023-05-17 19:26:46.297391+0800 ZJIOS[84826:4390393] self.str_copy:      0x6000037795c0--__NSCFString--呵呵哈哈哈或
 2023-05-17 19:26:46.297523+0800 ZJIOS[84826:4390393] self.str_strong:    0x600003779e30--__NSCFString--呵呵哈哈哈或111
 2023-05-17 19:26:46.297644+0800 ZJIOS[84826:4390393] self.mutStr_copy:    0x60000377ae20--__NSCFString--呵呵哈哈哈或
 2023-05-17 19:26:46.297753+0800 ZJIOS[84826:4390393] self.mustr_strong:  0x600003779e30--__NSCFString--呵呵哈哈哈或111
 */

/*
 源字符串为可变字符串
 修改源字符串，地址不会改变
 分别赋值给(copy/strong)的(字符串/可变字符串)变量，self属性赋值
 self.str_copy、self.mutStr_copy 赋值之后两个属性都重新生成了一块地址，是深复制。经过copy修饰过的可变字符串(属性定义时的copy关键字)，变为不可变字符串
 
 copy修饰的可变/不可变字符串(属性定义时的copy关键字)会开辟一块新地址
 strong修饰的可变/不可变字符串不会开辟新地址
 */
- (void)test1 {
    NSMutableString *string = [[NSMutableString alloc] initWithString:@"呵呵哈哈哈或"];
    self.str_copy = string;
    self.str_strong = string;
    
    self.mutStr_strong = string;
    self.mutStr_copy = string;
    
    NSLog(@"源string_mutable:      %p---%@---%@", string, string.class, string);
    [self printAct];
    
    NSLog(@"-----------修改源------------");
    [string appendString:@"111"];
    NSLog(@"源string_mutable:      %p---%@---%@", string, string.class, string);
    [self printAct];

    /*
     Length 6
     IsEightBit 0
     HasLengthByte 0
     HasNullByte 0
     InlineContents 1
     Allocator SystemDefault
     Mutable 0 // 为不可变字符串
     Contents 0x6000015dc288
     */
    CFShowStr((CFStringRef)self.mutStr_copy);
//    [self.mutStr_copy appendString:@"222"]; // 会崩溃
}

/*
 2023-05-17 19:25:27.006602+0800 ZJIOS[84774:4388516] 源字符串_mutable:   0x600003f1da70--__NSCFString--hello baby!
 2023-05-17 19:25:27.006788+0800 ZJIOS[84774:4388516] _str_copy:     0x600003f1da70---__NSCFString---hello baby!
 2023-05-17 19:25:27.006909+0800 ZJIOS[84774:4388516] _str_strong:   0x600003f1da70---__NSCFString---hello baby!
 2023-05-17 19:25:27.007062+0800 ZJIOS[84774:4388516] _mutStr_copy:   0x600003f1da70---__NSCFString---hello baby!
 2023-05-17 19:25:27.007219+0800 ZJIOS[84774:4388516] _mutStr_strong: 0x600003f1da70---__NSCFString---hello baby!
 2023-05-17 19:25:27.007406+0800 ZJIOS[84774:4388516] self.str_copy:      0x600003f1da70--__NSCFString--hello baby!
 2023-05-17 19:25:27.007555+0800 ZJIOS[84774:4388516] self.str_strong:    0x600003f1da70--__NSCFString--hello baby!
 2023-05-17 19:25:27.007700+0800 ZJIOS[84774:4388516] self.mutStr_copy:    0x600003f1da70--__NSCFString--hello baby!
 2023-05-17 19:25:27.007833+0800 ZJIOS[84774:4388516] self.mustr_strong:  0x600003f1da70--__NSCFString--hello baby!
 2023-05-17 19:25:27.007967+0800 ZJIOS[84774:4388516] -----------修改源------------
 2023-05-17 19:25:27.008119+0800 ZJIOS[84774:4388516] 源字符串_mutable:   0x600003f1da70--__NSCFString--hello baby!hello meimei
 2023-05-17 19:25:27.008291+0800 ZJIOS[84774:4388516] _str_copy:     0x600003f1da70---__NSCFString---hello baby!hello meimei
 2023-05-17 19:25:27.008439+0800 ZJIOS[84774:4388516] _str_strong:   0x600003f1da70---__NSCFString---hello baby!hello meimei
 2023-05-17 19:25:27.013603+0800 ZJIOS[84774:4388516] _mutStr_copy:   0x600003f1da70---__NSCFString---hello baby!hello meimei
 2023-05-17 19:25:27.013726+0800 ZJIOS[84774:4388516] _mutStr_strong: 0x600003f1da70---__NSCFString---hello baby!hello meimei
 2023-05-17 19:25:27.013819+0800 ZJIOS[84774:4388516] self.str_copy:      0x600003f1da70--__NSCFString--hello baby!hello meimei
 2023-05-17 19:25:27.013923+0800 ZJIOS[84774:4388516] self.str_strong:    0x600003f1da70--__NSCFString--hello baby!hello meimei
 2023-05-17 19:25:27.014042+0800 ZJIOS[84774:4388516] self.mutStr_copy:    0x600003f1da70--__NSCFString--hello baby!hello meimei
 2023-05-17 19:25:27.014144+0800 ZJIOS[84774:4388516] self.mustr_strong:  0x600003f1da70--__NSCFString--hello baby!hello meimei
 2023-05-17 19:25:27.014243+0800 ZJIOS[84774:4388516] self.mutStr_copy:    0x600003f1da70--__NSCFString--hello baby!hello meimei222
 */

/*
 成员变量赋值(copy/strong)的变量都不会开辟新的地址，
 */
/*
 当我们用self.str_copy = originString赋值时，会调用str_copy的setter方法，在setter方法中有一个非常关键的语句：_str_copy = [str_copy copy];
 用self.str_copy = originString 赋值时，调用str_copy的setter方法，setter方法对传入的str_copy做了次深拷贝生成了一个新的对象赋值给_str_copy
 所以_str_copy指向的地址和对象值都不再和originString相同。
 而_str_copy = originString赋值时，直接对成员变量进行赋值，并不会调用str_copy的setter方法
 所以此时的地址都不会改变
 */
- (void)test2 {
    NSMutableString *originString = @"hello baby!".mutableCopy;
    _str_copy = originString;
    _str_strong = originString;
    
    _mutStr_copy = originString;
    _mutStr_strong = originString;
    
    NSLog(@"源字符串_mutable:   %p--%@--%@", originString, originString.class, originString);
    [self printAct];
    
    NSLog(@"-----------修改源------------");
    [originString appendString:@"hello meimei"];
    
    NSLog(@"源字符串_mutable:   %p--%@--%@", originString, originString.class, originString);
    [self printAct];
    [self.mutStr_copy appendString:@"222"]; // 不会崩溃
    NSLog(@"self.mutStr_copy:    %p--%@--%@", self.mutStr_copy, self.mutStr_copy.class, self.mutStr_copy);


}

- (void)printAct {
    [self printMethod1];
    [self printMethod2];
}

// 打印方法
- (void)printMethod1 {
    NSLog(@"_str_copy:     %p---%@---%@", _str_copy, _str_copy.class, _str_copy);
    NSLog(@"_str_strong:   %p---%@---%@", _str_strong, _str_strong.class ,_str_strong);
    
    NSLog(@"_mutStr_copy:   %p---%@---%@", _mutStr_copy, _mutStr_copy.class, _mutStr_copy);
    NSLog(@"_mutStr_strong: %p---%@---%@", _mutStr_strong, _mutStr_strong.class, _mutStr_strong);
}

- (void)printMethod2 {
    NSLog(@"self.str_copy:      %p--%@--%@", self.str_copy, self.str_copy.class, self.str_copy);
    NSLog(@"self.str_strong:    %p--%@--%@", self.str_strong, self.str_strong.class, self.str_strong);
    
    NSLog(@"self.mutStr_copy:    %p--%@--%@", self.mutStr_copy, self.mutStr_copy.class, self.mutStr_copy);
    NSLog(@"self.mustr_strong:  %p--%@--%@", self.mutStr_strong, self.mutStr_strong.class, self.mutStr_strong);
}

/*
 总结:
 1.当原字符串是NSString时，由于是不可变字符串，所以，不管使用strong还是copy修饰，都是指向原来的对象，copy操作只是做了一次浅拷贝。
 而当源字符串是NSMutableString时，strong只是将源字符串的引用计数加1，而copy则是对原字符串做了次深拷贝，从而生成了一个新的对象，并且copy的对象指向这个新对象。
 另外需要注意的是，这个copy属性对象的类型始终是NSString，而不是NSMutableString，如果想让拷贝过来的对象是可变的，就要使用mutableCopy。
 所以，如果源字符串是NSMutableString的时候，使用strong只会增加引用计数。
 但是copy会执行一次深拷贝，会造成不必要的内存浪费。而如果原字符串是NSString时，strong和copy效果一样，就不会有这个问题。
 但是，我们一般声明NSString时，也不希望它改变，所以一般情况下，建议使用copy，这样可以避免NSMutableString带来的错误。
 
 
 2.不管是集合类对象（NSArray、NSDictionary、NSSet ... 之类的对象），还是非集合类对象（NSString, NSNumber ... 之类的对象），接收到copy和mutableCopy消息时，都遵循以下准则：
 1.copy 返回的是不可变对象（immutableObject）；如果用copy返回值调用mutable对象的方法就会crash。
 2.mutableCopy 返回的是可变对象（mutableObject）
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
