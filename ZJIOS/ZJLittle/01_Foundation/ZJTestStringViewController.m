//
//  ZJTestStringViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/11/23.
//

#import "ZJTestStringViewController.h"
#import "NSString+ZJString.h"

@interface ZJTestStringViewController ()

@end

@implementation ZJTestStringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test0];
}

- (void)test1 {
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

- (void)test0 {
    NSString *str = @"abcdef";
    NSLog(@"invertString = %@", [str invertString]);
    NSLog(@"invertStringWithSegmentLenth = %@", [str invertStringWithSegmentLenth:3]);
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
