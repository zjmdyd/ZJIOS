//
//  ZJTestMutableAryViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2021/7/2.
//

#import "ZJTestMutableAryViewController.h"
#import "NSArray+ZJArray.h"

@interface ZJTestMutableAryViewController ()

@end

@implementation ZJTestMutableAryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test4];
}

/*
 2022-01-17 16:13:48.560320+0800 ZJIOS[10785:280545] (
     1,
     2
 ), __NSArrayI, 0x600003098500, 0x7ffedfff9ca0
 2022-01-17 16:13:48.560640+0800 ZJIOS[10785:280545] (
     1,
     2
 ), __NSArrayI, 0x600003098500, 0x7ffedfff9c98
 
 不可变数组执行copy操作为浅拷贝
 */
- (void)test0 {
    NSArray *originAry = @[@"1", @"2"];
    NSArray *ary = originAry.copy;
    NSLog(@"%@, %@, %p, %p", originAry, originAry.class, originAry, &originAry);
    NSLog(@"%@, %@, %p, %p", ary, ary.class, ary, &ary);
}

/*
 2022-05-14 22:16:35.169342+0800 ZJIOS[6099:203696] ary = (
         (
         1,
         1
     ),
         (
         1
     )
 ), __NSArrayM
 
 2022-05-14 22:16:35.169509+0800 ZJIOS[6099:203696] sAry = (
     1,
     1
 ), 0x6000017882a0, __NSArrayM
 2022-05-14 22:16:35.169653+0800 ZJIOS[6099:203696] subObj = 1, 0x10cc5d6d8, __NSCFConstantString
 2022-05-14 22:16:35.169759+0800 ZJIOS[6099:203696] subObj = 1, 0x10cc5d6d8, __NSCFConstantString
 
 2022-05-14 22:16:35.169875+0800 ZJIOS[6099:203696] sAry = (
     1
 ), 0x6000017883c0, __NSArrayM
 2022-05-14 22:16:35.169965+0800 ZJIOS[6099:203696] subObj = 1, 0x10cc5d6d8, __NSCFConstantString
 
 subObj的元素为同一个元素1,相同的字面量字符串
 */
- (void)test1 {
    NSArray *ary = [NSArray multiArrayWithPrototype:@[@[@"", @""], @[@""]] value:@"1"];
    NSLog(@"ary = %@, %@", ary, ary.class);
    
    for (NSArray *sAry in ary) {
        NSLog(@"sAry = %@, %p, %@", sAry, sAry, sAry.class);  // __NSArrayM
        for (id subObj in sAry) {
            NSLog(@"subObj = %@, %p, %@", subObj, subObj, [subObj class]);
        }
    }
}

/*
 2022-05-14 22:22:58.446051+0800 ZJIOS[6277:209705] originAry:(
     1,
     2
 ), 0x600003365220, __NSArrayI
 2022-05-14 22:22:58.446215+0800 ZJIOS[6277:209705] mutable_ary:(
     1,
     2
 ), 0x600003d4edc0, __NSArrayM
 
 2022-05-14 22:22:58.446311+0800 ZJIOS[6277:209705] originAry_subObj = 1, 0x1070066d8, __NSCFConstantString
 2022-05-14 22:22:58.446374+0800 ZJIOS[6277:209705] originAry_subObj = 2, 0x1070066f8, __NSCFConstantString
 
 2022-05-14 22:22:58.446474+0800 ZJIOS[6277:209705] endAry:(
     1,
     2
 ), 0x600003364d20, __NSArrayI
 
 2022-05-14 22:22:58.446543+0800 ZJIOS[6277:209705] endAry_subObj = 1, 0x1070066d8, __NSCFConstantString
 2022-05-14 22:22:58.446612+0800 ZJIOS[6277:209705] endAry_subObj = 2, 0x1070066f8, __NSCFConstantString
 
 数组copy操作，里面的子元素还是相同的
 */
- (void)test2 {
    NSArray *endAry;
    NSArray *originAry = @[@"1", @"2"];
    NSMutableArray *mutable_ary = [NSMutableArray arrayWithArray:originAry];
    
    NSLog(@"originAry:%@, %p, %@", originAry, originAry, originAry.class);
    NSLog(@"mutable_ary:%@, %p, %@", mutable_ary, mutable_ary, mutable_ary.class);
    
    for (id obj in originAry) {
        NSLog(@"originAry_subObj = %@, %p, %@", obj, obj, [obj class]);
    }
    
    endAry = mutable_ary.copy;
    NSLog(@"endAry:%@, %p, %@", endAry, endAry, endAry.class);
    
    for (id obj in endAry) {
        NSLog(@"endAry_subObj = %@, %p, %@", obj, obj, [obj class]);
    }
}

/*
 2022-05-14 22:31:38.525517+0800 ZJIOS[6520:216986] originAry:(
     1,
     2
 ), 0x600002eff5c0, __NSArrayI
 
 2022-05-14 22:31:38.525902+0800 ZJIOS[6520:216986] mutable_ary:(
     1,
     2
 ), 0x600002058480, __NSArrayM
 
 2022-05-14 22:31:38.526077+0800 ZJIOS[6520:216986] endAry:(
     1,
     2
 ), 0x600002ee1c60, __NSArrayI
 
 2022-05-14 22:31:38.526198+0800 ZJIOS[6520:216986] ********mutable_ary执行removeLastObject操作**********
 
 2022-05-14 22:31:38.526306+0800 ZJIOS[6520:216986] originAry:(
     1,
     2
 ), 0x600002eff5c0, __NSArrayI
 
 2022-05-14 22:31:38.526416+0800 ZJIOS[6520:216986] mutable_ary:(
     1
 ), 0x600002058480, __NSArrayM
 
 2022-05-14 22:31:38.526555+0800 ZJIOS[6520:216986] endAry:(
     1,
     2
 ), 0x600002ee1c60, __NSArrayI
 
mutable_ary执行remove操作不影响copy出来的数组
 */
- (void)test3 {
    NSArray *endAry;
    NSArray *originAry = @[@"1", @"2"];
    NSMutableArray *mutable_ary = [NSMutableArray arrayWithArray:originAry];
    
    NSLog(@"originAry:%@, %p, %@", originAry, originAry, originAry.class);
    NSLog(@"mutable_ary:%@, %p, %@", mutable_ary, mutable_ary, mutable_ary.class);
    
    endAry = mutable_ary.copy;
    NSLog(@"endAry:%@, %p, %@", endAry, endAry, endAry.class);

    NSLog(@"********mutable_ary执行removeLastObject操作**********");
    [mutable_ary removeLastObject];
    
    NSLog(@"originAry:%@, %p, %@", originAry, originAry, originAry.class);
    NSLog(@"mutable_ary:%@, %p, %@", mutable_ary, mutable_ary, mutable_ary.class);
    NSLog(@"endAry:%@, %p, %@", endAry, endAry, endAry.class);
}

/*
 2022-05-14 22:39:36.906221+0800 ZJIOS[6764:224551] originAry:(
     1,
     2
 ), 0x6000014036e0, __NSArrayI
 
 2022-05-14 22:39:36.906382+0800 ZJIOS[6764:224551] mutable_ary:(
     1,
     2
 ), 0x600001a29a40, __NSArrayM
 
 2022-05-14 22:39:36.906522+0800 ZJIOS[6764:224551] endAry:(
     1,
     2
 ), 0x600001a24660, __NSArrayM
 
 2022-05-14 22:39:36.906634+0800 ZJIOS[6764:224551] ********mutable_ary执行removeLastObject操作**********
 
 2022-05-14 22:39:36.906757+0800 ZJIOS[6764:224551] mutable_ary:(
     1
 ), 0x600001a29a40, __NSArrayM
 
 2022-05-14 22:39:36.906865+0800 ZJIOS[6764:224551] endAry:(
     1,
     2
 ), 0x600001a24660, __NSArrayM
 
 2022-05-14 22:39:36.906946+0800 ZJIOS[6764:224551] ********endAry执行addObject操作**********
 
 2022-05-14 22:39:36.907024+0800 ZJIOS[6764:224551] mutable_ary:(
     1
 ), 0x600001a29a40, __NSArrayM
 
 2022-05-14 22:39:36.907117+0800 ZJIOS[6764:224551] endAry:(
     1,
     2,
     "\U5475\U5475\U54c8\U54c8\U54c8"
 ), 0x600001a24660, __NSArrayM
 */

/*
 mutable_ary执行remove操作不影响mutableCopy出来的数组, endAry执行addObject操作不影响mutable_ary出来的数组
 也即mutable_ary与mutableCopy出来的数组两者相互不影响
*/
- (void)test4 {
    NSMutableArray *endAry;
    NSArray *originAry = @[@"1", @"2"];
    NSMutableArray *mutable_ary = [NSMutableArray arrayWithArray:originAry];
    
    NSLog(@"originAry:%@, %p, %@", originAry, originAry, originAry.class);
    NSLog(@"mutable_ary:%@, %p, %@", mutable_ary, mutable_ary, mutable_ary.class);
    
    endAry = mutable_ary.mutableCopy;
    NSLog(@"endAry:%@, %p, %@", endAry, endAry, endAry.class);

    NSLog(@"********mutable_ary执行removeLastObject操作**********");
    [mutable_ary removeLastObject];
    
    NSLog(@"mutable_ary:%@, %p, %@", mutable_ary, mutable_ary, mutable_ary.class);
    NSLog(@"endAry:%@, %p, %@", endAry, endAry, endAry.class);
    
    NSLog(@"********endAry执行addObject操作**********");
    [endAry addObject:@"呵呵哈哈哈"];
    
    NSLog(@"mutable_ary:%@, %p, %@", mutable_ary, mutable_ary, mutable_ary.class);
    NSLog(@"endAry:%@, %p, %@", endAry, endAry, endAry.class);
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
