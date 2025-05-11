//
//  ZJTestShareViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/11/17.
//

#import "ZJTestShareViewController.h"

@interface ZJTestShareViewController ()

@end

@implementation ZJTestShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self systemShareWithIcon:@"ic_leaf" text:@"测试系统分享" url:@"https://www.apple.com.cn/"];
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
