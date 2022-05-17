//
//  ZJTestBezierPathViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/5/16.
//

#import "ZJTestBezierPathViewController.h"
#import "ZJTestBezierPathView.h"

@interface ZJTestBezierPathViewController ()

@end

@implementation ZJTestBezierPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self test0];
}

- (void)test0 {
    ZJTestBezierPathView *view = [[ZJTestBezierPathView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    view.center = self.view.center;
    [self.view addSubview:view];
    view.backgroundColor = [UIColor greenColor];
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
