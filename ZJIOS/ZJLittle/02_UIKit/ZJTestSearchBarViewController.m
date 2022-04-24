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

@interface ZJTestSearchBarViewController ()

@end

@implementation ZJTestSearchBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 100, kScreenW, 100)];
    searchBar.prompt = @"提示";
    searchBar.placeholder = @"请输入";
    searchBar.showsCancelButton = YES;
    [searchBar setCancelBtnTitleColor:[UIColor redColor]];
    [self.view addSubview:searchBar];
//    [searchBar logSubViews];
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
