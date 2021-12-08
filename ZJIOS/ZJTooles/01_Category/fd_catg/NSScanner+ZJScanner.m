//
//  NSScanner+ZJScanner.m
//  ZJIOS
//
//  Created by issuser on 2021/12/7.
//

#import "NSScanner+ZJScanner.h"

@implementation NSScanner (ZJScanner)

// 1. 整形判断
+ (BOOL)isPureInt:(NSString *)string {
    NSScanner *scan = [NSScanner scannerWithString:string];
    NSInteger val;
    return [scan scanInteger:&val] && [scan isAtEnd];
}

// 2.浮点形判断：
+ (BOOL)isPureFloat:(NSString *)string {
    NSScanner *scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

@end
