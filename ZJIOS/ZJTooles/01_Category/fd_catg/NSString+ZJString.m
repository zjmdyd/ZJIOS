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

@end
