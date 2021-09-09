//
//  NSString+ZJString.m
//  ZJIOS
//
//  Created by Zengjian on 2021/7/2.
//

#import "NSString+ZJString.h"
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/NSAttributedString.h>

@implementation NSString (ZJString)

/**
 非空字符串
 */
- (BOOL)isNoEmptyString {
    if (self != nil && [self isKindOfClass:[NSString class]] && self.length) {
        return YES;
    }
    
    return NO;
}

- (NSString *)descriptionStr {
    return [self descriptionStrWithDefault:@"--"];
}

- (NSString *)descriptionStrWithDefault:(NSString *)defaultStr {
    if ([self isNoEmptyString]) {
        return self;
    }
    
    return defaultStr;
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
        NSLog(@"json转化失败：%@",error);
        return nil;
    }
    return dic;
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

- (BOOL)isOnlineResource {
    if ([self isNoEmptyString]) {
        if ([[self validHttpsPath] hasPrefix:@"http:"] || [[self validHttpsPath] hasPrefix:@"https:"]) {
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

- (NSString *)checkSysConflictKey {
    NSArray *sysKeys = @[@"operator", @"intValue", @"description"];
    for (NSString *key in sysKeys) {
        if ([self isEqualToString:key]) {
            return [NSString stringWithFormat:@"i_%@", self];
        }
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

/**
 翻转字符串: abcd-->dcba
 */
- (NSString *)invertString {
    NSMutableString *str = [NSMutableString string];
    for (NSUInteger i = self.length; i > 0; i--) {
        [str appendString:[self substringWithRange:NSMakeRange(i-1, 1)]];
    }
    return [str mutableCopy];
}

/**
 翻转字符串2: abcd-->cdba
 */
- (NSString *)invertByteString {
    NSMutableString *str = [NSMutableString string];
    for (NSUInteger i = self.length; i > 0; i-=2) {
        [str appendString:[self substringWithRange:NSMakeRange(i-2, 2)]];
    }
    return [str mutableCopy];
}

/**
 汉字转拼音
 */
- (NSString *)pinYin {
    if (![self isNoEmptyString]) {
        return self;
    }
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false);
    
    return mutableString;
}

//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)firstCharactor {
    if (![self isNoEmptyString]) {
        return self;
    }
    //转成了可变字符串
    NSString *str = [self pinYin];
    //转化为大写拼音
    NSString *pn = [str capitalizedString];
    //获取并返回首字母
    return [pn substringToIndex:1];
}

- (NSString *)timeYMDString {
    return [self timeYMDStringDefaultString:@""];
}

- (NSString *)timeYMDStringDefaultString:(NSString *)str {
    if (self) {
        NSArray *ary = [self componentsSeparatedByString:@" "];
        if (ary.count == 2) {
            return ary[0];
        }
    }
    
    return str;
}

- (NSString *)timeHMSString {
    return [self timeHMSStringDefaultString:@""];
    
}

- (NSString *)timeHMSStringDefaultString:(NSString *)str {
    if (self) {
        NSArray *ary = [self componentsSeparatedByString:@" "];
        if (ary.count == 2) {
            return ary[1];
        }
    }
    
    return str;
}

- (NSString *)pureTextString {
    if ([self isNoEmptyString]) {
        NSAttributedString *att = [[NSAttributedString alloc] initWithData:[self dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        return att.string;
    }
    
    return self;
}

- (NSString *)removeLineSeparate {
    if ([self isNoEmptyString]) {
        return [self stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    
    return self;
}

- (BOOL)judgeLetter {
    if (![self isNoEmptyString]) {
        return NO;
    }
    NSString *regex = @"[A-Za-z]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [predicate evaluateWithObject:self];
}

#pragma MD5加密

- (NSString *)hy_md5 {
    return [self hy_md5WithType:MD5Type32BitLowercase];
}

- (NSString *)hy_md5WithType:(MD5Type)type {
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02X", result[i]];
    
    NSString *MD5Strubg = @"";
    
    switch (type) {
        case MD5Type16BitLowercase:
            MD5Strubg = [[hash lowercaseString] substringWithRange:NSMakeRange(8, 16)];
            break;
        case MD5Type16BitUppercase:
            MD5Strubg = [[hash uppercaseString] substringWithRange:NSMakeRange(8, 16)];
            break;
        case MD5Type32BitLowercase:
            MD5Strubg = [hash lowercaseString];
            break;
        case MD5Type32BitUppercase:
            MD5Strubg = [hash uppercaseString];
            break;
    }
    return MD5Strubg;
}

#pragma 字符串编码

- (NSString *)URLEncodedString {
    NSString *unencodedString = self;
    if (!unencodedString) return nil;
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

/**
 *  URLDecode
 */
- (NSString *)URLDecodedString {
    NSString *encodedString = self;
    if (!encodedString) return nil;
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
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

- (NSString *)addWrapStyle {
    NSMutableString *changeStr = self.mutableCopy;
    NSInteger offsetLoc = 0;
    for (int i = 0; i < self.length; i++) {
        NSString *sub = [self substringWithRange:NSMakeRange(i, 1)];
        if ([sub isEqualToString:@","]) {       // 找到标点符号
            NSLog(@"找到标点符号:%@ loc = %d", sub, i);
            int j = i - 2;                      // 记录h5标签结尾位置
            NSString *sub2 = [self substringWithRange:NSMakeRange(i - 1, 1)];
            if ([sub2 isEqualToString:@">"]) {  // 找到标点符号前面紧挨着的h5标签
                NSLog(@"找到h5结束位置:%d", i - 1);
                NSMutableString *mark = [NSMutableString string];  // 记录h5标签的字符串
                while (j >= 0) {
                    NSString *beforeChar = [self substringWithRange:NSMakeRange(j, 1)];
                    if ([beforeChar isEqualToString:@"<"]) { // 找到匹配的h5标签
                        NSLog(@"找到h5开始:%d, 结束的h5标签 = %@", j, mark);
                        break;
                    }else {
                        [mark insertString:beforeChar atIndex:0];
                        NSLog(@"mark = %@", mark);
                    }
                    j--;
                }
                NSInteger beganMarkLen = mark.length + 1; // 3 + 2 + 4
                NSInteger startLoc = j - beganMarkLen;
                NSString *beganMark = [NSString stringWithFormat:@"<%@>", [mark substringFromIndex:1]];
                NSLog(@"需要匹配的beganMark = %@", beganMark);
                while (startLoc >= 0) {
                    NSString *beganMatchStr = [self substringWithRange:NSMakeRange(startLoc, beganMarkLen)];
                    NSLog(@"往前找:%@, startLoc = %ld", beganMatchStr, (long)startLoc);
                    if ([beganMatchStr isEqualToString:beganMark]) {
                        NSLog(@"匹配到了, 开始位置:%ld", (long)startLoc);
                        NSString *inseartTag = @"<h11>";
                        [changeStr insertString:[inseartTag endTagString] atIndex:i+1 + offsetLoc];
                        [changeStr insertString:inseartTag atIndex:startLoc + offsetLoc];
                        offsetLoc += 11;
                        NSLog(@"匹配后的结果:%@, offsetLoc = %ld", changeStr, (long)offsetLoc);
                        break;
                    }else {
                        startLoc--;
                    }
                }
            }
        }
    }
    
    return changeStr;
}

- (NSString *)endTagString {
    NSString *endTagStr = [self substringWithRange:NSMakeRange(1, self.length-2)];
    return [NSString stringWithFormat:@"</%@>", endTagStr];
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

#pragma mark - 文件存储

- (NSString *)jsonFilePath {
    NSString *fileName = [self hy_md5WithType:MD5Type32BitUppercase];
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json", fileName]];
    return filePath;
}

#pragma mark - 正则

- (BOOL)hasNumber {
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合数字条件的有几个字节
    NSUInteger count = [reg numberOfMatchesInString:self
                                            options:NSMatchingReportProgress
                                              range:NSMakeRange(0, self.length)];
    return count > 0;
}

//手机号正则
- (BOOL)isValidPhone {
    NSString * MOBIL = @"^1(3[0-9]|4[0-9]|5[0-9]|6[0-9]|7[0-9]|8[0-9]|9[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    if ([regextestmobile evaluateWithObject:self]) {
        return YES;
    }
    
    return NO;
}

//身份证号正则
- (BOOL)isValidID {
    //长度不为18的都排除掉
    if (self.length != 18) return NO;
    
    //校验格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    BOOL flag = [identityCardPredicate evaluateWithObject:self];
    
    if (!flag) {
        return flag;    // 格式错误
    }else {
        //格式正确在判断是否合法
        
        //将前17位加权因子保存在数组里
        NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
        
        //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
        
        //用来保存前17位各自乖以加权因子后的总和
        NSInteger idCardWiSum = 0;
        for(int i = 0;i < 17;i++) {
            NSInteger subStrIndex = [[self substringWithRange:NSMakeRange(i, 1)] integerValue];
            NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
            
            idCardWiSum+= subStrIndex * idCardWiIndex;
        }
        
        //计算出校验码所在数组的位置
        NSInteger idCardMod=idCardWiSum%11;
        
        //得到最后一位身份证号码
        NSString * idCardLast= [self substringWithRange:NSMakeRange(17, 1)];
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2) {
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
                return YES;
            }else {
                return NO;
            }
        }else {
            // 用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
                return YES;
            }else {
                return NO;
            }
        }
    }
}

+ (NSString *)hy_stringFromDate:(NSDate *)date withFormat:(NSString *)format {
    static NSDateFormatter *dateFormater = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormater = [[NSDateFormatter alloc] init];
    });
    dateFormater.timeZone = [NSTimeZone systemTimeZone];
    dateFormater.locale = [NSLocale autoupdatingCurrentLocale];
    dateFormater.dateFormat = format;
    
    return [dateFormater stringFromDate:date];
}

@end
