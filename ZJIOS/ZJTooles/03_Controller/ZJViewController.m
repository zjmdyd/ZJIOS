//
//  ZJViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/14.
//

#import "ZJViewController.h"
#import "AppConfigHeader.h"

@interface ZJViewController ()

@end

@implementation ZJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSuperSetting];
}

- (void)initSuperSetting {
    self.view.backgroundColor = DefaultViewBackgroundColor;
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
