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
    
    [self initAry];
}

- (void)initAry {
    self.vcType = ZJBaseTableViewTypeExecute;
    self.cellTitles = @[@"test0"];
}

/*
 32位
 typedef unsigned int size_t
 typedef  int         ssize_t

 64位
 typedef long unsigned int size_t
 typedef long  int         ssize_t
 */

/*
 2023-05-18 19:21:47.885404+0800 ZJIOS[99288:4874392] i= 1
 2023-05-18 19:21:47.885591+0800 ZJIOS[99288:4874392] s = 10
 2023-05-18 19:21:47.885703+0800 ZJIOS[99288:4874392] t = -10
 
 %zd用于输出size_t
 */
- (void)test0 {
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
