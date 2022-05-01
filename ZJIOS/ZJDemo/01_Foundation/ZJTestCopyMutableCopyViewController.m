//
//  ZJTestCopyMutableCopyViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/16.
//

#import "ZJTestCopyMutableCopyViewController.h"

@interface ZJTestCopyMutableCopyViewController ()

@property (nonatomic, copy) NSMutableArray *mut_copyArry;

@end

@implementation ZJTestCopyMutableCopyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test4];
}

/*
 2022-01-11 17:27:26.288174+0800 ZJIOS[56060:1405008] str1:哈哈哈哈, 0x10e99f2f8
 2022-01-11 17:27:26.288440+0800 ZJIOS[56060:1405008] str2:哈哈哈哈, 0x10e99f2f8
 2022-01-11 17:27:26.288652+0800 ZJIOS[56060:1405008] --------修改源------------
 2022-01-11 17:27:26.288817+0800 ZJIOS[56060:1405008] str1:呵呵呵呵, 0x10e99f378
 2022-01-11 17:27:26.289027+0800 ZJIOS[56060:1405008] str2:哈哈哈哈, 0x10e99f2f8
 */
- (void)test1 {
    NSString *str1 = @"哈哈哈哈";
    NSString *str2 = [str1 copy];
    NSLog(@"str1:%@, %p", str1, str1);
    NSLog(@"str2:%@, %p", str2, str2);
    NSLog(@"--------修改源------------");
    str1 = @"呵呵呵呵";
    NSLog(@"str1:%@, %p", str1, str1);
    NSLog(@"str2:%@, %p", str2, str2);
}
/*copy的特点
 修改源对象的属性和行为，不会影响副本对象
 修改副本对象的属性和行为，不会影响源对象
 那为什么NSString *str2 = [str1 copy];是不同的指针指向同一块内存空间，str1 重新赋值 后两个内存空间就不一样了呢？
 因为str2 = str1的时候，两个字符串都是不可变的，指向的同一块内存空间中的 @"str1",是不可能变成@"abcd"的。所以这个时候，为了优化性能，系统没必要另外提供内存，只生成另外一个指针，指向同一块内存空间就行。
 但是当你从新给 str1 或者str2赋值的时候，因为之前的内容不可变，还有互不影响的原则下，这个时候，系统会从新开辟一块内存空间。
 */


/*
 2022-01-11 17:41:35.951496+0800 ZJIOS[56376:1417168] (
     123,
     456
 ), 0x6000024b0960, __NSArrayM
 2022-01-11 17:41:35.951764+0800 ZJIOS[56376:1417168] (
     123,
     456
 ), 0x600002aa96c0, __NSArrayI
 2022-01-11 17:41:35.951952+0800 ZJIOS[56376:1417168] (
     123,
     456
 ), 0x6000024b1b00, __NSArrayM
 NSLog(@"--------修改源------------");
 2022-01-11 17:41:35.952142+0800 ZJIOS[56376:1417168] (
     123,
     456,
     hehe
 ), 0x6000024b0960, __NSArrayM
 2022-01-11 17:41:35.952334+0800 ZJIOS[56376:1417168] (
     123,
     456
 ), 0x600002aa96c0, __NSArrayI
 2022-01-11 17:41:35.952494+0800 ZJIOS[56376:1417168] (
     123,
     456
 ), 0x6000024b1b00, __NSArrayM
 */
- (void)test2 {
    NSMutableArray *mArr1 = [@[@"123", @"456"] mutableCopy];
    NSMutableArray *mArr2 = [mArr1 copy];           // copy出来的为不可变数组
    NSMutableArray *mArr3 = [mArr1 mutableCopy];    // mutableCopy出来的为可变数组
    NSLog(@"%@, %p, %@", mArr1, mArr1, [mArr1 class]);
    NSLog(@"%@, %p, %@", mArr2, mArr2, [mArr2 class]);
    NSLog(@"%@, %p, %@", mArr3, mArr3, [mArr3 class]);
    NSLog(@"--------修改源------------");
    [mArr1 addObject:@"hehe"];
    NSLog(@"%@, %p, %@", mArr1, mArr1, [mArr1 class]);
    NSLog(@"%@, %p, %@", mArr2, mArr2, [mArr2 class]);
    NSLog(@"%@, %p, %@", mArr3, mArr3, [mArr3 class]);
}
/*
 从结果看出，内存地址不一样，而且mArr2 是不可变的。copy为什么不是指针指向了？
 首先，mArr2是通过copy 得来的，关键点在于copy，和mArr1 无关，所以他是不可变的。
 另外，mArr1指向的内存空间是可变的，如果对mArr1进行修改，同一内存空间的内容就会变化。 遵循相会不影响的原则，加上mArr2是不可变的，mArr1 的内存空间已经不合适，所以此时的 copy从新开辟内存空间。
 */


/*
 2022-01-11 17:48:38.705996+0800 ZJIOS[56573:1423581] (
     123,
     asd
 ), 0x6000026e58e0, __NSArrayI
 2022-01-11 17:48:38.706313+0800 ZJIOS[56573:1423581] (
     123,
     asd
 ), 0x6000026e58c0, __NSArrayI
 可以看出内存地址不一样，但是_mArr 是不可变的数组。
 因为 _mArr声明的时候是用 copy修饰，那么就限制了它只能是不可变的数组。 赋值的时候是用mutableCopy,可变数组的复制方法，所以会从新分配内存。
 */
- (void)test3 {
    NSArray *arr = @[@"123", @"asd"];
    self.mut_copyArry = [arr mutableCopy];
    NSLog(@"%@, %p, %@", arr, arr, [arr class]);
    NSLog(@"%@, %p, %@", self.mut_copyArry, self.mut_copyArry, [self.mut_copyArry class]);
//    [self.mut_copyArry addObject:@"aa"]; 加上这一句程序这里会崩溃
}


/*
 2022-01-11 17:53:57.336809+0800 ZJIOS[56676:1427211] ary1--(
     123,
     abc
 ), 0x600002db9160, __NSArrayI
 2022-01-11 17:53:57.337169+0800 ZJIOS[56676:1427211] ary2--(
     123,
     abc
 ), 0x600002db9160, __NSArrayI
 2022-01-11 17:53:57.337413+0800 ZJIOS[56676:1427211] ary3--(
     123,
     abc
 ), 0x6000023f4c30, __NSArrayM
 2022-01-11 17:53:57.337535+0800 ZJIOS[56676:1427211] ary1-->123, 0x1031e2b98
 2022-01-11 17:53:57.337696+0800 ZJIOS[56676:1427211] ary1-->abc, 0x1031e4418
 
 2022-01-11 17:53:57.337894+0800 ZJIOS[56676:1427211] ary3-->123, 0x1031e2b98
 2022-01-11 17:53:57.338031+0800 ZJIOS[56676:1427211] ary3-->abc, 0x1031e4418
 ****数组里面的元素还是同样的元素没有变****
 */
- (void)test4 {
    NSArray *ary1 = @[@"123", @"abc"];
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
