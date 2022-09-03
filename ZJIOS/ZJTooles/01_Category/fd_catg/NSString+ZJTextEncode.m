//
//  NSString+ZJTextEncode.m
//  ZJIOS
//
//  Created by issuser on 2021/11/24.
//

#import "NSString+ZJTextEncode.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (ZJTextEncode)

#pragma MD5加密

- (NSString *)md5 {
    return [self md5WithType:MD5Type32BitLowercase];
}

- (NSString *)md5WithType:(MD5Type)type {
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

#pragma mark - sha1

- (NSString*)sha1:(NSString *)str {
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (uint32_t)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

#pragma mark - 字符串编码

- (NSString *)URLEncodedString {
    if (!self) return nil;
    
    NSString *encodedString = [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return encodedString;
}

/**
 *  URLDecode
 */
- (NSString *)URLDecodedString {
    if (!self) return nil;
    
    NSString *decodedString = [self stringByRemovingPercentEncoding];

    return decodedString;
}

- (NSString *)encodeFileName {
    if (!self) return nil;
    NSString *fileName = [self md5WithType:MD5Type32BitUppercase];
    return [NSString stringWithFormat:@"%@", fileName];
}

@end
