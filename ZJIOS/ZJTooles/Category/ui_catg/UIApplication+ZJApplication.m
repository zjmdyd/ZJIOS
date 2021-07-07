//
//  UIApplication+ZJApplication.m
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import "UIApplication+ZJApplication.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation UIApplication (ZJApplication)

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

- (void)synCooks {
    NSMutableArray *cookieDictionary = [[NSUserDefaults standardUserDefaults] valueForKey:@"cookieArray"];
    
    for (int i = 0; i < cookieDictionary.count; i++) {
        NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults] valueForKey:[cookieDictionary objectAtIndex:i]];
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:dic];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
}

- (void)storeCooks {
    NSMutableArray *cookieArray = [[NSMutableArray alloc] init];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [cookieArray addObject:cookie.name];
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:cookie.name forKey:NSHTTPCookieName];
        [cookieProperties setObject:cookie.value forKey:NSHTTPCookieValue];
        [cookieProperties setObject:cookie.domain forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:cookie.path forKey:NSHTTPCookiePath];
        [cookieProperties setObject:[NSNumber numberWithUnsignedInteger:cookie.version] forKey:NSHTTPCookieVersion];
        [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
        
        [[NSUserDefaults standardUserDefaults] setValue:cookieProperties forKey:cookie.name];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:cookieArray forKey:@"cookieArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeCooks {
    NSMutableArray *cookieDictionary = [[NSUserDefaults standardUserDefaults] valueForKey:@"cookieArray"];
    
    for (int i = 0; i < cookieDictionary.count; i++) {
        NSMutableDictionary* dic = [[NSUserDefaults standardUserDefaults] valueForKey:[cookieDictionary objectAtIndex:i]];
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:dic];
        if (cookie) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:cookie.name];
        }
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cookieArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 系统声音

#ifndef AudioPath
#define AudioPath @"/System/Library/Audio/UISounds/"
#endif

+ (void)playSystemVibrate {
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

+ (void)playSystemSoundWithName:(NSString *)name {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", AudioPath, name]];
    
    [self playWithUrl:url];
}

+ (void)playSoundWithResourceName:(NSString *)name type:(NSString *)type {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    if (path) {
        [self playWithUrl:[NSURL fileURLWithPath:path]];
    }
}

+ (SystemSoundID)playWithUrl:(NSURL *)url {
    return [self playWithUrl:url repeat:NO];
}

+ (void)stopSystemSoundWithSoundID:(SystemSoundID)sound {
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
    AudioServicesDisposeSystemSoundID(sound);
    AudioServicesRemoveSystemSoundCompletion(sound);
}

void soundCompleteCallback(SystemSoundID sound, void * clientData) {
    //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);  //震动
    AudioServicesPlaySystemSound(sound);  // 播放系统声音 这里的sound是我自定义的，不要 copy 哈，没有的
}

+ (SystemSoundID)playWithUrl:(NSURL *)url repeat:(BOOL)repeat {
    if (url) {
        SystemSoundID soundID;
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
        if (error == kAudioServicesNoError) {
            NSLog(@"soundID = %d", soundID);
            //            AudioServicesPlayAlertSound(soundID);
            AudioServicesPlaySystemSound(soundID);
            
            if (repeat) {
                AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
            }
            return soundID;
        }else {
            NSLog(@"******Failed to create sound********");
            return 0;
        }
    }
    
    return 0;
}

#pragma mark - 系统服务

+ (void)systemServiceWithPhone:(NSString *)phone type:(SystemServiceType)type {
    if (phone.length) {
        NSString *str;
        if (type == SystemServiceTypeOfPone) {                  // 电话
            str = [NSString stringWithFormat:@"tel:%@", phone];
        }else if (type == SystemServiceTypeOfMessage) {         // 信息
            str = [NSString stringWithFormat:@"sms:%@", phone];
        }
        
        [self openURLWithURLString:str completionHandler:^(BOOL success) {
            if (!success) {
                NSLog(@"******设备不支持此功能********");
            }
        }];
    }else {
        NSLog(@"******电话号码为空********");
    }
}

//
+ (void)openURLWithURLString:(NSString * _Nonnull )urlString completionHandler:(void (^)(BOOL success))completion {
    NSURL *url = [NSURL URLWithString:urlString];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            if (completion) {
                completion(success);
            }
        }];
    } else {
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }else {
            if (completion) {
                completion(NO);
            }
        }
    }
}

//https://itunes.apple.com/cn/app/id1476388726?mt=8
+ (void)openAppDownloadPage:(NSString *)appID {
    if (appID.length) {
        [self openURLWithURLString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8", appID] completionHandler:^(BOOL success) {
            if (!success) {
                NSLog(@"******下载地址出错********");
            }
        }];
    }else {
        NSLog(@"******下载地址出错********");
    }
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
    return [[self appInfoWithType:AppInfoTypeOfBundleIdentifier] hasPrefix:@"com"];
}

/**
 *  是否是简体中文
 */
+ (BOOL)isSimplifiedChinese {
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"zh-Hans-CN"]) {  // 简体中文
        return YES;
    }
    return NO;
}

// 根据缩写获取语言title
+ (NSString *)getLanguageTitleWithAbbr:(NSString *)abbr {
    for (NSDictionary *dic in [self languageInfo]) {
        if ([dic[@"abbr"] isEqualToString:abbr]) {
            return dic[@"title"];
        }
    }
    
    return @"获取失败";
}

+ (NSArray *)languageInfo {
    return @[
             @{
                 @"title" : @"简体中文", @"abbr" : @"zh-Hans-CN",
                 },
             @{
                 @"title" : @"繁体中文", @"abbr" : @"zh-Hant-CN",
                 },
             @{
                 @"title" : @"繁体中文(香港)", @"abbr" : @"zh-Hant-HK",
                 },
             @{
                 @"title" : @"繁体中文(澳门)", @"abbr" : @"zh-Hant-MO",
                 },
             @{
                 @"title" : @"繁体中文(台湾)", @"abbr" : @"zh-Hant-TW",
                 },
             @{
                 @"title" : @"英文", @"abbr" : @"en-CN",
                 },
             ];
}

#pragma mark - Network state

+ (NSString *)netWorkStates {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    NSString *state = [[NSString alloc] init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    break;
                case 1:
                    state =  @"2G";
                    break;
                case 2:
                    state =  @"3G";
                    break;
                case 3:
                    state =   @"4G";
                    break;
                case 5:
                    state =  @"wifi";
                    break;
                default:
                    break;
            }
        }
    }
    return state;
}
/*
 Access WiFi Infomation
 */
+ (id)fetchCurrentWiFiInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) {
            break;
        }
    }
    return info;
}

+ (NSString *)ipAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
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
