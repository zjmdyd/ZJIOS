//
//  ZJNoTranslentViewController.m
//  TestLocal
//
//  Created by ZJ on 2018/8/10.
//  Copyright © 2018 HY. All rights reserved.
//

#import "ZJNoTranslentViewController.h"

@interface ZJNoTranslentViewController ()

@end

@implementation ZJNoTranslentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setTranslucent:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
