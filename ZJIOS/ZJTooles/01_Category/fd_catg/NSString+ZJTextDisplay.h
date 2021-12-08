//
//  NSString+ZJTextDisplay.h
//  ZJIOS
//
//  Created by issuser on 2021/11/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZJTextDisplay)

- (NSString *)descriptionStr;
- (NSString *)descriptionStrWithDefault:(NSString *)defaultStr;

/**
 首尾填充字符串:默认首部填充

 @param character 填充的字符串
 @param len 填充后的总长度
 @return 填充后的字符串
 */
- (NSString *)fillStringWithCharacter:(NSString *)character len:(NSInteger)len;
- (NSString *)fillStringWithCharacter:(NSString *)character len:(NSInteger)len atBegan:(BOOL)began;

// 去除换行符
- (NSString *)removeLineSeparate;

/**
 去除字符串HTML标签
 */
- (NSString *)filterHTML;

/**
 汉字转拼音
 */
- (NSString *)pinYin;
- (NSString *)firstCharactor;

@end

NS_ASSUME_NONNULL_END
