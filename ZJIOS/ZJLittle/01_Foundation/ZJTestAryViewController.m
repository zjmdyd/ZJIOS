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

    [self test0];
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
