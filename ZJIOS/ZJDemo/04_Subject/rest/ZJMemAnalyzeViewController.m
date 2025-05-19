//
//  ZJMemAnalyzeViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/17.
//

#import "ZJMemAnalyzeViewController.h"

@interface ZJMemAnalyzeViewController ()

@end

@implementation ZJMemAnalyzeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
 性能优化:
 1.启动过程中做的事情越少越好
 2.不要再在主线程做耗时操作
 2.避免cell的重新布局
 3.提前计算cell高度
 4.数据分页，数据缓存
 5..使用局部更新，若是只是更新某组的话，使用reloadSection进行局部更
 
 内存优化
 1、静态检测
 其实有些内存泄漏也可以用静态方法检测出来，静态检测分为手动检测和自动检测
 手动检测方式：快捷键command + shift + B
 自动检测方法：build setting --> analyze during building 设为YES，这样每次运行代码都会检测内存泄漏问题
 2.动态监测:Instruments的leak工具
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
