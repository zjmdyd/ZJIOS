//
//  ZJTestNSRangeViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/11/23.
//

#import "ZJTestNSRangeViewController.h"

@interface ZJTestNSRangeViewController ()

@end

@implementation ZJTestNSRangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self test0];
}

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
