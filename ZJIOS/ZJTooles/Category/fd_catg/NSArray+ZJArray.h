//
//  NSArray+ZJArray.h
//  ZJIOS
//
//  Created by Zengjian on 2021/7/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (ZJArray)

// 创建多维数组，暂只支持二维数组
+ (NSArray *)multiArrayWithPrototype:(NSArray *)array;
+ (NSArray *)multiArrayWithPrototype:(NSArray *)array value:(nonnull id)value;

- (NSString *)joinToStringWithSeparateString:(NSString *)str;
- (NSString *)joinToStringWithSeparateString:(NSString *)str endIndex:(NSInteger)endIndex;

/**
 *  获取数组中的最值,元素须为NSNumber类型
 */
- (NSNumber *)maxValue;
- (NSNumber *)minValue;
- (NSNumber *)average;

+ (NSArray *)sexStrings;
// 00~23
+ (NSArray *)hourStrings;
// 00~59
+ (NSArray *)minuteStrings;
// 十二星座
+ (NSArray *)twelveConstellations;

@end

NS_ASSUME_NONNULL_END
