//
//  UIApplication+SystemService.m
//  ZJIOS
//
//  Created by issuser on 2021/10/9.
//

#import "UIApplication+SystemService.h"

@implementation UIApplication (SystemService)

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

//https://itunes.apple.com/cn/app/id1476388726?mt=8
+ (void)openAppDownloadPageWithAppID:(NSString *)appID {
    if (appID.length) {
        NSString *urlString = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8", appID];
        [self openURLWithURLString:urlString completionHandler:^(BOOL success) {
            if (!success) {
                NSLog(@"******打开下载地址出错********");
            }
        }];
    }else {
        NSLog(@"******打开下载地址出错********");
    }
}

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

@end
