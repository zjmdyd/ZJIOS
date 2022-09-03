//
//  NSDate+ZJDate.h
//  ZJIOS
//
//  Created by Zengjian on 2021/7/5.
//

#import <Foundation/Foundation.h>
#import "ZJDateFormatter.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (ZJDate)

- (NSDateComponents *)basicComponents;
- (NSDateComponents *)detailComponents;

- (NSTimeInterval)timestampSpanWithOther:(NSDate *)date;

// 字符串转Date
+ (NSDate *)dateFromString:(NSString *)string withStyle:(ZJDateFormatStyle)style;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;

// Date转字符串
- (NSString *)dateToStringWithStyle:(ZJDateFormatStyle)style;
- (NSString *)dateToStringWithFormat:(NSString *)format;

// 时间戳转字符串
+ (NSString *)timeIntervalToDateString:(NSTimeInterval)timeInterval withStyle:(ZJDateFormatStyle)Style;
+ (NSString *)timeIntervalToDateString:(NSTimeInterval)timeInterval withFormat:(NSString *)format;

#pragma mark - 年龄

/**
 *  日期转化成年龄
 *
 *  @return 周岁
 */
- (NSInteger)age;
+ (NSInteger)ageWithTimeIntervel:(NSTimeInterval)timeInterval;

- (BOOL)isToday;
- (BOOL)isYesterday;
- (BOOL)isTomorrow;

// 判断两个日期是否在同一周
- (BOOL)isSameWeekWithDate:(NSDate *)date;

// 两个日期间的间隔天数
- (NSInteger)daySpanWithDate:(NSDate *)date;
+ (NSInteger)daySpanFromDate:(NSDate *)firstDate toDate:(NSDate *)secondDate;

@end

NS_ASSUME_NONNULL_END
