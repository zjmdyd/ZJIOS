//
//  ZJMainTabBarViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/13.
//

#import "ZJMainTabBarViewController.h"
#import "UIViewController+ZJViewController.h"
#import "AppConfigHeader.h"
#import "ZJNavigationController.h"
#import "ZJTabBar.h"

@interface ZJMainTabBarViewController ()

@property (nonatomic, strong) ZJTabBar *zjTabBar;

@end

@implementation ZJMainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refactorCenterBtn];
    [self initSetting];
}

- (void)refactorCenterBtn {
    self.zjTabBar = [[ZJTabBar alloc] initWithImageName:@"b-tab-41"];
    [self.zjTabBar.centerBtn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    // 选中时的颜色
    self.zjTabBar.tintColor = [UIColor colorWithRed:27.0/255.0 green:118.0/255.0 blue:208/255.0 alpha:1];
    // 透明设置为NO，显示白色，view的高度到tabbar顶部截止，YES的话到底部
    self.zjTabBar.translucent = NO;
    
    // 在自定义 UITabBarController 子类中替换默认 TabBar
    [self setValue:self.zjTabBar forKeyPath:@"tabBar"];
//    __weak typeof(self) weekSelf = self;
//    self.delegate =  weekSelf;
}

- (void)btnEvent:(UIButton *)sender {
    
}

- (void)initSetting {
    NSArray *titles = @[@"Foundation", @"UIKit", @"Controller", @"Subject", @"C"];
    NSArray *images = @[@"b-tab-1", @"b-tab-11", @"", @"b-tab-31", @"b-tab-31"];    // b-tab-31
    NSArray *selectImages = @[@"b-tab-2", @"b-tab-12", @"", @"b-tab-32", @"b-tab-32"];  // b-tab-32
    NSArray *vcNames = @[@"ZJFoundationTableViewController", @"ZJUIKitTableViewController", @"ZJCtrlTableViewController", @"ZJSubjectTableViewController", @"ZJCTipsTableViewController"];
    
    NSMutableArray *ary = [NSMutableArray array];
    for (int i = 0; i < vcNames.count; i++) {
        UIViewController *vc = [UIViewController createVCWithName:vcNames[i] title:titles[i]];
        ZJNavigationController *navi = [[ZJNavigationController alloc] initWithRootViewController:vc];
        if (images.count == vcNames.count) {
            vc.tabBarItem.image = [[UIImage imageNamed:images[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        if (selectImages.count == vcNames.count) {
            vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImages[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        
        self.tabBar.tintColor = MainColor;
        
        if (@available(iOS 10.0, *)) {
            self.tabBar.unselectedItemTintColor = [UIColor grayColor];
        } else {
            [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : MainColor} forState:UIControlStateSelected];
            [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor groupTableViewBackgroundColor]} forState:UIControlStateNormal];
        }
        [ary addObject:navi];
    }
    
    self.viewControllers = ary;

    self.selectedIndex = 3;
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
