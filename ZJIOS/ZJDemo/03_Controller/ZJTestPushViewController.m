//
//  ZJTestPushViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/5/31.
//

#import "ZJTestPushViewController.h"
#import "UIViewController+ZJViewController.h"

@interface ZJTestPushViewController ()

@end

@implementation ZJTestPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 100, 50);
    btn.center = self.view.center;
    [btn setTitle:@"next" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(test0) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)test0 {
    [self showVCWithName:@"ZJViewController" title:@"hh"];
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
