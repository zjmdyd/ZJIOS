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
    
    [self initAry];
}

- (void)initAry {
    self.vcType = ZJBaseTableViewTypeExecute;
    self.cellTitles = @[@"test0", @"test1", @"test2", @"test3"];
}

/*
 2023-05-18 16:27:49.876666+0800 ZJIOS[95624:4733260] str1:哈哈哈哈, __NSCFConstantString, 0x103d0c960, 0x7ff7bc263608
 2023-05-18 16:27:49.876836+0800 ZJIOS[95624:4733260] str2:哈哈哈哈, __NSCFConstantString, 0x103d0c960, 0x7ff7bc263600
 2023-05-18 16:27:49.876969+0800 ZJIOS[95624:4733260] --------修改源------------
 2023-05-18 16:27:49.877167+0800 ZJIOS[95624:4733260] str1:呵呵呵呵要变了额, __NSCFConstantString, 0x103d0c9e0, 0x7ff7bc263608
 2023-05-18 16:27:49.877322+0800 ZJIOS[95624:4733260] str2:哈哈哈哈, __NSCFConstantString, 0x103d0c960, 0x7ff7bc263600
 2023-05-18 16:27:49.877461+0800 ZJIOS[95624:4733260] --------修改副本str2------------
 2023-05-18 16:27:49.877606+0800 ZJIOS[95624:4733260] str1:呵呵呵呵要变了额, __NSCFConstantString, 0x103d0c9e0, 0x7ff7bc263608
 2023-05-18 16:27:49.877738+0800 ZJIOS[95624:4733260] str2:哈哈哈哈72变了, __NSCFConstantString, 0x103d0ca20, 0x7ff7bc263600
 */
/*
 copy的特点
 修改源对象的属性和行为，不会影响副本对象
 修改副本对象的属性和行为，不会影响源对象
 那为什么NSString *str2 = [str1 copy];是不同的指针指向同一块内存空间，str1 重新赋值 后两个内存空间就不一样了呢？
 因为str2 = str1的时候，两个字符串都是不可变的，指向的同一块内存空间中的
 @"str1",是不可能变成@"abcd"的。所以这个时候，为了优化性能，系统没必要另外提供内存，只生成另外一个指针，指向同一块内存空间就行。
 但是当你从新给 str1 或者str2赋值的时候，因为之前的内容不可变，还有互不影响的原则下，这个时候，系统会从新开辟一块内存空间。
 */
- (void)test0 {
    NSString *str1 = @"哈哈哈哈";
    NSString *str2 = [str1 copy];
    
    NSLog(@"str1:%@, %@, %p, %p", str1, str1.class, str1, &str1);
    NSLog(@"str2:%@, %@, %p, %p", str2, str2.class, str2, &str2);
    
    NSLog(@"--------修改源------------");
    str1 = @"呵呵呵呵要变了额"; //  修改不可变字符串，改变了字符串的地址， str1指向的地址会改变
    
    NSLog(@"str1:%@, %@, %p, %p", str1, str1.class, str1, &str1);
    NSLog(@"str2:%@, %@, %p, %p", str2, str2.class, str2, &str2);
    
    NSLog(@"--------修改副本str2------------");
    str2 = @"哈哈哈哈72变了"; //  修改不可变字符串，改变了字符串的地址， str2指向的地址会改变
    
    NSLog(@"str1:%@, %@, %p, %p", str1, str1.class, str1, &str1);
    NSLog(@"str2:%@, %@, %p, %p", str2, str2.class, str2, &str2);
}

/*
 2022-05-14 21:40:11.862447+0800 ZJIOS[5203:172568] mArr1:(
     123,
     456
 ), 0x6000011707b0, __NSArrayM
 2022-05-14 21:40:11.862678+0800 ZJIOS[5203:172568] mArr2:(
     123,
     456
 ), 0x600001f26c80, __NSArrayI
 2022-05-14 21:40:11.862847+0800 ZJIOS[5203:172568] mArr3:(
     123,
     456
 ), 0x600001170030, __NSArrayM
 
 2022-05-14 21:40:11.862991+0800 ZJIOS[5203:172568] --------修改源------------
 2022-05-14 21:40:11.863099+0800 ZJIOS[5203:172568] mArr1:(
     123,
     456,
     hehe
 ), 0x6000011707b0, __NSArrayM
 2022-05-14 21:40:11.863357+0800 ZJIOS[5203:172568] mArr2:(
     123,
     456
 ), 0x600001f26c80, __NSArrayI
 2022-05-14 21:40:11.863500+0800 ZJIOS[5203:172568] mArr3:(
     123,
     456
 ), 0x600001170030, __NSArrayM
 */
- (void)test1 {
    NSMutableArray *mArr1 = @[@"123", @"456"].mutableCopy;
    NSMutableArray *mArr2 = [mArr1 copy];           // copy出来的为不可变数组
    NSMutableArray *mArr3 = [mArr1 mutableCopy];    // mutableCopy出来的为可变数组
    
    NSLog(@"mArr1:%@, %p, %@", mArr1, mArr1, [mArr1 class]);
    NSLog(@"mArr2:%@, %p, %@", mArr2, mArr2, [mArr2 class]);
    NSLog(@"mArr3:%@, %p, %@", mArr3, mArr3, [mArr3 class]);
    
    NSLog(@"--------修改源------------");
    [mArr1 addObject:@"hehe"];
    
    NSLog(@"mArr1:%@, %p, %@", mArr1, mArr1, [mArr1 class]);
    NSLog(@"mArr2:%@, %p, %@", mArr2, mArr2, [mArr2 class]);
    NSLog(@"mArr3:%@, %p, %@", mArr3, mArr3, [mArr3 class]);
}
/*
 从结果看出，内存地址不一样，而且mArr2 是不可变的。copy为什么不是指针指向了？
 首先，mArr2是通过copy 得来的，关键点在于copy，和mArr1 无关，所以他是不可变的。
 另外，mArr1指向的内存空间是可变的，如果对mArr1进行修改，同一内存空间的内容就会变化。 遵循相互不影响的原则，加上mArr2是不可变的，mArr1 的内存空间已经不合适，所以此时的 copy重新开辟内存空间。
 */
/*
 对immutableObject，即不可变对象，执行copy，会得到不可变对象，并且是浅copy。
 对immutableObject，即不可变对象，执行mutableCopy，会得到可变对象，并且是深copy。
 对mutableObject，即可变对象，执行copy，会得到不可变对象，并且是深copy。
 对mutableObject，即可变对象，执行mutableCopy，会得到可变对象，并且是深copy。
 */

/*
 2022-05-14 21:55:21.208212+0800 ZJIOS[5501:184779] arr:(
     123,
     asd
 ), 0x60000317c100, __NSArrayI
 2022-05-14 21:55:21.208442+0800 ZJIOS[5501:184779] self.mut_copyArry:(
     123,
     asd
 ), 0x60000317c520, __NSArrayI
 可以看出内存地址不一样，但是self.mut_copyArry 是不可变的数组。
 因为 self.mut_copyArry声明的时候是用 copy修饰，那么就限制了它只能是不可变的数组。 赋值的时候是用mutableCopy,可变数组的复制方法，所以会从新分配内存。
 */
- (void)test2 {
    NSArray *arr = @[@"123", @"asd"];
    self.mut_copyArry = [arr mutableCopy];
    NSLog(@"arr:%@, %p, %@", arr, arr, [arr class]);
    NSLog(@"self.mut_copyArry:%@, %p, %@", self.mut_copyArry, self.mut_copyArry, [self.mut_copyArry class]);
    if ([self.mut_copyArry isKindOfClass:[NSMutableArray class]]) { // mut_copyArry用strong修饰就会是可变数组
        NSLog(@"self.mut_copyArry是可变数组");
        [self.mut_copyArry addObject:@"aa"];
    }else {
        NSLog(@"self.mut_copyArry是不可变数组");  // self.mut_copyArry是不可变数组
    }
}

/*
 2022-05-14 21:59:25.411082+0800 ZJIOS[5583:188153] ary1--(
     123,
     abc
 ), 0x60000374ab00, __NSArrayI
 
 2022-05-14 21:59:25.411226+0800 ZJIOS[5583:188153] ary2--(
     123,
     abc
 ), 0x60000374ab00, __NSArrayI
 
 2022-05-14 21:59:25.411327+0800 ZJIOS[5583:188153] ary3--(
     123,
     abc
 ), 0x6000039774e0, __NSArrayM
 
 2022-05-14 21:59:25.411422+0800 ZJIOS[5583:188153] ary1-->123, 0x1019417f8
 2022-05-14 21:59:25.411507+0800 ZJIOS[5583:188153] ary1-->abc, 0x101940038
 
 2022-05-14 21:59:25.411595+0800 ZJIOS[5583:188153] ary3-->123, 0x1019417f8
 2022-05-14 21:59:25.411743+0800 ZJIOS[5583:188153] ary3-->abc, 0x101940038
 ****数组执行mutableCopy操作，数组的子元素还是同样的元素没有变****
 */
- (void)test3 {
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
