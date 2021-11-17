//
//  ZJTestAlertViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/7/16.
//

#import "ZJTestAlertViewController.h"
#import "UIViewController+ZJViewController.h"

@interface ZJTestAlertViewController ()

@end

@implementation ZJTestAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test];
}

- (void)test {
    ZJAlertObject *obj = [ZJAlertObject new];
    obj.title = @"标题";
    obj.msg = @"message";
    obj.actTitles = @[@"取消", @"确定"];
    obj.actTitleColors = @[[UIColor redColor], [UIColor greenColor]];
//    obj.needDestructive = YES;
//    obj.destructiveIndex = 1;
    obj.alertStyle = UIAlertControllerStyleAlert;
    ZJTextInputConfig *cfg = [[ZJTextInputConfig alloc] init];
    cfg.text = @"hello";
    cfg.textColor = [UIColor redColor];
    obj.textFieldConfigs = @[cfg];
    [self alertFunc:obj alertCompl:^(ZJAlertAction *act, NSArray *textFields) {
        NSLog(@"%@--%@--%ld", act.title, textFields, (long)act.tag);
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
