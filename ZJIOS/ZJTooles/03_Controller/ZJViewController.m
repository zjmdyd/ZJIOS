//
//  ZJViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/14.
//

#import "ZJViewController.h"
#import "AppConfigHeader.h"

@interface ZJViewController ()

@end

@implementation ZJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSuperSetting];
}

- (void)initSuperSetting {
#ifdef DefaultViewBackgroundColor
    self.view.backgroundColor = DefaultViewBackgroundColor;
#endif
}

- (void)dealloc {
    NSLog(@"%s, currentVC = %@", __func__, self.class);
    if (self.timer) {
        NSLog(@"调用了[self.timer invalidate]方法, 手动释放了timer");
        [self.timer invalidate];
    }
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    NSLog(@"%s", __func__);
    
    if (@available(iOS 13.0, *)) {
        UITraitCollection *traitCollection = [UITraitCollection currentTraitCollection];
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            self.view.backgroundColor = [UIColor darkGrayColor];
        }else {
            self.view.backgroundColor = [UIColor whiteColor];
        }
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
