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

    [self test6];
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

- (void)test1 {
    NSDate *date1 = [NSDate dateFromString:@"2022-05-14 09:00:00" withStyle:ZJDateFormatStyleFull];
    NSLog(@"isYesterday = %d", [date1 isYesterday]);
    
    NSDate *date2 = [NSDate dateFromString:@"2022-05-16 09:00:00" withStyle:ZJDateFormatStyleFull];
    NSLog(@"isTomorrow = %d", [date2 isTomorrow]);
}

/*
 - (NSDateComponents *)components:(NSCalendarUnit)unitFlags fromDate:(NSDate *)startingDate toDate:(NSDate *)resultDate options:(NSCalendarOptions)opts;可能为负数
 */
- (void)test2 {
    NSDate *date = [NSDate dateFromString:@"2021-12-10 20:00:00" withStyle:ZJDateFormatStyleFull];
    NSLog(@"%@", @([date isYesterday]));
}

/*
 两个方法中的ZJDateFormatter为同一个
 2021-12-13 17:50:27.719384+0800 ZJIOS[22932:292158] fmt1 = <NSDateFormatter: 0x6000035d93b0>
 2021-12-13 17:50:27.722130+0800 ZJIOS[22932:292158] fmt2 = <NSDateFormatter: 0x6000035d93b0>
 2021-12-13 17:50:27.722594+0800 ZJIOS[22932:292158] date1 = Fri Dec 10 20:00:00 2021
 2021-12-13 17:50:27.722679+0800 ZJIOS[22932:292158] str = 2021-12-13
 */
- (void)test3 {
    NSDate *date1 = [NSDate dateFromString:@"2021-12-10 20:00:00" withStyle:ZJDateFormatStyleFull];
    NSString *str = [[NSDate date] dateToStringWithFormat:@"yyyy-MM-dd"];
    NSLog(@"date1 = %@", date1);
    NSLog(@"str = %@", str);
}

/*
 2022-05-15 00:14:04.509782+0800 ZJIOS[9286:314978] data1 = 2022-05-09 00:07:00
 2022-05-15 00:14:04.510009+0800 ZJIOS[9286:314978] date2 = 2022-05-15 00:14:04
 2022-05-15 00:14:04.510107+0800 ZJIOS[9286:314978] daySpan = 6
 */
- (void)test4 {
    NSDate *date1 = [NSDate dateFromString:@"2022-05-09 00:07:00" withStyle:ZJDateFormatStyleFull];
    NSDate *date2 = [NSDate date];
    NSInteger daySpan = [NSDate daySpanFromDate:date1 toDate:date2];
    NSLog(@"data1 = %@", [date1 dateToStringWithStyle:ZJDateFormatStyleFull]);
    NSLog(@"date2 = %@", [date2 dateToStringWithStyle:ZJDateFormatStyleFull]);
    NSLog(@"daySpan = %@", @(daySpan));
}

// 2022-05-14 23:54:17.798745+0800 ZJIOS[8645:291401] isSame = 0, (date1 compare:date2):-1, ZJDateFormatStyleShort:2021-9-9 9:9:9
- (void)test5 {
    NSDate *date1 = [NSDate dateFromString:@"2021-09-09 09:09:09" withStyle:ZJDateFormatStyleMedium];
    NSDate *date2 = [NSDate dateFromString:@"2021-12-11 19:10:09" withFormat:@"yyyy/MM/dd HH:mm:ss"];
    BOOL isSame =  [date1 isEqualToDate:date2];
    NSLog(@"isSame = %@, (date1 compare:date2):%@, ZJDateFormatStyleShort:%@", @(isSame), @([date1 compare:date2]), [date1 dateToStringWithStyle:ZJDateFormatStyleShort]);
}
/*
 2022-05-15 11:24:29.210176+0800 ZJIOS[5107:141091] str1 = 2022-05-14 13:00:09
 2022-05-15 11:24:29.210381+0800 ZJIOS[5107:141091] str2 = 2022-5-14 13:00:09
 2022-05-15 11:24:29.210517+0800 ZJIOS[5107:141091] str3 = 2022-5-14 13:0:9
 2022-05-15 11:24:29.210624+0800 ZJIOS[5107:141091] str4 = 2022-05-14 01:00:09
 2022-05-15 11:24:29.210745+0800 ZJIOS[5107:141091] str5 = 2022-5-14 01:00:09
 2022-05-15 11:24:29.210862+0800 ZJIOS[5107:141091] str6 = 2022-5-14 1:0:9
 */
- (void)test6 {
    NSDate *date = [NSDate dateFromString:@"2022-05-14 13:00:09" withStyle:ZJDateFormatStyleFull];
    NSString *str1 = [date dateToStringWithStyle:ZJDateFormatStyleFull];
    NSString *str2 = [date dateToStringWithStyle:ZJDateFormatStyleMedium];
    NSString *str3 = [date dateToStringWithStyle:ZJDateFormatStyleShort];
    NSString *str4 = [date dateToStringWithStyle:ZJDateFormatStyleFull_12Hours];
    NSString *str5 = [date dateToStringWithStyle:ZJDateFormatStyleMedium_12Hours];
    NSString *str6 = [date dateToStringWithStyle:ZJDateFormatStyleShort_12Hours];
    NSLog(@"str1 = %@", str1);
    NSLog(@"str2 = %@", str2);
    NSLog(@"str3 = %@", str3);
    NSLog(@"str4 = %@", str4);
    NSLog(@"str5 = %@", str5);
    NSLog(@"str6 = %@", str6);
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
