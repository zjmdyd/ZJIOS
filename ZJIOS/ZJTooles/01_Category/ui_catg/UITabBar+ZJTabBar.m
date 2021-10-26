//
//  UITabBar+ZJTabBar.m
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import "UITabBar+ZJTabBar.h"

@implementation UITabBar (ZJTabBar)

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [[UITabBar appearance] setBarTintColor:backgroundColor];
    [UITabBar appearance].translucent = NO;
    
    // 第二种方式
//    UIView *view = [[UIView alloc]init];
//    view.backgroundColor = [UIColor redColor];
//    view.frame = self.tabBar.bounds;
//    [[UITabBar appearance] insertSubview:view atIndex:0];
    //    //还有第三种方法就是使用背景图片：
    //    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabBarBackgroundImage"]];
    //    [UITabBar appearance].translucent = NO;
}

@end
