//
//  NSDate+ZJDate.m
//  ZJIOS
//
//  Created by Zengjian on 2021/7/5.
//

#import "NSDate+ZJDate.h"
#import "NSString+ZJString.h"

@implementation NSDate (ZJDate)

- (NSDateComponents *)basicComponents {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    
    return comps;
}

- (NSDateComponents *)detailComponents {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitQuarter | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitYearForWeekOfYear | NSCalendarUnitTimeZone fromDate:self];
    
    return comps;
}

- (NSTimeInterval)timestampSpanWithOther:(NSDate *)date {
    NSTimeInterval time1 = [self timeIntervalSince1970];
    NSTimeInterval time2 = [date timeIntervalSince1970];
    
    return time1 - time2;
}

// 字符串转Date
+ (NSDate *)dateFromString:(NSString *)string withStyle:(ZJDateFormatStyle)style {
    ZJDateFormatter *fmt = [self baseFormatterWithStyle:style];

    return [fmt dateFromString:string];
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    ZJDateFormatter *fmt = [self baseFormatterWithString:format];

    return [fmt dateFromString:string];
}

// Date转字符串
- (NSString *)dateToStringWithStyle:(ZJDateFormatStyle)style {
    ZJDateFormatter *fmt = [NSDate baseFormatterWithStyle:style];

    return [fmt stringFromDate:self];
}

- (NSString *)dateToStringWithFormat:(NSString *)format {
    ZJDateFormatter *fmt = [NSDate baseFormatterWithString:format];

    return [fmt stringFromDate:self];
}

// 时间戳-->Date-->转字符串
+ (NSString *)timeIntervalToDateString:(NSTimeInterval)timeInterval withStyle:(ZJDateFormatStyle)style {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    return [date dateToStringWithStyle:style];
}

+ (NSString *)timeIntervalToDateString:(NSTimeInterval)timeInterval withFormat:(NSString *)format {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    return [date dateToStringWithFormat:format];
}

+ (ZJDateFormatter *)baseFormatterWithStyle:(ZJDateFormatStyle)style {
    ZJDateFormatter *fmt = [NSDate baseFormatter];
    fmt.dateFormat = [fmt dateFormatStringWithStyle:style];

    return fmt;
}

+ (ZJDateFormatter *)baseFormatterWithString:(NSString *)format {
    ZJDateFormatter *fmt = [NSDate baseFormatter];
    fmt.dateFormat = format;

    return fmt;
}

+ (ZJDateFormatter *)baseFormatter {
    static ZJDateFormatter *fmt = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fmt = [[ZJDateFormatter alloc] init];
    });
    fmt.locale = [NSLocale autoupdatingCurrentLocale];
    
    return fmt;
}

#pragma mark - 年龄

- (NSInteger)age {
    // 出生日期转换 年月日
    NSDateComponents *comps1 = [self basicComponents];
    NSInteger brithYear  = [comps1 year];
    NSInteger brithMonth = [comps1 month];
    NSInteger brithDay   = [comps1 day];
    
    // 获取系统当前 年月日
    NSDateComponents *comps2 = [[NSDate date] basicComponents];
    NSInteger currentYear  = [comps2 year];
    NSInteger currentMonth = [comps2 month];
    NSInteger currentDay   = [comps2 day];
    
    // 计算年龄
    NSInteger iAge = currentYear - brithYear - 1;
    if ((currentMonth > brithMonth) || (currentMonth == brithMonth && currentDay >= brithDay)) {
        iAge++;
    }
    
    return iAge;
}

+ (NSInteger)ageWithTimeIntervel:(NSTimeInterval)timeInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [date age];
}

// 是否为今天
- (BOOL)isToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    //1.获得当前时间的 年月日
    NSDateComponents *comps1 = [calendar components:unit fromDate:[NSDate date]];
    
    //2.获得self
    NSDateComponents *comps2 = [calendar components:unit fromDate:self];
    
    return (comps1.year == comps2.year) && (comps1.month == comps2.month) && (comps1.day == comps2.day);
}

// 是否为昨天
- (BOOL)isYesterday {
    NSInteger diff = [self dayDiffWithDate:[NSDate date]];
    
    return diff == -1;
}

- (NSInteger)dayDiffWithDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unit = NSCalendarUnitDay;

    NSDateComponents *comps1 = [calendar components:unit fromDate:self];
    NSDateComponents *comps2 = [calendar components:unit fromDate:date];
    
    NSLog(@"cmp1 = %zd", comps1.day);
    NSLog(@"cmp2 = %zd", comps2.day);
    
    return comps1.day - comps2.day;
}

// 是否为昨天
- (BOOL)isTomorrow {
    NSInteger diff = [self dayDiffWithDate:[NSDate date]];
    
    return diff == 1;
}

// 判断两个日期是否在同一周
- (BOOL)isSameWeekWithDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unit = NSCalendarUnitYear | NSCalendarUnitWeekOfYear;
    
    // 1.获得指定日期时间的components
    NSDateComponents *comps1 = [calendar components:unit fromDate:date];
    
    // 2.获得self的components
    NSDateComponents *comps2 = [calendar components:unit fromDate:self];
    
    return (comps1.year == comps2.year) && (comps1.weekOfYear == comps2.weekOfYear);
}

// 根据日期求星期几
- (NSString *)weekdayStringFromDate {
    NSArray *weekdays = [NSArray arrayWithObjects:[NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone:timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:self];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}

- (NSInteger)daySpanWithDate:(NSDate *)date {
    return [NSDate daySpanFromDate:self toDate:date];
}

/*
 NSUInteger unitFlags = NSCalendarUnitDay;
 NSUInteger unitFlags = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
 两者效果一样
 */
+ (NSInteger)daySpanFromDate:(NSDate *)firstDate toDate:(NSDate *)secondDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitDay;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:firstDate toDate:secondDate options:NSCalendarWrapComponents];
    NSInteger diffDay = [comps day];
    
    return diffDay;
}

@end
