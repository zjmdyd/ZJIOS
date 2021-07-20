//
//  ZJAlertViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/7/16.
//

#import "ZJAlertViewController.h"
#import "UIViewController+ZJViewController.h"

@interface ZJAlertViewController ()

@end

@implementation ZJAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [self test0];
    [self test1];
}

- (void)test1 {
    ZJAlertObject *obj = [ZJAlertObject new];
    obj.title = @"标题";
    obj.msg = @"message";
    obj.sheetTitles = @[@"取消", @"下一个"];
    obj.alertStyle = UIAlertControllerStyleAlert;
    ZJTextInputConfig *cfg = [[ZJTextInputConfig alloc] init];
    cfg.text = @"hello";
    obj.textFieldConfigs = @[cfg];
    [self alertFunc:obj alertCompl:^(UIAlertAction *act, NSArray *textFields) {
        NSLog(@"%@--%@", act.title, textFields);
    }];
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
