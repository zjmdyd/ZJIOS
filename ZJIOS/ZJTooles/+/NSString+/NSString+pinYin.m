//
//  NSString+pinYin.m
//  123
//
//  Created by ys on 15/11/26.
//  Copyright © 2015年 ys. All rights reserved.
//

#import "NSString+pinYin.h"

@implementation NSString (pinYin)

- (NSString *)pinyin
{
    return [self stringToPinyin];
}

- (NSString *)pinyinWithSign
{
    return [self stringToPinyinWithSign];
}

- (NSString*)pinyinFirst
{
    NSString* str = [self stringToPinyin];
    if (str.length >1) {
        str = [str substringToIndex:1];
    }
    return str;
}

- (NSString *)stringToPinyinWithSign
{
    if ([self length] > 0) {
        NSMutableString *ms = [[NSMutableString alloc] initWithString:self];
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
            //NSLog(@"pinyin: %@", ms);
            return ms;
        }
    }
    return self;
}

- (NSString *)stringToPinyin
{
    if ([self length] > 0) {
        NSMutableString *ms = [[NSMutableString alloc] initWithString:self];
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
        }
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
            //NSLog(@"pinyin: %@", ms);
            return ms;
        }
    }
    return self;
}

+ (NSString *)spe_stringWithUUID{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}

@end
