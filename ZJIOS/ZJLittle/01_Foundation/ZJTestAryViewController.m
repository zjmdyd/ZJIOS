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

- (void)test3 {
    NSMutableArray *arr0 = [NSMutableArray array];
    
    [arr0 addObject:@2];
    [arr0 addObject:@1];
    [arr0 addObject:@5];
    [arr0 addObject:@3];
    [arr0 addObject:@4];
    
    //此方法是直接对arr排序，若要生成新数组排序则调用sortedArrayUsingComparator:
    //若明确知道数组中元素的类型，也可以直接将id改为某确定类型
    [arr0 sortUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        //此处的规则含义为：若前一元素比后一元素大，则返回降序（即后一元素在前，为从小到大排列）
        if ([obj1 integerValue] > [obj2 integerValue])
        {
            return NSOrderedDescending;
        }
        else
        {
            return NSOrderedAscending;
        }
    }];
    NSLog(@"arr0 = %@", arr0);  // 排序结果为 5，4，3，2，1
//    NSLog(@"arr1 = %@", arr1);
}

- (void)test2 {
    NSMutableArray *arr0 = [NSMutableArray array];
    
    [arr0 addObject:@2];
    [arr0 addObject:@1];
    [arr0 addObject:@5];
    [arr0 addObject:@3];
    [arr0 addObject:@4];
    
    //此方法是直接对arr排序，若要生成新数组排序则调用sortedArrayUsingComparator:
    //若明确知道数组中元素的类型，也可以直接将id改为某确定类型
    [arr0 sortUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        //此处的规则含义为：若前一元素比后一元素小，则返回降序（即后一元素在前，为从大到小排列）
        if ([obj1 integerValue] < [obj2 integerValue])
        {
            return NSOrderedDescending;
        }
        else
        {
            return NSOrderedAscending;
        }
    }];
    NSLog(@"arr0 = %@", arr0);  // 排序结果为 5，4，3，2，1
//    NSLog(@"arr1 = %@", arr1);
}

//- (void)test2 {
//    NSRange range = NSMakeRange(1, 3);
//    NSArray *ary = @[@0, @1, @2, @3, @4, @5];
//    NSArray *sAry = [ary subarrayWithRange:range];
//    NSLog(@"sAry = %@", sAry);
//
//    NSString *str = [ary joinToStringWithSeparateString:@","];
//    NSLog(@"jAry = %@", str);
//}

/*
 3, 2 --> 2, 3
 4, 8 --> 4, 8
 8, 7 --> 7, 8
 
 2, 3,     4,       7, 8,
 */
- (void)test1 {
    NSArray *ary0 = @[@3, @2, @4, @8, @7];
    NSLog(@"ary0 = %@, %p, %@", ary0, ary0, ary0.class);
    NSArray *ary1 = [ary0 sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSLog(@"%@----%@", obj1, obj2);
        if ([obj1 floatValue] < [obj2 floatValue]) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    NSLog(@"ary0 = %@, %p, %@", ary0, ary0, ary0.class);
    NSLog(@"ary1 = %@, %p, %@", ary1, ary1, ary1.class);
}

- (void)test0 {
    NSLog(@"%@", [NSArray timeStringWithType:TimeStringTypeOf12Hour]);
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
