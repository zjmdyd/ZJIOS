//
//  ZJTestFloatViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/7/14.
//

#import "ZJTestFloatViewController.h"

@interface ZJTestFloatViewController ()

@end

@implementation ZJTestFloatViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self test0];
}

- (void)test0 {
    float a = 0;
    if (a > 0) {
        NSLog(@"a大于0");
    }else if(a == 0) {      // a等于0
        NSLog(@"a等于0");
    }else {
        NSLog(@"a小于0");
    }
    
    if (a < FLT_EPSILON) {
        NSLog(@"a小于 FLT_EPSILON");  // a小于 FLT_EPSILON
    }else if(a == FLT_EPSILON){
        NSLog(@"a等于 FLT_EPSILON");
    }else {
        NSLog(@"a大于 FLT_EPSILON");
        
    }
    NSLog(@"a = %f", a);
    NSLog(@"FLT_EPSILON = %f", FLT_EPSILON);
    NSLog(@"FLT_EPSILON = %lf", FLT_EPSILON);
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
