//
//  UIApplication+ZJApplication.m
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import "UIApplication+ZJApplication.h"

@implementation UIApplication (ZJApplication)

+ (CGFloat)getStatusBarHight {
    float statusBarHeight = 0;
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
        statusBarHeight = statusBarManager.statusBarFrame.size.height;
    }else {
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    return statusBarHeight;
}

+ (UIViewController *)zj_getRootViewController {
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}

+ (UIViewController *)zj_getCurrentViewController {
    UIViewController* currentViewController = [self zj_getRootViewController];
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        }else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController* navigationController = (UINavigationController* )currentViewController;
            currentViewController = [navigationController.childViewControllers lastObject];
            
        }else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController* tabBarController = (UITabBarController* )currentViewController;
            currentViewController = tabBarController.selectedViewController;
        }else {
            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
            if (childViewControllerCount > 0) {
                currentViewController = currentViewController.childViewControllers.lastObject;
                return currentViewController;
            } else {
                return currentViewController;
            }
        }
    }
    return currentViewController;
}

+ (UIViewController *)currentVC {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];    // UILayoutContainerView
    id nextResponder = [frontView nextResponder];               // ZJBaseTabBarViewController
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
        
        UIView *view = [self subViews:[frontView subviews][0]];
        if ([[view nextResponder] isKindOfClass:[UIViewController class]]) {
            result = (UIViewController *)[view nextResponder];
        }
    }
    
    else
        result = window.rootViewController;
    
    return result;
}

+ (UIView *)subViews:(UIView *)view {
    if (view.subviews.count) {
        for (UIView *subView in view.subviews) {
            if (![[view nextResponder] isKindOfClass:[UINavigationController class]] && [[view nextResponder] isKindOfClass:[UIViewController class]]) {
                return view;
            }else {
                return [self subViews:subView];
            }
        }
    }
    
    return view;
}

#pragma mark - App info

+ (NSString *)appInfoWithType:(AppInfoType)type {
    NSArray *key = @[@"CFBundleDisplayName", @"CFBundleName", @"CFBundleShortVersionString", @"CFBundleVersion", @"CFBundleIdentifier"];
    NSDictionary *infoDictionary = [self appInfoDic];
    return [infoDictionary objectForKey:key[type]];
}

+ (NSDictionary *)appInfoDic {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return infoDictionary;
}

+ (BOOL)isComVersion {
    return [[self appInfoWithType:AppInfoTypeBundleIdentifier] hasPrefix:@"com"];
}

#pragma mark - 判断是否安装某APP

+ (BOOL)installedQQ {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
}

+ (BOOL)installedWeiXin {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
}

+ (BOOL)installedAlipay {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]];
}

@end
