//
//  NSDictionary+Log.m
//  descrption
//
//  Created by telen on 15/11/26.
//  Copyright © 2015年 Creative Knowledge Ltd. All rights reserved.
//

#import "NSDictionary+Log.h"

@implementation NSDictionary (Log)

- (NSString *)descriptionDefine
{
    // 遍历数组中的所有内容，将内容拼接成一个新的字符串返回
    NSMutableString *strM = [NSMutableString string];
    [strM appendString:@"{\n"];
    // 遍历数组,self就是当前的数组
    for (id obj in self) {
        // 在拼接字符串时，会调用obj的description方法
        [strM appendFormat:@"\t%@:%@;\n", obj,self[obj]];
    }
    [strM appendString:@"}"];
    return strM;
}

- (NSString *)descriptionWithLocale:(id)locale
{
    NSString* desc = [self description];
    desc = [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    return desc;
}

- (id)valueForKeyWithOutNSNull:(NSString *)key
{
    id value = [self valueForKey:key];
    return [value class] != [NSNull class] ? value :nil;
}

- (id)valueForKeyWithReturnEmptyString:(NSString *)key
{
    NSString *stringValue = [self valueForKeyWithOutNSNull:key];
    if(stringValue)
    {
        return stringValue;
    }
    return @"";
}

- (int)intValueWithDefaultVaule:(NSString*)key
{
    NSString *stringValue = [self valueForKeyWithOutNSNull:key];
    if(stringValue)
    {
        return [stringValue intValue];
    }
    return -1;
}

@end
