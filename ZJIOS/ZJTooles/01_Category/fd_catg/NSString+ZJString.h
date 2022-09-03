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
- (BOOL)isValidString;

- (NSString *)pathWithParam:(id)param;

// 字符串转json
- (NSDictionary *)stringToJson;
- (NSString *)checkSysConflictKey;

- (BOOL)isOnlineResource;
- (NSString *)validHttpsPath;

- (NSString *)separateWithCharacter:(NSString *)cha;
- (NSString *)pureNumberString;
- (NSString *)pureNumberStringContainedPoint:(BOOL)hasPoint;

/**
 *  字符串翻转
 */
- (NSString *)invertString;
- (NSString *)invertStringWithSegmentLenth:(int)len;

#pragma mark - AttributedString

- (NSAttributedString *)underlineAttributedString;
- (NSAttributedString *)attStringWithAttributed:(NSDictionary *)attributed;

@end

NS_ASSUME_NONNULL_END
