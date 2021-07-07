//
//  ZJTestSuperViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/20.
//

#import "ZJTestSuperViewController.h"
#import "Student.h"

@interface ZJTestSuperViewController ()

@end

@implementation ZJTestSuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Student *stu = [Student new];
    [stu testSuperClass];
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
