//
//  UISearchBar+ZJSearchBar.m
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import "UISearchBar+ZJSearchBar.h"
#import "UIView+ZJView.h"
#import "UIImage+ZJImage.h"

#define SearchBarBackground @"UISearchBarBackground"
#define NavigationButton @"UINavigationButton"

@implementation UISearchBar (ZJSearchBar)

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    UIView *subView = [self fetchSubViewWithClassName:SearchBarBackground];
    if (subView && [subView isKindOfClass:[UIImageView class]]) {
        ((UIImageView *)subView).image = [UIImage imageWithColor:backgroundColor];
    }else {
        NSLog(@"未找到subView:%@", SearchBarBackground);
    }
}

- (void)setCancelBtnTitleColor:(UIColor *)color {
    UIView *subView = [self fetchSubViewWithClassName:NavigationButton];
    if (subView) {
        [((UIButton *)subView) setTitleColor:color forState:UIControlStateNormal];
    }
}

- (void)setCancelBtnTitle:(NSString *)title {
    UIView *subView = [self fetchSubViewWithClassName:NavigationButton];
    if (subView && [subView isMemberOfClass:NSClassFromString(NavigationButton)]) {
        [((UIButton *)subView) setTitle:title forState:UIControlStateNormal];
    }
}

@end
