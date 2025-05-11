//
//  ZJTestSearchBarViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/2/14.
//

#import "ZJTestSearchBarViewController.h"
#import "ZJLayoutDefines.h"
#import "UISearchBar+ZJSearchBar.h"
#import "UIView+ZJView.h"
#import "UIImage+ZJImage.h"

@interface ZJTestSearchBarViewController ()<UISearchBarDelegate>

@end

@implementation ZJTestSearchBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 100, kScreenW, 44)];
//    searchBar.prompt = @"提示";
    searchBar.text = @"";
    searchBar.placeholder = @"请输入";
    searchBar.showsCancelButton = YES;
    searchBar.delegate = self;
    searchBar.tintColor = [UIColor redColor];   // 只在searchBar响应状态才会起作用，
    UILabel *ipv = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 20)];
    ipv.text = @"我是打酱油的";
    searchBar.inputAccessoryView = ipv;
//    searchBar.barTintColor = [UIColor greenColor]; //设置barTintColor修改背景色会影响属性tintColor效果
    [searchBar setBackgroundImage:[UIImage imageWithColor:[UIColor greenColor]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    if (@available(iOS 13.0, *)) {
        searchBar.searchTextField.text = @"hh";
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%s", __func__);
    [searchBar resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].title = @"取消";
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
