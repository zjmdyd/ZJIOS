//
//  UIApplication+International.m
//  ZJIOS
//
//  Created by issuser on 2021/10/9.
//

#import "UIApplication+International.h"

@implementation UIApplication (International)

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

@end
