//
//  NSString+ZJTextDisplay.m
//  ZJIOS
//
//  Created by issuser on 2021/11/24.
//

#import "NSString+ZJTextDisplay.h"
#import "NSString+ZJString.h"

@implementation NSString (ZJTextDisplay)

- (NSString *)descriptionStr {
    return [self descriptionStrWithDefault:@"--"];
}

- (NSString *)descriptionStrWithDefault:(NSString *)defaultStr {
    if ([self isEmptyString]) {
        return defaultStr;
    }
    
    return self;
}

#pragma mark - 填充字符串

- (NSString *)fillStringWithCharacter:(NSString *)character len:(NSInteger)len {
    return [self fillStringWithCharacter:character len:len atBegan:YES];
}

- (NSString *)fillStringWithCharacter:(NSString *)character len:(NSInteger)len atBegan:(BOOL)began {
    if (self.length < len) {
        NSMutableString *str = [self mutableCopy];
        NSInteger count = len - self.length;
        for (int i = 0; i < count; i++) {
            if (began) {
                [str insertString:character atIndex:0];
            }else {
                [str appendString:character];
            }
        }
        
        return str;
    }
    
    return self;
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

@end
