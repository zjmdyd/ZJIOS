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
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth fromDate:self];
    
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

#pragma mark - 年龄

- (NSInteger)age {
    // 出生日期转换 年月日
    NSDateComponents *comp1 = [self basicComponents];
    NSInteger brithYear  = [comp1 year];
    NSInteger brithMonth = [comp1 month];
    NSInteger brithDay   = [comp1 day];
    
    // 获取系统当前 年月日
    NSDateComponents *comp2 = [[NSDate date] basicComponents];
    NSInteger currentYear  = [comp2 year];
    NSInteger currentMonth = [comp2 month];
    NSInteger currentDay   = [comp2 day];
    
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

// 判断两个日期是否在同一周
- (BOOL)isSameWeekWithDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unit = NSCalendarUnitYear | NSCalendarUnitWeekOfYear;
    
    // 1.获得指定日期时间的components
    NSDateComponents *cmp1 = [calendar components:unit fromDate:date];
    
    // 2.获得self的components
    NSDateComponents *cmp2 = [calendar components:unit fromDate:self];
    
    return (cmp1.year == cmp2.year) && (cmp1.weekOfYear == cmp2.weekOfYear);
}

// 是否为今天
- (BOOL)isToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    //1.获得当前时间的 年月日
    NSDateComponents *cmp1 = [calendar components:unit fromDate:[NSDate date]];
    
    //2.获得self
    NSDateComponents *cmp2 = [calendar components:unit fromDate:self];
    
    return (cmp1.year == cmp2.year) && (cmp1.month == cmp2.month) && (cmp1.day == cmp2.day);
}

//是否为昨天
- (BOOL)isYesterday {
    //获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:self toDate:[NSDate date] options:0];
    return cmps.day == 1;
}

// 字符串转Date
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *fmt = [self baseFormatterWithString:format];
    NSLog(@"fmt = %@", fmt);
    return [fmt dateFromString:string];
}

// Date转字符串
- (NSString *)dateToStringWithFormat:(NSString *)format {
    NSDateFormatter *fmt = [NSDate baseFormatterWithString:format];
    NSLog(@"fmt = %@", fmt);

    return [fmt stringFromDate:self];
}

// 时间戳-->Date-->转字符串
+ (NSString *)timeIntervalToDateString:(NSTimeInterval)timeInterval withFormat:(NSString *)format {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    return [date dateToStringWithFormat:format];
}

+ (NSDateFormatter *)baseFormatterWithString:(NSString *)format {
    static NSDateFormatter *fmt = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fmt = [[NSDateFormatter alloc] init];
    });
    fmt.locale = [NSLocale autoupdatingCurrentLocale];
    fmt.dateFormat = format;

    return fmt;
}

//根据日期求星期几
- (NSString *)weekdayStringFromDate {
    NSArray *weekdays = [NSArray arrayWithObjects:[NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:self];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}

- (NSInteger)daySpanWithDate:(NSDate *)date {
    return [NSDate daySpanFromDate:self toDate:date];
}

+ (NSInteger)daySpanFromDate:(NSDate *)firstDate toDate:(NSDate *)secondDate {
    NSCalendar *chineseClendar  = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmps = [chineseClendar components:unitFlags fromDate:firstDate toDate:secondDate  options:0];
    NSInteger diffDay = [cmps day];
    return diffDay;
}

- (BOOL)isEqualToDate:(NSDate *)date {
    NSDateComponents *componentsA = self.basicComponents;
    NSDateComponents *componentsB = date.basicComponents;
    return componentsA.year == componentsB.year && componentsA.month == componentsB.month && componentsA.day == componentsB.day;
}

//+ (NSString *)hy_stringFromDate:(NSDate *)date withFormat:(NSString *)format {
//    static NSDateFormatter *dateFormater = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        dateFormater = [[NSDateFormatter alloc] init];
//    });
//    dateFormater.timeZone = [NSTimeZone systemTimeZone];
//    dateFormater.locale = [NSLocale autoupdatingCurrentLocale];
//    dateFormater.dateFormat = format;
//
//    return [dateFormater stringFromDate:date];
//}


//- (NSString *)timestampString {
//    return @([self timeIntervalSince1970]).stringValue;
//}
//
//+ (NSString *)todayTimestampString {
//    return [[NSDate date] timestampString];
//}


- (NSString *)dayString {
    NSString *day = @"--";
    if ([self isToday]) {
        day = @"今天";
    }else if ([self isYesterday]) {
        day = @"昨天";
    }else {
        //        NSString *str = [NSString hy_stringFromDate:self withFormat:@"yyyy-MM-dd HH:mm:ss"];
        //        day = [str timeYMDStringDefaultString:@"--"];
    }
    return day;
}

@end
