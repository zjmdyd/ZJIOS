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
    
    [self test2];
}

/*
 2022-05-14 18:42:44.657358+0800 ZJIOS[2890:81210] string源_不可变:        0x600001180420---__NSCFString---呵呵哈哈哈或

 2022-05-14 18:42:44.657545+0800 ZJIOS[2890:81210] _str_copy:     0x600001180420---__NSCFString---呵呵哈哈哈或
 2022-05-14 18:42:44.657677+0800 ZJIOS[2890:81210] _str_strong:   0x600001180420---__NSCFString---呵呵哈哈哈或

 2022-05-14 18:42:44.657791+0800 ZJIOS[2890:81210] _mutStr_copy:   0x600001180420---__NSCFString---呵呵哈哈哈或
 2022-05-14 18:42:44.657910+0800 ZJIOS[2890:81210] _mutStr_strong: 0x600001180420---__NSCFString---呵呵哈哈哈或

 2022-05-14 18:42:44.658015+0800 ZJIOS[2890:81210] self.str_copy:      0x600001180420--__NSCFString--呵呵哈哈哈或
 2022-05-14 18:42:44.658128+0800 ZJIOS[2890:81210] self.str_strong:    0x600001180420--__NSCFString--呵呵哈哈哈或

 2022-05-14 18:42:44.658235+0800 ZJIOS[2890:81210] self.mustr_copy:    0x600001180420--__NSCFString--呵呵哈哈哈或
 2022-05-14 18:42:44.658338+0800 ZJIOS[2890:81210] self.mustr_strong:  0x600001180420--__NSCFString--呵呵哈哈哈或

 2022-05-14 18:42:44.658460+0800 ZJIOS[2890:81210] -----------修改源------------
 2022-05-14 18:42:44.658605+0800 ZJIOS[2890:81210] string源_不可变:      0x600001171110---__NSCFString---呵呵哈哈哈或222

 2022-05-14 18:42:44.658711+0800 ZJIOS[2890:81210] _str_copy:     0x600001180420---__NSCFString---呵呵哈哈哈或
 2022-05-14 18:42:44.658899+0800 ZJIOS[2890:81210] _str_strong:   0x600001180420---__NSCFString---呵呵哈哈哈或

 2022-05-14 18:42:44.662143+0800 ZJIOS[2890:81210] _mutStr_copy:   0x600001180420---__NSCFString---呵呵哈哈哈或
 2022-05-14 18:42:44.662275+0800 ZJIOS[2890:81210] _mutStr_strong: 0x600001180420---__NSCFString---呵呵哈哈哈或

 2022-05-14 18:42:44.662367+0800 ZJIOS[2890:81210] self.str_copy:      0x600001180420--__NSCFString--呵呵哈哈哈或
 2022-05-14 18:42:44.662443+0800 ZJIOS[2890:81210] self.str_strong:    0x600001180420--__NSCFString--呵呵哈哈哈或

 2022-05-14 18:42:44.662513+0800 ZJIOS[2890:81210] self.mustr_copy:    0x600001180420--__NSCFString--呵呵哈哈哈或
 2022-05-14 18:42:44.662606+0800 ZJIOS[2890:81210] self.mustr_strong:  0x600001180420--__NSCFString--呵呵哈哈哈或
 */
/*
 源字符串为不可变，无论copy还是strong，都是浅复制，仅复制指针。
 当其修改内容时，会开辟一块新的内存，有新的指针。而self.str_copy 、self.str_strong、 self.mustr_strong 、self.mustr_copy 指向的地址不会发生改变。
 */
- (void)test0 {
    NSString *string = [NSString stringWithFormat:@"呵呵哈哈哈或"];
    self.str_copy = string;
    self.str_strong = string;
    
    self.mutStr_copy = string;
    self.mutStr_strong = string;
    
    NSLog(@"string源_不可变:      %p---%@---%@", string, string.class, string);
    [self printAct];
    
    NSLog(@"-----------修改源------------");
    string = [NSString stringWithFormat:@"呵呵哈哈哈或222"];
    
    NSLog(@"string源_不可变:      %p---%@---%@", string, string.class, string);
    [self printAct];
}

/*
 2022-05-14 18:51:12.420712+0800 ZJIOS[3049:87103] 源string_mutable:      0x6000005c07e0---__NSCFString---呵呵哈哈哈或

 2022-05-14 18:51:12.420866+0800 ZJIOS[3049:87103] _str_copy:     0x6000005c0f60---__NSCFString---呵呵哈哈哈或
 2022-05-14 18:51:12.420979+0800 ZJIOS[3049:87103] _str_strong:   0x6000005c07e0---__NSCFString---呵呵哈哈哈或

 2022-05-14 18:51:12.421085+0800 ZJIOS[3049:87103] _mutStr_copy:   0x6000005c06f0---__NSCFString---呵呵哈哈哈或
 2022-05-14 18:51:12.421169+0800 ZJIOS[3049:87103] _mutStr_strong: 0x6000005c07e0---__NSCFString---呵呵哈哈哈或

 2022-05-14 18:51:12.421278+0800 ZJIOS[3049:87103] self.str_copy:      0x6000005c0f60--__NSCFString--呵呵哈哈哈或
 2022-05-14 18:51:12.421355+0800 ZJIOS[3049:87103] self.str_strong:    0x6000005c07e0--__NSCFString--呵呵哈哈哈或

 2022-05-14 18:51:12.421486+0800 ZJIOS[3049:87103] self.mustr_copy:    0x6000005c06f0--__NSCFString--呵呵哈哈哈或
 2022-05-14 18:51:12.421565+0800 ZJIOS[3049:87103] self.mustr_strong:  0x6000005c07e0--__NSCFString--呵呵哈哈哈或

 2022-05-14 18:51:12.421654+0800 ZJIOS[3049:87103] -----------修改源------------
 2022-05-14 18:51:12.421727+0800 ZJIOS[3049:87103] 源string_mutable:      0x6000005c07e0---__NSCFString---呵呵哈哈哈或111

 2022-05-14 18:51:12.421786+0800 ZJIOS[3049:87103] _str_copy:     0x6000005c0f60---__NSCFString---呵呵哈哈哈或
 2022-05-14 18:51:12.421871+0800 ZJIOS[3049:87103] _str_strong:   0x6000005c07e0---__NSCFString---呵呵哈哈哈或111

 2022-05-14 18:51:12.421972+0800 ZJIOS[3049:87103] _mutStr_copy:   0x6000005c06f0---__NSCFString---呵呵哈哈哈或
 2022-05-14 18:51:12.425175+0800 ZJIOS[3049:87103] _mutStr_strong: 0x6000005c07e0---__NSCFString---呵呵哈哈哈或111

 2022-05-14 18:51:12.425295+0800 ZJIOS[3049:87103] self.str_copy:      0x6000005c0f60--__NSCFString--呵呵哈哈哈或
 2022-05-14 18:51:12.425399+0800 ZJIOS[3049:87103] self.str_strong:    0x6000005c07e0--__NSCFString--呵呵哈哈哈或111

 2022-05-14 18:51:12.425499+0800 ZJIOS[3049:87103] self.mustr_copy:    0x6000005c06f0--__NSCFString--呵呵哈哈哈或
 2022-05-14 18:51:12.425595+0800 ZJIOS[3049:87103] self.mustr_strong:  0x6000005c07e0--__NSCFString--呵呵哈哈哈或111
 */

/*
 源字符串为可变字符串
 修改源字符串，地址不会改变
 分别赋值给(copy/strong)的(字符串/可变字符串)变量，self属性赋值
 self.str_copy、self.mutStr_copy 赋值之后两个属性都重新生成了一块地址，是深复制。经过copy修饰过的可变字符串，变为不可变字符串
 
 copy修饰的字符串(可变/不可变)会开辟一块新地址
 strong修饰的字符串(可变/不可变)不会开辟新地址
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
//    [self.mustr_copy appendString:@"222"]; // 会崩溃
}

/*
 2022-05-14 20:42:19.931567+0800 ZJIOS[3972:128700] 源字符串_mutable:   0x600000dddfb0--__NSCFString--hello baby!

 2022-05-14 20:42:19.931728+0800 ZJIOS[3972:128700] _str_copy:     0x600000dddfb0---__NSCFString---hello baby!
 2022-05-14 20:42:19.931819+0800 ZJIOS[3972:128700] _str_strong:   0x600000dddfb0---__NSCFString---hello baby!

 2022-05-14 20:42:19.931900+0800 ZJIOS[3972:128700] _mutStr_copy:   0x600000dddfb0---__NSCFString---hello baby!
 2022-05-14 20:42:19.931993+0800 ZJIOS[3972:128700] _mutStr_strong: 0x600000dddfb0---__NSCFString---hello baby!

 2022-05-14 20:42:19.932086+0800 ZJIOS[3972:128700] self.str_copy:      0x600000dddfb0--__NSCFString--hello baby!
 2022-05-14 20:42:19.932163+0800 ZJIOS[3972:128700] self.str_strong:    0x600000dddfb0--__NSCFString--hello baby!

 2022-05-14 20:42:19.932229+0800 ZJIOS[3972:128700] self.mustr_copy:    0x600000dddfb0--__NSCFString--hello baby!
 2022-05-14 20:42:19.932288+0800 ZJIOS[3972:128700] self.mustr_strong:  0x600000dddfb0--__NSCFString--hello baby!

 2022-05-14 20:42:19.932376+0800 ZJIOS[3972:128700] -----------修改源------------
 2022-05-14 20:42:19.932460+0800 ZJIOS[3972:128700] 源字符串_mutable:   0x600000dddfb0--__NSCFString--hello baby!hello meimei

 2022-05-14 20:42:19.932529+0800 ZJIOS[3972:128700] _str_copy:     0x600000dddfb0---__NSCFString---hello baby!hello meimei
 2022-05-14 20:42:19.932630+0800 ZJIOS[3972:128700] _str_strong:   0x600000dddfb0---__NSCFString---hello baby!hello meimei

 2022-05-14 20:42:19.932754+0800 ZJIOS[3972:128700] _mutStr_copy:   0x600000dddfb0---__NSCFString---hello baby!hello meimei
 2022-05-14 20:42:19.935698+0800 ZJIOS[3972:128700] _mutStr_strong: 0x600000dddfb0---__NSCFString---hello baby!hello meimei

 2022-05-14 20:42:19.935796+0800 ZJIOS[3972:128700] self.str_copy:      0x600000dddfb0--__NSCFString--hello baby!hello meimei
 2022-05-14 20:42:19.935892+0800 ZJIOS[3972:128700] self.str_strong:    0x600000dddfb0--__NSCFString--hello baby!hello meimei

 2022-05-14 20:42:19.935992+0800 ZJIOS[3972:128700] self.mustr_copy:    0x600000dddfb0--__NSCFString--hello baby!hello meimei
 2022-05-14 20:42:19.936067+0800 ZJIOS[3972:128700] self.mustr_strong:  0x600000dddfb0--__NSCFString--hello baby!hello meimei
 */

/*
 成员变量赋值(copy/strong)的变量都不会开辟新的地址，
 */
/*
 当我们用self.str_copy = originString赋值时，会调用str_copy的setter方法，在setter方法中有一个非常关键的语句：_str_copy = [str_copy copy];
 用self.str_copy = originString 赋值时，调用str_copy的setter方法，setter方法对传入的str_copy做了次深拷贝生成了一个新的对象赋值给_str_copy
 所以_str_copy指向的地址和对象值都不再和originString相同。
 而_str_copy = originString赋值时，直接对实例变量进行赋值，并不会调用str_copy的setter方法
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
    
    NSLog(@"self.mustr_copy:    %p--%@--%@", self.mutStr_copy, self.mutStr_copy.class, self.mutStr_copy);
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
