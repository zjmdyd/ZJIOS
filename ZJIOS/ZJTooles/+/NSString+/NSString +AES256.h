//
//  NSString +AES256.h
//  KidReading
//
//  Created by telen on 15/3/16.
//  Copyright (c) 2015年 Creative Knowledge Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

#import "NSData+EncryptionAES.h"

@interface NSString(AES256)

-(NSString *) aes256_encrypt:(NSString *)key;
-(NSString *) aes256_decrypt:(NSString *)key;

//
+ (NSString *)stringWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;
- (NSString *)base64DecodedString;
- (NSData *)base64DecodedData;

+ (NSString *)md5:(NSString *)input;

//字节长度
- (NSUInteger)length_c;
- (NSString*)preLength_c:(NSUInteger)length_c;

//For Pep
- (NSString *)pepBase64EncodedString;


@end
