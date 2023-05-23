//
//  ZJTestAppearanceViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2023/5/23.
//

#import "ZJTestAppearanceViewController.h"
#import "ZJTestAppearanceView.h"
#import "ZJLayoutDefines.h"

@interface ZJTestAppearanceViewController ()

@end

@implementation ZJTestAppearanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ZJTestAppearanceView *view = [[ZJTestAppearanceView alloc] initWithFrame:CGRectMake(10, 100, kScreenW-20, 150)];
    [self.view addSubview:view];
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
