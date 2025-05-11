//
//  ZJTestUIAppearanceViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/4/29.
//

#import "ZJTestUIAppearanceViewController.h"
#import "ZJTestAppearanceView.h"
#import "ZJLayoutDefines.h"
#import "ZJTestAppearanceViewController.h"

@interface ZJTestUIAppearanceViewController ()

@end

@implementation ZJTestUIAppearanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 修改部分实例需要使用另外的API,会先调用修改全部实例的方法
    [ZJTestAppearanceView appearanceWhenContainedInInstancesOfClasses:@[[UINavigationController class]]].leftColor = [UIColor greenColor];
    
    // 修改全部实例需要使用的API
    // 此处不会调用setter方法
    [[ZJTestAppearanceView appearance] setLeftColor:[UIColor redColor]];
    [[ZJTestAppearanceView appearance] setRightColor:[UIColor yellowColor]];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 500, 100, 50)];
    [btn setTitle:@"next" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(nextEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    NSLog(@"didLoad完成");
}

- (void)nextEvent:(UIButton *)sender {
    // 未被UINavigationController包含，修改部分实例的设置greenColor不会生效
    ZJTestAppearanceViewController *vc = [ZJTestAppearanceViewController new];
    /*
     Defaults to UIModalPresentationAutomatic on iOS starting in iOS 13.0, and UIModalPresentationFullScreen on previous versions. Defaults to UIModalPresentationFullScreen on all other platforms.
     */
    if (@available(iOS 13.0, *)) {
        vc.modalPresentationStyle = UIModalPresentationAutomatic;   // iOS13及以后的默认值
    } else {
        // Fallback on earlier versions
    }
    [self presentViewController:vc animated:YES completion:nil];
}

/*
 而当ZJTestAppearanceView视图被加到主视图（容器）的时候才走了setter方法，这说明：
 在通过appearance设置属性的时候，并不会生成实例，立即赋值，而需要视图被加到视图tree中的时候才会生产实例。

 所以使用 UIAppearance 只有在视图添加到 window 时才会生效，对于已经在 window 中的视图并不会生效。因此，对于已经在 window 里的视图，可以采用从视图里移除并再次添加回去的方法使得 UIAppearance 的设置生效。


 每一个实现 UIAppearance 协议的类，都会有一个 _UIApperance 实例，保存着这个类通过appearance 设置属性的 invocations，在该类被添加或应用到视图树上的时候，它会检查并调用这些属性设置。这样就实现了让所有该类的实例都自动统一属性。appearance 只是起到一个代理作用，在特定的时机，让代理替所有实例做同样的事
 
 // 会先调用 [[ZJTestAppearanceView appearance] setLeftColor:[UIColor redColor]];
再调用appearanceWhenContainedInInstancesOfClasses
 
  -[ZJTestAppearanceView setLeftColor:], UIExtendedSRGBColorSpace 1 0 0 1
  -[ZJTestAppearanceView setRightColor:]

  -[ZJTestAppearanceView setLeftColor:], UIExtendedSRGBColorSpace 0 1 0 1
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    ZJTestAppearanceView *view = [[ZJTestAppearanceView alloc] initWithFrame:CGRectMake(10, 100, kScreenW-20, 150)];
    [self.view addSubview:view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 在此处设置不生效，在创建naviBar之前设置才会生效
    [UINavigationBar appearance].backgroundColor = [UIColor cyanColor];
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
