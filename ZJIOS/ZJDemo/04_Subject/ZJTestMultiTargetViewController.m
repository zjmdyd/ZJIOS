//
//  ZJTestMultiTargetViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/10/9.
//

#import "ZJTestMultiTargetViewController.h"

@interface ZJTestMultiTargetViewController ()

@end

@implementation ZJTestMultiTargetViewController

/*
 步骤:
 1.复制target,修改target名称
 2.Manage Scheme,修改scheme名称
 3.修改***copy-info.plist名称,再修改plist文件路径,与原来的info.plist文件路径保持一样
 4.配置plist路径，点击新的target,然后在Built Setting 中搜索 info.plist 找到配置项 修改为新info.plist的路径($(SRCROOT)/*//*/*)
 5.Build Setting搜索preprocessor Macros可配置宏
*/
- (void)viewDidLoad {
    [super viewDidLoad];
    
#ifdef PROD_ENV
#ifdef DEBUG
    NSLog(@"net_debug版本");
#else
    NSLog(@"net_release版本");
#endif
#else
#ifdef DEBUG
    NSLog(@"com_debug版本");
#else
    NSLog(@"com_release版本");
#endif
#endif
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
