//
//  ZJTestBarButtonItemViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/7/15.
//

#import "ZJTestBarButtonItemViewController.h"
#import "UIViewController+ZJViewController.h"

@interface ZJTestBarButtonItemViewController ()

@end

@implementation ZJTestBarButtonItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSetting];
    [self test];
}

- (void)initSetting {
    self.navigationItem.rightBarButtonItems = [self barButtonWithImageNames:@[@"more", @"setting"]];
}

- (void)test {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 100, 44);
    btn.center = self.view.center;
    [btn setTitle:@"点我" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnEvent:(UIButton *)sender {
    static int time = 0;
    if (time == 0) {
        self.navigationItem.rightBarButtonItems = nil;
        self.navigationItem.rightBarButtonItem = [self barButtonItemWithCustomViewWithImageNames:@[@"more", @"setting"]];
    }else {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItems = [self barButtonWithImageNames:@[@"more", @"setting"]];
    }
    time++;
    time %= 2;
    NSLog(@"time = %d", time);
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
