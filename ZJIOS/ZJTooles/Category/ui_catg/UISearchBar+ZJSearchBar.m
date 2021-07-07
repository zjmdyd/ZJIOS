//
//  UISearchBar+ZJSearchBar.m
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import "UISearchBar+ZJSearchBar.h"
#import "UIImage+ZJImage.h"

@implementation UISearchBar (ZJSearchBar)

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    for (UIView *view in self.subviews) {
        for (UIView *sView in view.subviews) {
            if ([NSStringFromClass([sView class]) isEqualToString:@"UISearchBarBackground"]) {
                ((UIImageView *)sView).image = [UIImage imageWithColor:[UIColor groupTableViewBackgroundColor]];
                break;
            }
        }
    }
}

- (void)setCancelBtnTitleColor:(UIColor *)color {
    for(UIView *view in  [[[self subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton *btn =(UIButton *)view;
            btn.tintColor = color;
        }
    }
}

@end
