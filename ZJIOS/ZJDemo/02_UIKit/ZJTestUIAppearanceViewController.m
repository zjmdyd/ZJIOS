//
//  ZJTestUIAppearanceViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/4/29.
//

#import "ZJTestUIAppearanceViewController.h"
#import "ZJTestAppearanceView.h"
#import "ZJLayoutDefines.h"

@interface ZJTestUIAppearanceViewController ()

@end

@implementation ZJTestUIAppearanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 此处不会调用setter方法
    [[ZJTestAppearanceView appearance] setLeftColor:[UIColor redColor]];
    [[ZJTestAppearanceView appearance] setRightColor:[UIColor yellowColor]];
}
/*
 每一个实现 UIAppearance 协议的类，都会有一个 _UIApperance 实例，保存着这个类通过 appearance 设置属性的 invocations，在该类被添加或应用到视图树上的时候，它会检查并调用这些属性设置。这样就实现了让所有该类的实例都自动统一属性。appearance 只是起到一个代理作用，在特定的时机，让代理替所有实例做同样的事
 */

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
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
