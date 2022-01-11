//
//  ZJTestCopyStrongViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/1/10.
//

#import "ZJTestCopyStrongViewController.h"

@interface ZJTestCopyStrongViewController ()

@property (nonatomic, copy) NSString *str_copy;
@property (nonatomic, strong) NSString *str_strong;
@property (nonatomic, strong) NSMutableString *mustr_strong;
@property (nonatomic, copy) NSMutableString *mustr_copy;

@end

@implementation ZJTestCopyStrongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test3];
}

/*
 2022-01-10 18:16:20.897188+0800 ZJIOS[43844:1094038] string源:      0x600002c7b390---__NSCFString---123456789000
 2022-01-10 18:16:20.897446+0800 ZJIOS[43844:1094038] _str_copy:     0x6000022a5880---__NSCFString---123456789000
 2022-01-10 18:16:20.897625+0800 ZJIOS[43844:1094038] _str_strong:   0x600002c7b390---__NSCFString---123456789000
 2022-01-10 18:16:20.897792+0800 ZJIOS[43844:1094038] _mustr_copy:   0x6000022a6e60---__NSCFString---123456789000
 2022-01-10 18:16:20.897971+0800 ZJIOS[43844:1094038] _mustr_strong: 0x600002c7b390---__NSCFString---123456789000
 2022-01-10 18:16:20.898148+0800 ZJIOS[43844:1094038] -----------修改源------------
 2022-01-10 18:16:20.898312+0800 ZJIOS[43844:1094038] string源:      0x600002c7b390---__NSCFString---123456789000qwertyuiosdfghj
 2022-01-10 18:16:20.898425+0800 ZJIOS[43844:1094038] _str_copy:     0x6000022a5880---__NSCFString---123456789000
 2022-01-10 18:16:20.898562+0800 ZJIOS[43844:1094038] _str_strong:   0x600002c7b390---__NSCFString---123456789000qwertyuiosdfghj
 2022-01-10 18:16:20.898669+0800 ZJIOS[43844:1094038] _mustr_copy:   0x6000022a6e60---__NSCFString---123456789000
 2022-01-10 18:16:20.898808+0800 ZJIOS[43844:1094038] _mustr_strong: 0x600002c7b390---__NSCFString---123456789000qwertyuiosdfghj
 */
- (void)testMutabStr {
    NSMutableString *string = [[NSMutableString alloc]initWithString:@"123456789000"];
    self.str_copy = string;
    self.str_strong = string;
    self.mustr_strong = string;
    self.mustr_copy = string;
    //    [mustr_copy appendString:@"qwertyuiosdfghj"] 会崩溃
    NSLog(@"string源:      %p---%@---%@", string, string.class, string);
    [self printMethod];
    NSLog((@"-----------修改源------------"));
    [string appendString:@"qwertyuiosdfghj"];
    NSLog(@"string源:      %p---%@---%@", string, string.class, string);
    [self printMethod];
}
/*
 可见对于可变的源字符串,修改内容时候，指针地址不会改变，为原地址。
 str_copy、self.mustr_copy 赋值之后重新生成了一块地址，是深复制。经过copy修饰过的可变字符串，变为不可变字符串
 */


/*
 2022-01-10 18:25:42.674118+0800 ZJIOS[44058:1101200] string源:      0x600002a768e0---__NSCFString---123456789000
 2022-01-10 18:25:42.674390+0800 ZJIOS[44058:1101200] _str_copy:     0x600002a768e0---__NSCFString---123456789000
 2022-01-10 18:25:42.674598+0800 ZJIOS[44058:1101200] _str_strong:   0x600002a768e0---__NSCFString---123456789000
 2022-01-10 18:25:42.674781+0800 ZJIOS[44058:1101200] _mustr_copy:   0x600002a768e0---__NSCFString---123456789000
 2022-01-10 18:25:42.674974+0800 ZJIOS[44058:1101200] _mustr_strong: 0x600002a768e0---__NSCFString---123456789000
 2022-01-10 18:25:42.675227+0800 ZJIOS[44058:1101200] ____________修改源________________
 2022-01-10 18:25:42.675473+0800 ZJIOS[44058:1101200] string源:      0x600002431140---__NSCFString---qwertyuiosdfghj
 2022-01-10 18:25:42.675698+0800 ZJIOS[44058:1101200] _str_copy:     0x600002a768e0---__NSCFString---123456789000
 2022-01-10 18:25:42.675921+0800 ZJIOS[44058:1101200] _str_strong:   0x600002a768e0---__NSCFString---123456789000
 2022-01-10 18:25:42.676076+0800 ZJIOS[44058:1101200] _mustr_copy:   0x600002a768e0---__NSCFString---123456789000
 2022-01-10 18:25:42.676259+0800 ZJIOS[44058:1101200] _mustr_strong: 0x600002a768e0---__NSCFString---123456789000
 */
- (void)testNoMutabStr {
    NSString *string = [NSString stringWithFormat:@"123456789000"];
    self.str_copy = string;
    self.str_strong = string;
    self.mustr_copy = string;
    self.mustr_strong = string;
    NSLog(@"string源:      %p---%@---%@", string, string.class, string);
    [self printMethod];
    NSLog(@"____________修改源________________");
    string = [NSString stringWithFormat:@"qwertyuiosdfghj"];
    NSLog(@"string源:      %p---%@---%@", string, string.class, string);
    [self printMethod];
}
/*
 可见对于不可变的源字符串，无论copy还是strong，都是浅复制，仅复制指针。NSString 修改内容时，会开辟一块新的内存，有新的指针。而str_copy 、self.str_strong、 self.mustr_strong 、self.mustr_copy 指向的地址不会发生改变。
 */


/*
 2022-01-11 16:43:34.214027+0800 ZJIOS[55007:1370627] 0x6000012d7ae0--0x7ffee81becb8--__NSCFString--hello baby!
 2022-01-11 16:43:34.214301+0800 ZJIOS[55007:1370627] 0x6000012d7ae0--0x7fcc94f22210--__NSCFString--hello baby!
 2022-01-11 16:43:34.214465+0800 ZJIOS[55007:1370627] 0x6000012d7ae0--0x7fcc94f22218--__NSCFString--hello baby!
 2022-01-11 16:43:34.214652+0800 ZJIOS[55007:1370627] ____________修改源________________
 2022-01-11 16:43:34.214841+0800 ZJIOS[55007:1370627] 0x6000012d7ae0--0x7ffee81becb8--__NSCFString--hello baby!hello meimei
 2022-01-11 16:43:34.215000+0800 ZJIOS[55007:1370627] 0x6000012d7ae0--0x7fcc94f22210--__NSCFString--hello baby!hello meimei
 2022-01-11 16:43:34.215143+0800 ZJIOS[55007:1370627] 0x6000012d7ae0--0x7fcc94f22218--__NSCFString--hello baby!hello meimei
 */
- (void)test2 {
    NSMutableString *originString = @"hello baby!".mutableCopy;
    _str_copy = originString;
    _str_strong = originString;
    NSLog(@"%p--%p--%@--%@", originString, &originString, originString.class, originString);
    [self printMethod2];
    
    NSLog(@"____________修改源________________");
    [originString appendString:@"hello meimei"];
    NSLog(@"%p--%p--%@--%@", originString, &originString, originString.class, originString);
    [self printMethod2];
}

/*
 2022-01-11 17:03:48.226370+0800 ZJIOS[55310:1383421] 0x600001264b10--0x7ffee61c0cb8--__NSCFString--hello baby!
 2022-01-11 17:03:48.226568+0800 ZJIOS[55310:1383421] 0x600001c418a0--0x7fc7b2f2f220--__NSCFString--hello baby!
 2022-01-11 17:03:48.226672+0800 ZJIOS[55310:1383421] 0x600001264b10--0x7fc7b2f2f228--__NSCFString--hello baby!
 2022-01-11 17:03:48.226775+0800 ZJIOS[55310:1383421] ____________修改源________________
 2022-01-11 17:03:48.226878+0800 ZJIOS[55310:1383421] 0x600001264b10--0x7ffee61c0cb8--__NSCFString--hello baby!hello meimei
 2022-01-11 17:03:48.226993+0800 ZJIOS[55310:1383421] 0x600001c418a0--0x7fc7b2f2f220--__NSCFString--hello baby!
 2022-01-11 17:03:48.227078+0800 ZJIOS[55310:1383421] 0x600001264b10--0x7fc7b2f2f228--__NSCFString--hello baby!hello meimei
 */
- (void)test3 {
    NSMutableString *originString = @"hello baby!".mutableCopy;
    self.str_copy = originString;
    self.str_strong = originString;
    NSLog(@"%p--%p--%@--%@", originString, &originString, originString.class, originString);
    [self printMethod2];
    
    NSLog(@"____________修改源________________");
    [originString appendString:@"hello meimei"];
    NSLog(@"%p--%p--%@--%@", originString, &originString, originString.class, originString);
    [self printMethod2];
}
/*
 当我们用self.str_copy = originString赋值时，会调用str_copy的setter方法，而_str_copy = originString赋值时，并不会调用str_copy的setter方法
 而在setter方法中有一个非常关键的语句：_str_copy = [str_copy copy];用self.str_copy = originString 赋值时，调用str_copy的setter方法，
 setter方法对传入的str_copy做了次深拷贝生成了一个新的对象赋值给_str_copy，所以_str_copy指向的地址和对象值都不再和originString相同。如果用实例变量直接赋值则地址不会改变
 */

/*
 2022-01-11 17:03:48.226370+0800 ZJIOS[55310:1383421] 0x600001264b10--0x7ffee61c0cb8--__NSCFString--hello baby!
 2022-01-11 17:03:48.226568+0800 ZJIOS[55310:1383421] 0x600001c418a0--0x7fc7b2f2f220--__NSCFString--hello baby!
 2022-01-11 17:03:48.226672+0800 ZJIOS[55310:1383421] 0x600001264b10--0x7fc7b2f2f228--__NSCFString--hello baby!
 2022-01-11 17:03:48.226775+0800 ZJIOS[55310:1383421] ____________修改源________________
 2022-01-11 17:03:48.226878+0800 ZJIOS[55310:1383421] 0x600001264b10--0x7ffee61c0cb8--__NSCFString--hello baby!hello meimei
 2022-01-11 17:03:48.226993+0800 ZJIOS[55310:1383421] 0x600001c418a0--0x7fc7b2f2f220--__NSCFString--hello baby!
 2022-01-11 17:03:48.227078+0800 ZJIOS[55310:1383421] 0x600001264b10--0x7fc7b2f2f228--__NSCFString--hello baby!hello meimei
 */
- (void)printMethod2 {
    NSLog(@"%p--%p--%@--%@", self.str_copy, &_str_copy, self.str_copy.class, self.str_copy);
    NSLog(@"%p--%p--%@--%@", self.str_strong, &_str_strong, self.str_strong.class, self.str_strong);
}

/*
 总结:
 1.当原字符串是NSString时，由于是不可变字符串，所以，不管使用strong还是copy修饰，都是指向原来的对象，copy操作只是做了一次浅拷贝。
 而当源字符串是NSMutableString时，strong只是将源字符串的引用计数加1，而copy则是对原字符串做了次深拷贝，从而生成了一个新的对象，并且copy的对象指向这个新对象。另外需要注意的是，这个copy属性对象的类型始终是NSString，而不是NSMutableString，如果想让拷贝过来的对象是可变的，就要使用mutableCopy。
 所以，如果源字符串是NSMutableString的时候，使用strong只会增加引用计数。
 但是copy会执行一次深拷贝，会造成不必要的内存浪费。而如果原字符串是NSString时，strong和copy效果一样，就不会有这个问题。
 但是，我们一般声明NSString时，也不希望它改变，所以一般情况下，建议使用copy，这样可以避免NSMutableString带来的错误。
 
 
 2.不管是集合类对象（NSArray、NSDictionary、NSSet ... 之类的对象），还是非集合类对象（NSString, NSNumber ... 之类的对象），接收到copy和mutableCopy消息时，都遵循以下准则：
 1.copy 返回的是不可变对象（immutableObject）；如果用copy返回值调用mutable对象的方法就会crash。
 2.mutableCopy 返回的是可变对象（mutableObject）
 */
// 打印方法
- (void)printMethod {
    NSLog(@"_str_copy:     %p---%@---%@", _str_copy, _str_copy.class, _str_copy);
    NSLog(@"_str_strong:   %p---%@---%@", _str_strong, _str_strong.class ,_str_strong);
    NSLog(@"_mustr_copy:   %p---%@---%@", _mustr_copy, _mustr_copy.class, _mustr_copy);
    NSLog(@"_mustr_strong: %p---%@---%@", _mustr_strong, _mustr_strong.class, _mustr_strong);
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
