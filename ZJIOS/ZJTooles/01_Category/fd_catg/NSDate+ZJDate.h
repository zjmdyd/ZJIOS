//
//  NSDate+ZJDate.h
//  ZJIOS
//
//  Created by Zengjian on 2021/7/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (ZJDate)

- (NSDateComponents *)components;

/**
 *  判断两日期是否相等   精确到年月日
 */
- (BOOL)isEqualToDate:(NSDate *)date;

- (NSString *)timestampString;
+ (NSString *)todayTimestampString;
- (NSTimeInterval)timestampSpanWithOther:(NSDate *)date;

#pragma mark - 年龄

/**
 *  日期转化成年龄
 *
 *  @return 周岁
 */
- (NSInteger)age;

/**
 *  时间戳转化成年龄
 *
 *  @return 周岁
 */
+ (NSInteger)ageWithTimeIntervel:(NSInteger)timeInterval;

// 两个日期间的间隔天数
- (NSInteger)daySpanWithDate:(NSDate *)date;
+ (NSInteger)daySpanFromDate:(NSDate *)firstDate toDate:(NSDate *)secondDate;

- (BOOL)isSameWeek;
- (BOOL)isToday;
- (BOOL)isYesterday;
- (NSString *)dayString;



@end

NS_ASSUME_NONNULL_END
