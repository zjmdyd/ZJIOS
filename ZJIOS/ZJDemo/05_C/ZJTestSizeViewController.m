//
//  ZJTestSizeViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/7/2.
//

#import "ZJTestSizeViewController.h"

@interface ZJTestSizeViewController ()

@end

@implementation ZJTestSizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test0];
}

- (void)test0 {
    NSInteger values[] =  {0, 4, 8, 13, 18, 22, 26, 32};
    NSInteger count = sizeof(values) / sizeof(NSInteger);
    NSLog(@"count = %zd", count);   // count = 8
    
    NSInteger targetIndexs[] =  {0, 3, 4};
    [self getTargetValuesWithIndexs:targetIndexs count:3];
}

- (void)getTargetValuesWithIndexs:(NSInteger *)indexs count:(NSInteger)count {
    NSInteger t_count = sizeof(*indexs) / sizeof(NSInteger);    // 不能得到形参所指向数组的全部大小

    NSLog(@"t_count = %zd", t_count);   // t_count = 1

    NSInteger values[] =  {0, 4, 8, 13, 18, 22, 26, 32};
/*
 2023-05-23 19:01:22.237515+0800 ZJIOS[78763:7917839] value = 0, index = 0
 2023-05-23 19:01:22.237621+0800 ZJIOS[78763:7917839] value = 4, index = 3
 2023-05-23 19:01:22.237734+0800 ZJIOS[78763:7917839] value = 8, index = 4
 */
    for (NSInteger i = 0; i < count; i++) {
        NSLog(@"value = %zd, index = %zd", values[i], indexs[i]);   //
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
