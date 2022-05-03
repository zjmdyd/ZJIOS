//
//  ZJTestAryViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/11/22.
//

#import "ZJTestAryViewController.h"
#import "NSArray+ZJArray.h"

@interface ZJTestAryViewController ()

@end

@implementation ZJTestAryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test3];
}

/*
 2022-01-24 17:25:00.635343+0800 ZJIOS[17073:571111] 3----2
 2022-01-24 17:25:00.635502+0800 ZJIOS[17073:571111] 4----8
 2022-01-24 17:25:00.635621+0800 ZJIOS[17073:571111] 4----7
 2022-01-24 17:25:00.635758+0800 ZJIOS[17073:571111] 8----7
 2022-01-24 17:25:00.635884+0800 ZJIOS[17073:571111] 3----8
 2022-01-24 17:25:00.636037+0800 ZJIOS[17073:571111] 3----7
 2022-01-24 17:25:00.636137+0800 ZJIOS[17073:571111] 3----4
 2022-01-24 17:25:00.636356+0800 ZJIOS[17073:571111] ary1 = (
     8,
     7,
     4,
     3,
     2
 ), 0x6000005461e0, __NSArrayI_Transfer
 */

/*
 
     3, 2, 4, 8, 7
 
  00) 3, 2  4, 8, 7   3--2
  01) 3, 2, 4, 8, 7
  
  10) 3, 2, 4, 8, 7   4--8
  11) 3, 2, 8, 4, 7
  
  20) 3, 2, 8, 4, 7   4--7
  21) 3, 2, 8, 7, 4
  
  30) 3, 2, 8, 7, 4   8--7
  31) 3, 2, 8, 7, 4
  
  40) 3, 2, 8, 7, 4   3--8
  41) 8, 3, 2, 7, 4
  
  50) 8, 3, 2, 7, 4   3--7
  51) 8, 7, 3, 2, 4
 
  50) 8, 7, 3, 2, 4   3--4
  51) 8, 7, 4, 3, 2
  */

// 降序排列
- (void)test3 {
    NSArray *ary0 = @[@3, @2, @4, @8, @7];
    NSArray *ary1 = [ary0 sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSLog(@"%@----%@", obj1, obj2);
        if ([obj1 floatValue] < [obj2 floatValue]) {
            return NSOrderedDescending; // 交换obj1, obj2
        }
        return NSOrderedAscending;      // 不交换obbj1, obj2
    }];
    NSLog(@"ary1 = %@, %p, %@", ary1, ary1, ary1.class);
}

/*
 2022-01-21 17:20:12.742871+0800 ZJIOS[10649:317207] ary0 = (
     3,
     2,
     4,
     8,
     7
 ), 0x6000022bc480, __NSArrayI
 2022-01-21 17:20:12.743096+0800 ZJIOS[10649:317207] 3----2
 2022-01-21 17:20:12.743224+0800 ZJIOS[10649:317207] 4----8
 2022-01-21 17:20:12.743305+0800 ZJIOS[10649:317207] 8----7
 2022-01-21 17:20:12.743404+0800 ZJIOS[10649:317207] 4----7
 2022-01-21 17:20:12.743566+0800 ZJIOS[10649:317207] 2----4
 2022-01-21 17:20:12.743672+0800 ZJIOS[10649:317207] 3----4
 2022-01-21 17:20:12.743868+0800 ZJIOS[10649:317207] ary0 = (
     3,
     2,
     4,
     8,
     7
 ), 0x6000022bc480, __NSArrayI
 2022-01-21 17:20:12.744026+0800 ZJIOS[10649:317207] ary1 = (
     2,
     3,
     4,
     7,
     8
 ), 0x6000037bc300, __NSArrayI_Transfer
 */

/*
    3, 2, 4, 8, 7
 
 00) 3, 2  4, 8, 7   3--2
 01) 2, 3, 4, 8, 7
 
 10) 2, 3, 4, 8, 7   4--8
 11) 2, 3, 4, 8, 7
 
 20) 2, 3, 4, 8, 7   8--7
 21) 2, 3, 4, 7, 8
 
 30) 2, 3, 4, 7, 8   4--7
 31) 2, 3, 4, 7, 8
 
 40) 2, 3, 4, 7, 8   2--4
 41) 2, 3, 4, 7, 8
 
 50) 2, 3, 4, 7, 8   3--4
 51) 2, 3, 4, 7, 8
 */
//升序排列
- (void)test2 {
    NSArray *ary0 = @[@3, @2, @4, @8, @7];
    NSLog(@"ary0 = %@, %p, %@", ary0, ary0, ary0.class);
    NSArray *ary1 = [ary0 sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSLog(@"%@----%@", obj1, obj2);
        if ([obj1 floatValue] < [obj2 floatValue]) {
            return NSOrderedAscending;  // 不交换obj1, obj2
        }
        return NSOrderedDescending;     // 交换obbj1, obj2
    }];
    NSLog(@"ary0 = %@, %p, %@", ary0, ary0, ary0.class);
    NSLog(@"ary1 = %@, %p, %@", ary1, ary1, ary1.class);
}

/*
 sortedArrayUsingSelector默认升序排列
 */
- (void)test1 {
    NSArray *ary0 = @[@3, @2, @4, @8, @7];
    NSArray *ary1 = [ary0 sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"ary1 = %@", ary1);
    NSNumber *num;
    [num compare:@1];
}

- (void)test0 {
    NSLog(@"%@", [NSArray timeStringWithType:TimeStringType12Hour]);
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
