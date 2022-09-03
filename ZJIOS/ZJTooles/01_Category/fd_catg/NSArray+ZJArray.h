//
//  NSArray+ZJArray.h
//  ZJIOS
//
//  Created by Zengjian on 2021/7/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TimeStringType) {
    TimeStringType12Hour,
    TimeStringType24Hour,
    TimeStringTypeMinute,
    TimeStringTypeSecond,
};

@interface NSArray (ZJArray)

/// 创建多维数组，暂只支持二维数组
/// @param array NSArray *ary = [NSArray multiArrayWithPrototype:@[@[@"", @""], @[@""]] value:@"1"];
+ (NSArray *)multiArrayWithPrototype:(NSArray *)array;
+ (NSArray *)multiArrayWithPrototype:(NSArray *)array value:(nonnull id)value;

- (NSString *)joinToStringWithSeparateString:(NSString *)str;
- (NSString *)joinToStringWithSeparateString:(NSString *)str range:(NSRange)range;

/**
 *  获取数组中的最值,元素须为NSNumber类型
 */
- (float)maxValue;
- (float)minValue;
- (float)average;

+ (NSArray *)timeStringWithType:(TimeStringType)type;

+ (NSArray *)sexStrings;

// 十二星座
+ (NSArray *)twelveConstellations;

- (BOOL)multiSubAryHasBoolTrue;
- (BOOL)multiAryHasBoolTrue;
- (BOOL)hasBoolTrue;
- (BOOL)hasBoolTrueFromIndex:(NSInteger)index;
- (NSInteger)boolTrueCount;

- (BOOL)checkEmpty;
- (NSInteger)checkEmptyIndex;

@end

NS_ASSUME_NONNULL_END
