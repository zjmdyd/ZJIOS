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

// 休眠，其他ui、timer事件会被阻塞，会在休眠期结束后执行
- (IBAction)swhEvent:(UISwitch *)sender {
    NSLog(@"%s", __func__);
    if (@available(iOS 10.0, *)) {
        [NSTimer scheduledTimerWithTimeInterval:10 repeats:NO block:^(NSTimer * _Nonnull timer) {
            NSLog(@"timer执行了_1");
            sender.on = NO;
        }];
    } else {
        // Fallback on earlier version、、
    }
    
    sleep(10);
}

- (IBAction)btnEvent:(UIButton *)sender {
    NSLog(@"%s", __func__);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
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
