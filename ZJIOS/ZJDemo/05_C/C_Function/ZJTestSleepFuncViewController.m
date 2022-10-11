//
//  ZJTestSleepFuncViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2022/9/3.
//

#import "ZJTestSleepFuncViewController.h"

@interface ZJTestSleepFuncViewController ()

@end

@implementation ZJTestSleepFuncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

// 休眠，其他ui事件也不会立刻执行，会在休眠结束后执行
- (IBAction)swhEvent:(UISwitch *)sender {
    sleep(10);
}

- (IBAction)btnEvent:(UIButton *)sender {
    NSLog(@"%s", __func__);
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
