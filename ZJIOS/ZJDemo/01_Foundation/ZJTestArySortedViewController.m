//
//  ZJTestArySortedViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/5/14.
//

#import "ZJTestArySortedViewController.h"

@interface ZJTestArySortedViewController ()

@end

@implementation ZJTestArySortedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initAry];
}

- (void)initAry {
    self.vcType = ZJBaseTableViewTypeExecute;
    self.cellTitles = @[@"test0", @"test1", @"test2", @"test3"];
}

/*
 与null比较
 2022-05-14 22:55:00.846550+0800 ZJIOS[7265:241389] result = 0, 0, num = (null)
 */
- (void)test0 {
    NSNumber *num;
    NSComparisonResult result = [num compare:@1];
    NSLog(@"result = %zd, NSComparisonResult = %zd, num = %@", result, NSOrderedSame, num);
}

/*
 2022-05-14 22:51:51.086277+0800 ZJIOS[7154:237148] ary1 = (
     2,
     3,
     4,
     7,
     8
 )
 sortedArrayUsingSelector默认升序排列
 */
- (void)test1 {
    NSArray *ary0 = @[@3, @2, @4, @8, @7];
    NSArray *ary1 = [ary0 sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"ary1 = %@", ary1);
    NSLog(@"%p, %p", ary0, ary1);
}

/* 升序排列
 2022-05-14 23:05:23.365242+0800 ZJIOS[7573:251937] ary0 = (
     3,
     2,
     4,
     8,
     7
 ), 0x600003b192c0, __NSArrayI
 
 2022-05-14 23:05:23.365382+0800 ZJIOS[7573:251937] obj1 = 3, obj2 = 2
 2022-05-14 23:05:23.365467+0800 ZJIOS[7573:251937] obj1 = 4, obj2 = 8
 2022-05-14 23:05:23.365535+0800 ZJIOS[7573:251937] obj1 = 8, obj2 = 7
 2022-05-14 23:05:23.365632+0800 ZJIOS[7573:251937] obj1 = 4, obj2 = 7
 2022-05-14 23:05:23.365716+0800 ZJIOS[7573:251937] obj1 = 2, obj2 = 4
 2022-05-14 23:05:23.365797+0800 ZJIOS[7573:251937] obj1 = 3, obj2 = 4
 2022-05-14 23:05:23.365886+0800 ZJIOS[7573:251937] -----------执行排序操作后------------
 2022-05-14 23:05:23.365994+0800 ZJIOS[7573:251937] ary0 = (
     3,
     2,
     4,
     8,
     7
 ), 0x600003b192c0, __NSArrayI
 2022-05-14 23:05:23.366126+0800 ZJIOS[7573:251937] ary1 = (
     2,
     3,
     4,
     7,
     8
 ), 0x600002e79a40, __NSArrayI_Transfer
 
 ary0和ary1不是同一个数组，执行排序操作后会返回一个新的数组，ary0本身保持不变
 */
/* 比较顺序
 3 2 4 8 7  3和2比较
 2 3 4 8 7  交换3和2
 2 3 4 8 7  4和8比较
 2 3 4 8 7  不交换
 2 3 4 8 7  8和7比较
 2 3 4 7 8  交换8和7
 2 3 4 7 8  4和7比较
 2 3 4 7 8  不交换，此时后边3个数已经是有序的
 2 3 4 7 8  2和4比较
 2 3 4 7 8  不交换
 2 3 4 7 8  3和4比较
 2 3 4 7 8  不交换，此时都已比较完
 */
- (void)test2 {
    NSArray *ary0 = @[@3, @2, @4, @8, @7];
    NSLog(@"ary0 = %@, %p, %@", ary0, ary0, ary0.class);
    
    NSArray *ary1 = [ary0 sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSLog(@"obj1 = %@, obj2 = %@", obj1, obj2);
        if ([obj1 floatValue] < [obj2 floatValue]) {
            return NSOrderedAscending;  // 不交换obj1, obj2
        }
        return NSOrderedDescending;     // 交换obj1, obj2
    }];
    
    NSLog(@"-----------执行排序操作后------------");

    NSLog(@"ary0 = %@, %p, %@", ary0, ary0, ary0.class);
    NSLog(@"ary1 = %@, %p, %@", ary1, ary1, ary1.class);
}

/* 降序排列
 2022-05-14 23:42:49.400800+0800 ZJIOS[8320:281054] ary0 = (
     3,
     2,
     4,
     8,
     7
 ), 0x600001301240, __NSArrayI
 
 2022-05-14 23:42:49.401010+0800 ZJIOS[8320:281054] obj1 = 3, obj2 = 2
 2022-05-14 23:42:49.401156+0800 ZJIOS[8320:281054] obj1 = 4, obj2 = 8
 2022-05-14 23:42:49.401261+0800 ZJIOS[8320:281054] obj1 = 4, obj2 = 7
 2022-05-14 23:42:49.401366+0800 ZJIOS[8320:281054] obj1 = 8, obj2 = 7
 2022-05-14 23:42:49.401447+0800 ZJIOS[8320:281054] obj1 = 3, obj2 = 8
 2022-05-14 23:42:49.401535+0800 ZJIOS[8320:281054] obj1 = 3, obj2 = 7
 2022-05-14 23:42:49.401697+0800 ZJIOS[8320:281054] obj1 = 3, obj2 = 4
 
 2022-05-14 23:42:49.401787+0800 ZJIOS[8320:281054] -----------执行排序操作后------------
 
 2022-05-14 23:42:49.402160+0800 ZJIOS[8320:281054] ary1 = (
     8,
     7,
     4,
     3,
     2
 ), 0x60000062ef60, __NSArrayI_Transfer
 */
- (void)test3 {
    NSArray *ary0 = @[@3, @2, @4, @8, @7];
    NSLog(@"ary0 = %@, %p, %@", ary0, ary0, ary0.class);

    NSArray *ary1 = [ary0 sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSLog(@"obj1 = %@, obj2 = %@", obj1, obj2);
        if ([obj1 floatValue] < [obj2 floatValue]) {
            return NSOrderedDescending; // 交换obj1, obj2
        }
        return NSOrderedAscending;      // 不交换obj1, obj2
    }];
    
    NSLog(@"-----------执行排序操作后------------");

    NSLog(@"ary1 = %@, %p, %@", ary1, ary1, ary1.class);
}

/*
 总结:
 1.sortedArrayUsingComparator这个方法本身就是按递增的方式排序。
 2.返回的返回值（NSOrderedAscending 不交换，NSOrderedSame 不交换，NSOrderedDescending 交换）。
 例如：object1 < object2 返回：NSOrderedDescending 则交换（变为object2，object1），返回NSOrderedAscending，两者不交换。以保证方法本身升序。
 
 查看文档有
 NSOrderedAscending
 The left operand is smaller than the right operand.

 NSOrderedSame
 The two operands are equal.

 NSOrderedDescending
 The left operand is greater than the right operand.

 如果你期望的是值小的在前而值大的在后，则可以在比较的时候返回NSOrderedAscending（-1），
 否则，就是NSOrderedDescending（1）。因为NSOrderedDescending是要交换位置的所以能保证从小到大
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
