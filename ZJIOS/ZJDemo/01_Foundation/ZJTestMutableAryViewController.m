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

/*
 NSMutableArray *array = [NSMutableArray arrayWithArray:self.objects];
 [array addObjectsFromArray:obj.objects];
 
 self.objects = [array mutableCopy];
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test0];
}

/*
 2022-01-17 15:58:07.672355+0800 ZJIOS[10439:268664] (
     1,
     2
 ), __NSArrayI, 0x600003821f20
 2022-01-17 15:58:07.672548+0800 ZJIOS[10439:268664] (
     1,
     2
 ), __NSArrayM, 0x600003679cb0
 2022-01-17 15:58:07.672665+0800 ZJIOS[10439:268664] (
     1,
     2
 ), __NSArrayI, 0x6000038741a0
 2022-01-17 15:58:07.672816+0800 ZJIOS[10439:268664] ********ary执行removeLastObject操作**********
 2022-01-17 15:58:07.672982+0800 ZJIOS[10439:268664] (
     1,
     2
 ), __NSArrayI, 0x600003821f20
 2022-01-17 15:58:07.673108+0800 ZJIOS[10439:268664] (
     1
 ), __NSArrayM, 0x600003679cb0
 2022-01-17 15:58:07.673251+0800 ZJIOS[10439:268664] (
     1,
     2
 ), __NSArrayI, 0x6000038741a0
 
执行remove操作不影响copy出来的数组
 */
- (void)test3 {
    NSArray *endAry;
    NSArray *originAry = @[@"1", @"2"];
    NSMutableArray *ary = [NSMutableArray arrayWithArray:originAry];
    NSLog(@"%@, %@, %p", originAry, originAry.class, originAry);
    NSLog(@"%@, %@, %p", ary, ary.class, ary);
    
    endAry = ary.copy;
    NSLog(@"%@, %@, %p", endAry, endAry.class, endAry);
    
    [ary removeLastObject];
    NSLog(@"********ary执行removeLastObject操作**********");
    
    NSLog(@"%@, %@, %p", originAry, originAry.class, originAry);
    NSLog(@"%@, %@, %p", ary, ary.class, ary);
    NSLog(@"%@, %@, %p", endAry, endAry.class, endAry);
}

/*
 2022-01-17 15:38:25.477911+0800 ZJIOS[10068:254861] (
     1,
     2
 ), __NSArrayI, 0x6000008ac2a0
 2022-01-17 15:38:25.478293+0800 ZJIOS[10068:254861] (
     1,
     2
 ), __NSArrayM, 0x60000068aa30
 2022-01-17 15:38:25.478504+0800 ZJIOS[10068:254861] obj = 1, 0x10b7cdd98
 2022-01-17 15:38:25.478682+0800 ZJIOS[10068:254861] obj = 2, 0x10b7cde18
 2022-01-17 15:38:25.478973+0800 ZJIOS[10068:254861] (
     1,
     2
 ), __NSArrayI, 0x6000008a5380
 2022-01-17 15:38:25.479125+0800 ZJIOS[10068:254861] obj = 1, 0x10b7cdd98
 2022-01-17 15:38:25.479285+0800 ZJIOS[10068:254861] obj = 2, 0x10b7cde18
 ), __NSArrayI, 0x6000025a3fa0
 
 数组copy操作，里面的子元素还是相同的
 */
- (void)test2 {
    NSArray *endAry;
    NSArray *originAry = @[@"1", @"2"];
    NSMutableArray *ary = [NSMutableArray arrayWithArray:originAry];
    NSLog(@"%@, %@, %p", originAry, originAry.class, originAry);
    NSLog(@"%@, %@, %p", ary, ary.class, ary);
    
    for (id obj in originAry) {
        NSLog(@"obj = %@, %p", obj, obj);
    }
    
    endAry = ary.copy;
    NSLog(@"%@, %@, %p", endAry, endAry.class, endAry);
    for (id obj in endAry) {
        NSLog(@"obj = %@, %p", obj, obj);
    }
}

/*
 2022-01-17 15:23:57.784879+0800 ZJIOS[9761:244596] sAry = (
     1,
     1
 ), __NSArrayM, 0x600000cc5f80
 2022-01-17 15:23:57.784995+0800 ZJIOS[9761:244596] obj = 1, 0x10eff6d98
 2022-01-17 15:23:57.785079+0800 ZJIOS[9761:244596] obj = 1, 0x10eff6d98
 
 2022-01-17 15:23:57.785194+0800 ZJIOS[9761:244596] sAry = (
     1
 ), __NSArrayM, 0x600000cc4c30
 2022-01-17 15:23:57.785286+0800 ZJIOS[9761:244596] obj = 1, 0x10eff6d98
 
 sAry的元素为同一个元素
 */
- (void)test1 {
    NSArray *ary = [NSArray multiArrayWithPrototype:@[@[@"", @""], @[@""]] value:@"1"];
    NSLog(@"ary = %@, %@", ary, ary.class);
    for (NSArray *sAry in ary) {
        NSLog(@"sAry = %@, %@, %p", sAry, sAry.class, sAry);  // __NSArrayM
        for (id obj in sAry) {
            NSLog(@"obj = %@, %p", obj, obj);
        }
    }
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
