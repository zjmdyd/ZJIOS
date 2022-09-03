//
//  ZJTestUnsignedDataViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/5/2.
//

#import "ZJTestUnsignedDataViewController.h"

@interface ZJTestUnsignedDataViewController ()

@end

@implementation ZJTestUnsignedDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self test0];
}

/*
 补码=原码取反+1(符号位除外)
 -1, 32位
 原码:10000000 00000000 00000000 00000001
 反码:11111111 11111111 11111111 11111110
 补码:11111111 11111111 11111111 11111111
 
 int/unsigned int a = -1, %u输出解释:直接按原码处理，所以值为2^32-1 = 4294967295
 */
- (void)test0 {
    int a = -1;
    NSLog(@"%d, %u", a, a); // -1, 4294967295
    
    unsigned int b = -1;
    NSLog(@"%d, %u", b, b); // -1, 4294967295
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
