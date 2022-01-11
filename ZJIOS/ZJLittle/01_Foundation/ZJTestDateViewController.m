//
//  ZJTestDateViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/12/9.
//

#import "ZJTestDateViewController.h"
#import "NSDate+ZJDate.h"

@interface ZJTestDateViewController ()

@end

@implementation ZJTestDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self test5];
}

- (void)test5 {
    NSDate *date1 = [NSDate dateFromString:@"2021-09-09 09:09:09" withStyle:ZJDateFormatMediumStyle];
    NSDate *date2 = [NSDate dateFromString:@"2021-12-11 19:10:09" withFormat:@"yyyy/MM/dd HH:mm:ss"];
    BOOL isSame =  [date1 isEqualToDate:date2];
    NSLog(@"isSame = %@, %@-->%@", @(isSame), @([date1 compare:date2]), [date1 dateToStringWithStyle:ZJDateFormatShortStyle]);
}

- (void)test4 {
    NSDate *date1 = [NSDate dateFromString:@"2021-12-10 19:00:00" withStyle:ZJDateFormatFullStyle];
    NSDate *date2 = [NSDate date];
    NSInteger day = [NSDate daySpanFromDate:date1 toDate:date2];
    NSLog(@"day = %@", @(day));
}

/*
 不改变NSDateFormatter
 2021-12-13 17:50:27.719384+0800 ZJIOS[22932:292158] fmt1 = <NSDateFormatter: 0x6000035d93b0>
 2021-12-13 17:50:27.722130+0800 ZJIOS[22932:292158] fmt2 = <NSDateFormatter: 0x6000035d93b0>
 2021-12-13 17:50:27.722594+0800 ZJIOS[22932:292158] date1 = Fri Dec 10 20:00:00 2021
 2021-12-13 17:50:27.722679+0800 ZJIOS[22932:292158] str = 2021-12-13
 */
- (void)test3 {
    NSDate *date1 = [NSDate dateFromString:@"2021-12-10 20:00:00" withStyle:ZJDateFormatFullStyle];
    NSString *str;// = [[NSDate date] dateToStringWithFormat:@"yyyy-MM-dd"];
    NSLog(@"date1 = %@", date1);
    NSLog(@"str = %@", str);
}

/*
 - (NSDateComponents *)components:(NSCalendarUnit)unitFlags fromDate:(NSDate *)startingDate toDate:(NSDate *)resultDate options:(NSCalendarOptions)opts;可能为负数
 */
- (void)test2 {
    NSDate *date = [NSDate dateFromString:@"2021-12-10 20:00:00" withStyle:ZJDateFormatFullStyle];
    NSLog(@"%@", @([date isYesterday]));
}

- (void)test1 {
    NSDate *date = [NSDate date];
    NSLog(@"%@", @(date.timeIntervalSince1970));
}

// 周:(1, 2, 3, 4, 5, 6, 7)
//    日  一 二  三 四 五  六
/*
 weekdayOrdinal说明
 例如 weekday = 1；//1~7,1表示周日 weekdayOrdinal = 2， weekdayOfMonth = 2;
 weekdayOrdinal 表示 这是这个月的第2个周日，可能是这个月的第二周，可能是第三周
 */
- (void)test0 {
    NSDate *date = [NSDate date];
    NSLog(@"date = %@", date);

    NSDateComponents *cmps = [date detailComponents];
    NSLog(@"%ld", (long)cmps.year);
    NSLog(@"%ld", (long)cmps.month);
    NSLog(@"%ld", (long)cmps.day);
    NSLog(@"hour = %ld", (long)cmps.hour);
    NSLog(@"minute = %ld", (long)cmps.minute);
    NSLog(@"second = %ld", (long)cmps.second);
    NSLog(@"%ld", (long)cmps.weekday);
    NSLog(@"%ld", (long)cmps.weekOfMonth);  // The week number of the months.
    NSLog(@"%ld", (long)cmps.weekOfYear);
    NSLog(@"%ld", (long)cmps.weekdayOrdinal);
    NSLog(@"%ld", (long)cmps.quarter);
    NSLog(@"%ld", (long)cmps.yearForWeekOfYear);
    NSLog(@"%ld", (long)cmps.timeZone);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
 [dateStringFormatter setDateFormat:@"y"]; // 2017
 [dateStringFormatter setDateFormat:@"yy"]; // 17
 [dateStringFormatter setDateFormat:@"yyy"]; // 2017
 [dateStringFormatter setDateFormat:@"yyyy"]; // 2017

 [dateStringFormatter setDateFormat:@"M"]; // 8
 [dateStringFormatter setDateFormat:@"MM"]; // 08
 [dateStringFormatter setDateFormat:@"MMM"]; // 8月
 [dateStringFormatter setDateFormat:@"MMMM"]; // 八月

 [dateStringFormatter setDateFormat:@"d"]; // 3
 [dateStringFormatter setDateFormat:@"dd"]; // 03
 [dateStringFormatter setDateFormat:@"D"]; // 215,一年中的第几天

 [dateStringFormatter setDateFormat:@"h"]; // 4
 [dateStringFormatter setDateFormat:@"hh"]; // 04
 [dateStringFormatter setDateFormat:@"H"]; // 16 24小时制
 [dateStringFormatter setDateFormat:@"HH"]; // 16

 [dateStringFormatter setDateFormat:@"m"]; // 28
 [dateStringFormatter setDateFormat:@"mm"]; // 28
 [dateStringFormatter setDateFormat:@"s"]; // 57
 [dateStringFormatter setDateFormat:@"ss"]; // 04

 [dateStringFormatter setDateFormat:@"E"]; // 周四
 [dateStringFormatter setDateFormat:@"EEEE"]; // 星期四
 [dateStringFormatter setDateFormat:@"EEEEE"]; // 四
 [dateStringFormatter setDateFormat:@"e"]; // 5 (显示的是一周的第几天（weekday），1为周日。)
 [dateStringFormatter setDateFormat:@"ee"]; // 05
 [dateStringFormatter setDateFormat:@"eee"]; // 周四
 [dateStringFormatter setDateFormat:@"eeee"]; // 星期四
 [dateStringFormatter setDateFormat:@"eeeee"]; // 四

 [dateStringFormatter setDateFormat:@"z"]; // GMT+8
 [dateStringFormatter setDateFormat:@"zzzz"]; // 中国标准时间

 [dateStringFormatter setDateFormat:@"ah"]; // 下午5
 [dateStringFormatter setDateFormat:@"aH"]; // 下午17
 [dateStringFormatter setDateFormat:@"am"]; // 下午53
 [dateStringFormatter setDateFormat:@"as"]; // 下午52
 */

@end
