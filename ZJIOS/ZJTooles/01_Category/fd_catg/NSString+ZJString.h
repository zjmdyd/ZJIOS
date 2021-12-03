//
//  NSString+ZJString.h
//  ZJIOS
//
//  Created by Zengjian on 2021/7/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZJString)

- (BOOL)isEmptyString;

- (NSString *)pathWithParam:(id)param;

// 字符串转json
- (NSDictionary *)stringToJson;
- (NSString *)checkSysConflictKey;

- (BOOL)isOnlineResource;
- (NSString *)validHttpsPath;

- (NSString *)separateWithCharacter:(NSString *)cha;

// 去除换行符
- (NSString *)removeLineSeparate;

/**
 去除字符串HTML标签
 */
- (NSString *)filterHTML;

/**
 *  字符串翻转
 */
- (NSString *)invertString;
- (NSString *)invertStringWithSegmentLenth:(int)len;

/**
 汉字转拼音
 */
- (NSString *)pinYin;
- (NSString *)firstCharactor;

- (BOOL)isPureInt;
- (BOOL)isPureFloat;

@end

NS_ASSUME_NONNULL_END
