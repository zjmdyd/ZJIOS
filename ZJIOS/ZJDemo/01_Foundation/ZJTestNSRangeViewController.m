//
//  ZJTestNSRangeViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/11/23.
//

#import "ZJTestNSRangeViewController.h"
#import "NSNumber+ZJNumber.h"

@interface ZJTestNSRangeViewController ()

@end

@implementation ZJTestNSRangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self test2];
}

/*
 [6,7,8,9,10]
 
 2022-01-20 18:18:43.132555+0800 ZJIOS[19345:632376] num = 10
 */
- (void)test2 {
    NSNumber *num = @10;
    NSInteger validValue = [num validValueWithRange:NSMakeRange(6, 5)];
    NSLog(@"num = %ld", (long)validValue);
    
    BOOL is_loc =  NSLocationInRange(0, NSMakeRange(0, 3));  // [0, 1, 2]
    NSLog(@"is_loc = %d", is_loc);
}

/*
 2022-01-17 16:29:48.784733+0800 ZJIOS[11156:292423] str3 = abcdefg, str4 = abcdefg
 */
- (void)test1 {
    NSString *str = @"abcdefg";
    NSString *str3 = [str substringFromIndex:0];            // [index, len-1]   左包含
    NSString *str4 = [str substringToIndex:str.length];     // [0, index)       右不包含
    NSLog(@"str3 = %@, str4 = %@", str3, str4);
}

//2021-12-07 16:25:26.509359+0800 ZJIOS[18390:165713] str1 = def, str2 = abc
- (void)test0 {
    NSString *str = @"abcdefg";
    NSString *str1 = [str substringWithRange:NSMakeRange(3, 3)];
    NSString *str2 = [str substringWithRange:NSMakeRange(0, 3)];
    
    NSLog(@"str1 = %@, str2 = %@", str1, str2);
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
