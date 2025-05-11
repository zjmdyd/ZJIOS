//
//  ZJTestDarkModeViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2025/5/11.
//

#import "ZJTestDarkModeViewController.h"
#import "ZJDarmModeView.h"
#import "ZJDarkModeLael.h"

@interface ZJTestDarkModeViewController ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation ZJTestDarkModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 13.0, *)) {
        [ZJDarmModeView appearance].backgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            NSLog(@"view动态color:%ld", (long)traitCollection.userInterfaceStyle);
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor redColor];
            }else {
                return [UIColor whiteColor];
            }
        }];

        [ZJDarkModeLael appearance].textColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            NSLog(@"label动态color");
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor whiteColor];
            }else {
                return [UIColor blackColor];
            }
        }];
    } else {
        // Fallback on earlier versions
    }
   
    
    ZJDarmModeView *view = [[ZJDarmModeView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    view.center = self.view.center;
    [self.view addSubview:view];
    
    self.label = [[ZJDarkModeLael alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    self.label.center = CGPointMake(150, 100);
    self.label.text = @"light mode";
    self.label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:self.label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 100, 30);
    btn.center = CGPointMake(self.label.center.x, self.label.center.y+70);
    [btn setTitle:@"切换模式" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
}

- (void)btnEvent:(UIButton *)sender {
    if (@available(iOS 13.0, *)) {
        UITraitCollection *traitCollection = [UITraitCollection currentTraitCollection];
        UIUserInterfaceStyle style;
        NSString *str;
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            style = UIUserInterfaceStyleLight;
            str = @"light mode";
        }else {
            style = UIUserInterfaceStyleDark;
            str = @"dark mode";
        }
        
        self.label.text = str;
//      如果只是普通的view修改overrideUserInterfaceStyle不会影响前面的和后面推出的controller
//      但是在window上设置会影响全局和后边推出的controller，所以UIAppearance的方法会再次调用
        
        NSLog(@"[UIApplication sharedApplication].keyWindow = %@", [UIApplication sharedApplication].keyWindow);
        [UIApplication sharedApplication].keyWindow.overrideUserInterfaceStyle = style;
        self.overrideUserInterfaceStyle = style;

        for (UIWindowScene *wn in [UIApplication sharedApplication].connectedScenes) {
            NSLog(@"wn = %@", wn);
            NSLog(@"wn.windows = %@", wn.windows);
            if (@available(iOS 15.0, *)) {
                NSLog(@"wn.keyWindow = %@", wn.keyWindow);  // 与sharedApplication->keyWindow是同一个
            } else {
                // Fallback on earlier versions
            }  //
        }
//        [sender setTitle:@"切换模式" forState:UIControlStateNormal];
//        [sender setTitle:@"Highlighted" forState:UIControlStateHighlighted];
//        [sender setTitle:@"Selected" forState:UIControlStateSelected];  // UIButton没有Selected状态
    } else {
        // Fallback on earlier versions
    }
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
