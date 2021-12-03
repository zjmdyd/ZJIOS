//
//  NSString+ZJTextEncode.h
//  ZJIOS
//
//  Created by issuser on 2021/11/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZJTextEncode)

#pragma mark - MD5

typedef NS_ENUM(NSInteger, MD5Type) {
    MD5Type32BitLowercase = 0,
    MD5Type32BitUppercase = 1,
    MD5Type16BitLowercase = 2,
    MD5Type16BitUppercase = 3,
};

- (NSString *)md5;
- (NSString *)md5WithType:(MD5Type)type;

#pragma 字符串编码

/**
 URL编码
 */
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

@end

NS_ASSUME_NONNULL_END
