//
//  NSString+ZJString.m
//  ZJIOS
//
//  Created by Zengjian on 2021/7/2.
//

#import "NSString+ZJString.h"
#import <UIKit/NSAttributedString.h>

@implementation NSString (ZJString)

/**
 非空字符串
 */
- (BOOL)isEmptyString {
    if (self == nil || ([self isKindOfClass:[NSString class]] && self.length == 0)) {
        return YES;
    }
    
    return NO;
}

- (NSString *)pathWithParam:(id)param {
    return [NSString stringWithFormat:@"%@/%@", self, param];
}

- (NSDictionary *)stringToJson {
    if (self == nil) return nil;
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    if(error) {
        NSLog(@"json转化失败：%@", error);
        return nil;
    }
    return dic;
}

- (NSString *)checkSysConflictKey {
    NSArray *sysKeys = @[@"operator", @"intValue", @"description"];
    for (NSString *key in sysKeys) {
        if ([self isEqualToString:key]) {
            return [NSString stringWithFormat:@"i_%@", self];
        }
    }
    
    return self;
}

- (BOOL)isOnlineResource {
    if (![self isEmptyString]) {
        NSString *validPath = [self validHttpsPath];
        if ([validPath hasPrefix:@"http:"] || [validPath hasPrefix:@"https:"]) {
            return YES;
        }
    }
    
    return NO;
}

- (NSString *)validHttpsPath {
    if ([self hasPrefix:@"www."]) {
        return [NSString stringWithFormat:@"https:%@", self];
    }
    
    return self;
}

- (NSString *)separateWithCharacter:(NSString *)cha {
    NSMutableString *string = @"".mutableCopy;
    for (int i = 0; i < self.length; i++) {
        NSString *str = [self substringWithRange:NSMakeRange(i, 1)];
        if (i < self.length -1) {
            [string appendString:[NSString stringWithFormat:@"%@%@", str, cha]];
        }else {
            [string appendString:str];
        }
    }
    return string;
}

/**
 去除字符串HTML标签
 */
- (NSString *)filterHTML {
    NSString *html = self;
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd] == NO) {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
        //去除空格
        html = [html stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return html;
}

- (NSString *)removeLineSeparate {
    if (![self isEmptyString]) {
        return [self stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    
    return self;
}

/**
 翻转字符串: abcd-->dcba
 */
- (NSString *)invertString {
    NSMutableString *str = [NSMutableString string];
    for (int i = (int)self.length; i > 0; i--) {
        [str appendString:[self substringWithRange:NSMakeRange(i-1, 1)]];
    }
    return [str mutableCopy];
}

/**
 翻转字符串2: abcde-->debca
 */
- (NSString *)invertStringWithSegmentLenth:(int)len {
    NSMutableString *str = [NSMutableString string];
    for (int i = (int)self.length; i > 0; i-=len) {
        if (i-len >= 0) {
            [str appendString:[self substringWithRange:NSMakeRange(i-len, len)]];
        }else {
            [str appendString:[self substringWithRange:NSMakeRange(0, i)]];
        }
    }
    return [str mutableCopy];
}

/**
 汉字转拼音
 */
- (NSString *)pinYin {
    if ([self isEmptyString]) {
        return self;
    }
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false);
    
    return mutableString;
}

//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)firstCharactor {
    //转成了可变字符串
    NSString *str = [self pinYin];
    if (str) {
        // 转化为大写拼音
        NSString *pn = [str capitalizedString];
        //获取并返回首字母
        return [pn substringToIndex:1];
    }
    return nil;
}

// 1. 整形判断
- (BOOL)isPureInt {
    NSScanner *scan = [NSScanner scannerWithString:self];
    NSInteger val;
    return [scan scanInteger:&val] && [scan isAtEnd];
}

// 2.浮点形判断：
- (BOOL)isPureFloat {
    NSScanner *scan = [NSScanner scannerWithString:self];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

@end
