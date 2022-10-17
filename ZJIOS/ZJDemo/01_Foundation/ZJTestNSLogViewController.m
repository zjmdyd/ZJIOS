//
//  ZJTestNSLogViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/1/17.
//

#import "ZJTestNSLogViewController.h"

@interface ZJTestNSLogViewController ()

@end

@implementation ZJTestNSLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test3];
}

/*
 32位
 typedef unsigned int size_t
 typedef  int         ssize_t

 64位
 typedef long unsigned int size_t
 typedef long  int         ssize_t
 */
- (void)test3 {
    NSInteger i = 1;
    NSLog(@"i= %zd", i);
    
    size_t s = 10;
    NSLog(@"s = %zd", s);
    
    ssize_t t = -10;
    NSLog(@"t = %zd", t);
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
