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

@interface ZJMainTabBarViewController ()

//@property (nonatomic, strong) NSArray *vcNames;
//@property (nonatomic, strong) NSArray *titles;
//@property (nonatomic, strong) NSArray *images;
//@property (nonatomic, strong) NSArray *selectImages;

@end

@implementation ZJMainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSetting];
}

- (void)initSetting {
    NSArray *titles = @[@"Foundation", @"UIKit", @"Controller", @"Subject"];
    NSArray *images = @[@"b-tab-1", @"b-tab-11", @"b-tab-31", @"b-tab-31"];
    NSArray *selectImages = @[@"b-tab-2", @"b-tab-12", @"b-tab-32", @"b-tab-32"];
    NSArray *vcNames = @[@"ZJFoundationTableViewController", @"ZJUIKitTableViewController", @"ZJCtrlTableViewController", @"ZJSubjectTableViewController"];
    
    NSMutableArray *ary = [NSMutableArray array];
    for (int i = 0; i < vcNames.count; i++) {
        UIViewController *vc = [UIViewController createVCWithName:vcNames[i] title:titles[i] hidesBottom:NO];
        ZJNavigationController *navi = [[ZJNavigationController alloc] initWithRootViewController:vc];
//        navi.navigationBar.backgroundColor = MainColor;
        //        navi.navigationBar.translucent = YES;
//                navi.navigationBarBgColor = [UIColor mainColor];
        //        navi.navigationBarTintColor = [UIColor whiteColor];
        if (images.count == vcNames.count) {
            vc.tabBarItem.image = [[UIImage imageNamed:images[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        if (selectImages.count == vcNames.count) {
            vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImages[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        
        if (@available(iOS 10.0, *)) {
            self.tabBar.tintColor = MainColor;
            self.tabBar.unselectedItemTintColor = [UIColor grayColor];
        } else {
            [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : MainColor} forState:UIControlStateSelected];
            [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor groupTableViewBackgroundColor]} forState:UIControlStateNormal];
        }
        [ary addObject:navi];
    }
//        self.tabBar.translucent = NO;
    
    // tabBarItem: you should not access this property if you are not using a tab bar controller to display the view controller
    self.viewControllers = ary;
    NSLog(@"tabBar.items = %@", self.tabBar.items);
    self.selectedIndex = 1;
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
