//
//  ZJTestSandboxViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/5/2.
//

#import "ZJTestSandboxViewController.h"
#import "ZJLayoutDefines.h"

@interface ZJTestSandboxViewController ()

@end

@implementation ZJTestSandboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSetting];
}

- (void)initSetting {
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_sandbox"]];
    iv.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    iv.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:iv];
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
