//
//  NSString +AES256.m
//  KidReading
//
//  Created by telen on 15/3/16.
//  Copyright (c) 2015年 Creative Knowledge Ltd. All rights reserved.
//

#import "NSString +AES256.h"

@implementation NSString(AES256)

-(NSString *) aes256_encrypt:(NSString *)key
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    //对数据进行加密
    NSData *result = [data AES256EncryptWithKey:key];
    
    //转换为2进制字符串
    if (result && result.length > 0) {
        
        Byte *datas = (Byte*)[result bytes];
        NSMutableString *output = [NSMutableString stringWithCapacity:result.length * 2];
        for(int i = 0; i < result.length; i++){
            [output appendFormat:@"%02x", datas[i]];
        }
        return output;
    }
    return nil;
}

-(NSString *) aes256_decrypt:(NSString *)key
{
    //转换为2进制Data
    NSMutableData *data = [NSMutableData dataWithCapacity:self.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [self length] / 2; i++) {
        byte_chars[0] = [self characterAtIndex:i*2];
        byte_chars[1] = [self characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    
    //对数据进行解密
    NSData* result = [data AES256DecryptWithKey:key];
    if (result && result.length > 0) {
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    return nil;
}


+ (NSString *)stringWithBase64EncodedString:(NSString *)string
{
    NSData *data = [NSData dataWithBase64EncodedString:string];
    if (data)
    {
        NSString *result = [[self alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
#if !__has_feature(objc_arc)
        [result autorelease];
#endif
        
        return result;
    }
    return nil;
}

- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data base64EncodedStringWithWrapWidth:wrapWidth];
}

- (NSString *)base64EncodedString
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data speBase64EncodedString];
}

- (NSString *)base64DecodedString
{
    return [NSString stringWithBase64EncodedString:self];
}

- (NSData *)base64DecodedData
{
    return [NSData dataWithBase64EncodedString:self];
}

+ (NSString *)md5:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char result[32];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSUInteger)length_c
{
    NSUInteger l = 0;
    for (NSUInteger i=0; i<self.length; i++) {
        if ([self characterAtIndex:i] < 128) {
            l++;
        }else{
            l++;l++;
        }
    }
    return l;
}

- (NSString*)preLength_c:(NSUInteger)length_c
{
    NSUInteger l = 0;
    NSUInteger index = 0;
    for (NSUInteger i=0; i<self.length; i++) {
        if ([self characterAtIndex:i] < 128) {
            l++;
        }else{
            l++;l++;
        }
        if (l<=length_c) {
            index++;
        }else{
            break;
        }
    }
    return [self substringToIndex:index];
}

- (NSString *)pepBase64EncodedString
{
    NSString * base64Str = self;
    NSUInteger length = base64Str.length;
    if (length < 4)
    {
        for (int i = 0; i < 4 - length; i++)
            base64Str = [base64Str stringByAppendingString:@"x"];
    }
    base64Str = [base64Str base64EncodedString];
    base64Str = [base64Str stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    base64Str = [base64Str stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    for(int i=0;i<base64Str.length;i++){
        NSInteger _lastIndex= [base64Str rangeOfString:@"=" options:NSBackwardsSearch].location;
        if(_lastIndex>=0 && _lastIndex <= base64Str.length){
            base64Str = [base64Str substringWithRange:NSMakeRange(0,_lastIndex-1)];
        }
        else{
            break;
        }
    }
    base64Str = [NSString stringWithFormat:@"%@%@",
                 [base64Str substringFromIndex:4], [base64Str substringWithRange:NSMakeRange(0, 4)]];
    base64Str = [base64Str base64EncodedString];
    base64Str = [base64Str stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    base64Str = [base64Str stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    for(int i=0;i<base64Str.length;i++){
        NSInteger _lastIndex= [base64Str rangeOfString:@"=" options:NSBackwardsSearch].location;
        if(_lastIndex>=0 && _lastIndex <= base64Str.length){
            base64Str = [base64Str substringWithRange:NSMakeRange(0,_lastIndex)];
        }
        else{
            break;
        }
    }
    return base64Str;
}

@end
