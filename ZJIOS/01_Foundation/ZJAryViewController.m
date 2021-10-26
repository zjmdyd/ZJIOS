//
//  ZJAryViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/7/27.
//

#import "ZJAryViewController.h"
#import "NSArray+ZJArray.h"

@interface ZJAryViewController ()

@end

@implementation ZJAryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test0];
//    [self test2];
}

- (void)test0 {
    NSRange range = NSMakeRange(1, 3);
    NSArray *ary = @[@0, @1, @2, @3, @4, @5];
    NSArray *sAry = [ary subarrayWithRange:range];
    NSLog(@"sAry = %@", sAry);
    
    NSString *str = [ary joinToStringWithSeparateString:@","];
    NSLog(@"jAry = %@", str);
}

- (void)test1 {
    NSArray *ary = @[@3, @2, @8, @7];
    NSLog(@"ary = %@, %p", ary, ary);
    NSArray *array = [ary sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 floatValue] < [obj2 floatValue]) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    NSLog(@"ary = %@, %p", ary, ary);
    NSLog(@"array = %@, %p", array, array);
}

- (void)test2 {
    NSArray *punctuations = @[@",", @".", @"!", @"?", @":"];
    
    NSString *str = @":";
    NSLog(@"字符串 = %@, 地址 = %p", str, str);
    
    for (NSString *str in punctuations) {
        NSLog(@"str = %@--%p", str, str);
    }
    
    if ([punctuations containsObject:@":"]) {
        NSLog(@"字符串包含成立");
    }else {
        NSLog(@"字符串包含不成立");
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
