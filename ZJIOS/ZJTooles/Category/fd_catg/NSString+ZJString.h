//
//  NSString+ZJString.h
//  ZJIOS
//
//  Created by Zengjian on 2021/7/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZJString)

- (BOOL)isNoEmptyString;
- (NSString *)descriptionStr;
- (NSString *)descriptionStrWithDefault:(NSString *)defaultStr;

- (NSString *)pathWithParam:(id)param;
- (NSDictionary *)stringToJson;
- (NSString *)separateWithCharacter:(NSString *)cha;
- (BOOL)isOnlineResource;
- (NSString *)validHttpsPath;

/**
 去除字符串HTML标签
 */
- (NSString *)filterHTML;
- (NSString *)checkSysConflictKey;

/**
 *  字符串翻转
 */
- (NSString *)invertString;
- (NSString *)invertByteString;

/**
 汉字转拼音
 */
- (NSString *)pinYin;
- (NSString *)firstCharactor;
- (BOOL)judgeLetter;

/**
 获取完整时间的年月日

 @return 2011-11-11
 */
- (NSString *)timeYMDString;

/**
 获取完整时间的时分秒

 @return 06:06:06
 */
- (NSString *)timeHMSString;

- (NSString *)timeYMDStringDefaultString:(NSString *)str;
- (NSString *)timeHMSStringDefaultString:(NSString *)str;

- (NSString *)pureTextString;
- (NSString *)removeLineSeparate;

#pragma mark - MD5

typedef NS_ENUM(NSInteger, MD5Type) {
    MD5Type32BitLowercase = 0,
    MD5Type32BitUppercase = 1,
    MD5Type16BitLowercase = 2,
    MD5Type16BitUppercase = 3,
};

- (NSString *)hy_md5;
- (NSString *)hy_md5WithType:(MD5Type)type;

#pragma 字符串编码

/**
 URL编码
 */
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

- (BOOL)isPureInt;
- (BOOL)isPureFloat;

/**
 首尾填充字符串:默认首部填充

 @param character 填充的字符串
 @param len 填充后的总长度
 @return 填充后的字符串
 */
- (NSString *)fillStringWithCharacter:(NSString *)character len:(NSInteger)len;
- (NSString *)fillStringWithCharacter:(NSString *)character len:(NSInteger)len atBegan:(BOOL)began;

#pragma mark - json

- (NSString *)jsonFilePath;

#pragma mark - 正则

- (BOOL)hasNumber;
- (BOOL)isValidPhone;
- (BOOL)isValidID;

+ (NSString *)hy_stringFromDate:(NSDate *)date withFormat:(NSString *)format;

@end

NS_ASSUME_NONNULL_END
