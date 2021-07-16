//
//  ZJMainTabBarViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/13.
//

#import "ZJMainTabBarViewController.h"

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
    NSArray *titles = @[@"Foundation", @"UIKit", @"Subject"];
    NSArray *images = @[@"b-tab-1", @"b-tab-11", @"b-tab-31"];   // @"3",
    NSArray *selectImages = @[@"b-tab-2", @"b-tab-12", @"b-tab-32"];   // @"3-1",
    NSArray *vcNames = @[@"ZJFoundationTableViewController", @"ZJUIKitTableViewController", @"ZJSubjectTableViewController"];
    
    NSMutableArray *ary = [NSMutableArray array];
    for (int i = 0; i < vcNames.count; i++) {
        UIViewController *vc = [NSClassFromString(vcNames[i]) alloc];
        if ([vc isKindOfClass:[UITableViewController class]]) {
            vc = [(UITableViewController *)vc initWithStyle:UITableViewStyleGrouped];
        }else {
            vc = [vc init];
            UIColor *color = [UIColor whiteColor];
            vc.view.backgroundColor = color;
        }
        
        if ([vc isKindOfClass:[UIViewController class]]) {
            vc.title = titles[i];
        }
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
//        navi.navigationBarBgColor = [UIColor mainColor];
//        navi.navigationBarTintColor = [UIColor whiteColor];
        if (images.count) {
            navi.tabBarItem.image = [[UIImage imageNamed:images[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        if (selectImages.count) {
            navi.tabBarItem.selectedImage = [[UIImage imageNamed:selectImages[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
//        [navi.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor mainColor]} forState:UIControlStateSelected];
        [ary addObject:navi];
    }
    self.tabBar.translucent = NO;
    self.viewControllers = ary;//[ary copy];
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
