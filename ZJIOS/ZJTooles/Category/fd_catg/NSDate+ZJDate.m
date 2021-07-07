//
//  NSDate+ZJDate.m
//  ZJIOS
//
//  Created by Zengjian on 2021/7/5.
//

#import "NSDate+ZJDate.h"
#import "NSString+ZJString.h"

@implementation NSDate (ZJDate)

- (NSDateComponents *)components {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:self];
    
    return comps;
}

- (BOOL)isEqualToDate:(NSDate *)date {
    NSDateComponents *componentsA = self.components;
    NSDateComponents *componentsB = date.components;
    return componentsA.year == componentsB.year && componentsA.month == componentsB.month && componentsA.day == componentsB.day;
}

- (NSString *)timestampString {
    return @((NSInteger)[self timeIntervalSince1970]).stringValue;
}

+ (NSString *)todayTimestampString {
    return [[NSDate date] timestampString];
}

- (NSTimeInterval)timestampSpanWithOther:(NSDate *)date {
    NSTimeInterval time1 = [self timeIntervalSince1970];
    NSTimeInterval time2 = [date timeIntervalSince1970];
    
    return time1 - time2;
}

#pragma mark - 年龄

- (NSInteger)age {
    // 出生日期转换 年月日
    NSDateComponents *comp1 = [self components];
    NSInteger brithYear  = [comp1 year];
    NSInteger brithMonth = [comp1 month];
    NSInteger brithDay   = [comp1 day];
    
    // 获取系统当前 年月日
    NSDateComponents *comp2 = [[NSDate date] components];
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

+ (NSInteger)ageWithTimeIntervel:(NSInteger)timeInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [date age];
}

//是否在同一周
- (BOOL)isSameWeek {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitYear ;
    
    //1.获得当前时间的 年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    //2.获得self
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return (selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month) && (selfCmps.day == nowCmps.day);
}

//根据日期求星期几
- (NSString *)weekdayStringFromDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:self];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

//是否为今天
- (BOOL)isToday {
    //now: 2015-09-05 11:23:00
    //self 调用这个方法的对象本身
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear ;
    
    //1.获得当前时间的 年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    //2.获得self
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return (selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month) && (selfCmps.day == nowCmps.day);
}

//是否为昨天
- (BOOL)isYesterday {
    //2014-05-01
    NSDate *nowDate = [[NSDate date] dateWithYMD];
    
    //2014-04-30
    NSDate *selfDate = [self dateWithYMD];
    
    //获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.day == 1;
}

- (NSString *)dayString {
    NSString *day = @"--";
    if ([self isToday]) {
        day = @"今天";
    }else if ([self isYesterday]) {
        day = @"昨天";
    }else {
        NSString *str = [NSString hy_stringFromDate:self withFormat:@"yyyy-MM-dd HH:mm:ss"];
        day = [str timeYMDStringDefaultString:@"--"];
    }
    return day;
}

//格式化
- (NSDate *)dateWithYMD {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}

@end
