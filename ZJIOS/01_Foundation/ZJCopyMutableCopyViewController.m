//
//  ZJCopyMutableCopyViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/16.
//

#import "ZJCopyMutableCopyViewController.h"

@interface ZJCopyMutableCopyViewController ()

@property (nonatomic, copy) NSMutableArray *mArry;

@end

@implementation ZJCopyMutableCopyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self test1];
    [self test2];
//    [self test3];
//    [self test4];
}
/*copy的特点
 修改源对象的属性和行为，不会影响副本对象
 修改副本对象的属性和行为，不会影响源对象
 那为什么NSString *str2 = [str1 copy];是不同的指针指向同一块内存空间，str1 从新赋值 后两个内存空间就不一样了呢？

 因为str2 = str1的时候，两个字符串都是不可变的，指向的同一块内存空间中的 @"str1",是不可能变成@"abcd"的。所以这个时候，为了优化性能，系统没必要另外提供内存，只生成另外一个指针，指向同一块内存空间就行。
 但是当你从新给 str1 或者str2赋值的时候，因为之前的内容不可变，还有互不影响的原则下，这个时候，系统会从新开辟一块内存空间。
 */
/*
 2021-06-16 23:06:05.543495+0800 ZJIOS[11226:903367] str1, 0x10a7f3188
 2021-06-16 23:06:05.543694+0800 ZJIOS[11226:903367] str1, 0x10a7f3188
 2021-06-16 23:06:05.543841+0800 ZJIOS[11226:903367] asdf, 0x10a7f31c8
 2021-06-16 23:06:05.543971+0800 ZJIOS[11226:903367] str1, 0x10a7f3188

 */
- (void)test1 {
    NSString *str1 = @"str1";
    NSString *str2 = [str1 copy];
    NSLog(@"%@, %p", str1, str1);
    NSLog(@"%@, %p", str2, str2);
    str1 = @"asdf";
    NSLog(@"%@, %p", str1, str1);
    NSLog(@"%@, %p", str2, str2);
}

/*
 2021-06-17 10:33:43.955410+0800 ZJIOS[12282:988245] (
     123,
     456,
     asd
 ), 0x600002364f30, __NSArrayM
 2021-06-17 10:33:43.955643+0800 ZJIOS[12282:988245] (
     123,
     456,
     asd
 ), 0x600002367120, __NSArrayI
 2021-06-17 10:33:43.955877+0800 ZJIOS[12282:988245] (
     123,
     456,
     asd
 ), 0x600002367150, __NSArrayM

 从结果看出，内存地址不一样，而且mArr2 是不可变的。copy为什么不是指针指向了？
 首先，mArr2是通过copy 得来的，关键点在于copy，和mArr1 无关，所以他是不可变的。
 另外，mArr1指向的内存空间是可变的，如果对mArr1进行修改，同一内存空间的内容就会变化。 遵循相会不影响的原则，加上mArr2是不可变的，mArr1 的内存空间已经不合适，所以此时的 copy从新开辟内存空间。
 */
- (void)test2 {
    NSMutableArray *mArr1 = [@[@"123", @"456", @"asd"] mutableCopy];
    NSMutableArray *mArr2 = [mArr1 copy];           //copy出来的为不可变数组
    NSMutableArray *mArr3 = [mArr1 mutableCopy];    // mutableCopy出来的为可变数组
    NSLog(@"%@, %p, %@", mArr1, mArr1, [mArr1 class]);
    NSLog(@"%@, %p, %@", mArr2, mArr2, [mArr2 class]);
    NSLog(@"%@, %p, %@", mArr3, mArr3, [mArr3 class]);
    [mArr1 addObject:@"hehe"];
}

/*
 2021-06-16 23:26:31.271614+0800 ZJIOS[11402:918005] (
     123,
     456,
     asd
 ), 0x6000002fd6b0, __NSArrayI
 2021-06-16 23:26:31.271824+0800 ZJIOS[11402:918005] (
     123,
     456,
     asd
 ), 0x6000002fd9e0, __NSArrayI
 可以看出内存地址不一样，但是_mArr 是不可变的数组。
 因为 _mArr声明的时候是用 copy修饰，那么就限制了它只能是不可变的数组。 赋值的时候是用mutableCopy,可变数组的复制方法，所以会从新分配内存。
 */
- (void)test3 {
    NSArray *arr = @[@"123", @"456", @"asd"];
    self.mArry = [arr mutableCopy];
    NSLog(@"%@, %p, %@", arr, arr, [arr class]);
    NSLog(@"%@, %p, %@", self.mArry, self.mArry, [self.mArry class]);
//    [self.mArry addObject:@"aa"]; 加上这一句程序这里会崩溃
}

/*
 2021-06-17 00:07:08.175300+0800 ZJIOS[11598:937940] ary1--(
     123,
     456,
     789
 ), 0x600001344060, __NSArrayI
 2021-06-17 00:07:08.175475+0800 ZJIOS[11598:937940] ary2--(
     123,
     456,
     789
 ), 0x600001344060, __NSArrayI
 2021-06-17 00:07:08.175616+0800 ZJIOS[11598:937940] ary3--(
     123,
     456,
     789
 ), 0x6000013442d0, __NSArrayM
 */

/*
 2021-06-17 00:09:12.518751+0800 ZJIOS[11620:939548] ary1-->123, 0x1000f71e8
 2021-06-17 00:09:12.518919+0800 ZJIOS[11620:939548] ary1-->456, 0x1000f7208
 2021-06-17 00:09:12.519090+0800 ZJIOS[11620:939548] ary1-->789, 0x1000f7288
 
 2021-06-17 00:09:12.519215+0800 ZJIOS[11620:939548] ary3-->123, 0x1000f71e8
 2021-06-17 00:09:12.519335+0800 ZJIOS[11620:939548] ary3-->456, 0x1000f7208
 2021-06-17 00:09:12.519459+0800 ZJIOS[11620:939548] ary3-->789, 0x1000f7288
 */
- (void)test4 {
    NSArray *ary1 = @[@"123", @"456", @"789"];
    NSArray *ary2 = ary1.copy;
    NSArray *ary3 = ary1.mutableCopy;   // 深拷贝，内存地址变化,里面的元素地址还是没有变
    NSLog(@"ary1--%@, %p, %@", ary1, ary1, [ary1 class]);
    NSLog(@"ary2--%@, %p, %@", ary2, ary2, [ary2 class]);
    NSLog(@"ary3--%@, %p, %@", ary3, ary3, [ary3 class]);
    for (NSString *obj in ary1) {
        NSLog(@"ary1-->%@, %p", obj, obj);
    }
    for (NSString *obj in ary3) {
        NSLog(@"ary3-->%@, %p", obj, obj);
    }
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
