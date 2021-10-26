//
//  UIApplication+Cooks.m
//  ZJIOS
//
//  Created by issuser on 2021/10/9.
//

#import "UIApplication+Cooks.h"

@implementation UIApplication (Cooks)

+ (void)synCooks {
    NSMutableArray *cookieDictionary = [[NSUserDefaults standardUserDefaults] valueForKey:@"cookieArray"];
    
    for (int i = 0; i < cookieDictionary.count; i++) {
        NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults] valueForKey:[cookieDictionary objectAtIndex:i]];
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:dic];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
}

+ (void)storeCooks {
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

+ (void)removeCooks {
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

@end
