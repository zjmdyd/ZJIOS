//
//  NSArray+ZJArray.m
//  ZJIOS
//
//  Created by Zengjian on 2021/7/2.
//

#import "NSArray+ZJArray.h"
#import "NSMutableArray+ZJMutableArray.h"

@implementation NSArray (ZJArray)

+ (NSArray *)multiArrayWithPrototype:(NSArray *)array {
    return [self multiArrayWithPrototype:array value:@""];
}

+ (NSArray *)multiArrayWithPrototype:(NSArray *)array value:(nonnull id)value {
    NSMutableArray *ary = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        NSMutableArray *sAry = [NSMutableArray arrayWithObject:value count:[array[i] count]];
        [ary addObject:sAry];
    }
    
    return ary;
}

#pragma mark - 拼接字符串

- (NSString *)joinToStringWithSeparateString:(NSString *)str {
    return [self joinToStringWithSeparateString:str range:NSMakeRange(0, self.count)];
}

- (NSString *)joinToStringWithSeparateString:(NSString *)str range:(NSRange)range {
    if (![self isKindOfClass:[NSArray class]]) return @"";
    
    NSMutableString *string = [NSMutableString string];
    NSUInteger endIndex = range.location + range.length;
    for (NSUInteger i = range.location; i < endIndex; i++) {
        if (i < endIndex - 1) {
            [string appendString:[NSString stringWithFormat:@"%@%@", self[i], str]];
        }else {
            [string appendString:[NSString stringWithFormat:@"%@", self[i]]];
        }
    }
    return string;
}

#pragma mark - 处理数据

- (float)maxValue {
    float max = FLT_MIN;
    for (int i = 0; i < self.count; i++) {
        NSNumber *value = self[i];
        if ([value isKindOfClass:[NSNumber class]]) {
            if (max < value.floatValue) {
                max = value.floatValue;
                break;
            }
        }
    }
    
    return max;
}

- (float)minValue {
    float min = FLT_MAX;
    for (int i = 0; i < self.count; i++) {
        NSNumber *value = self[i];
        if ([value isKindOfClass:[NSNumber class]]) {
            if (min > value.floatValue) {
                min = value.floatValue;
                break;
            }
        }
    }
    
    return min;
}

- (float)average {
    float sum = 0.0;
    for (int i = 0; i < self.count; i++) {
        NSNumber *value = self[i];
        if ([value isKindOfClass:[NSNumber class]]) {
            sum += value.floatValue;
        }
    }
    
    return sum/self.count;
}

#pragma mark - 常量字符串

+ (NSArray *)sexStrings {
    return @[@"男", @"女"];
}

+ (NSArray *)timeStringWithType:(TimeStringType)type {
    NSMutableArray *ary = [NSMutableArray array];
    NSArray *nums = @[@12, @24, @60, @60];
    int count = [nums[type] intValue];
    for (int i = 0; i < count; i++) {
        [ary addObject:[NSString stringWithFormat:@"%02d", i]];
    }
    
    return ary;
}

+ (NSArray *)twelveConstellations {
    return @[@"白羊座", @"金牛座", @"双子座", @"巨蟹座", @"狮子座", @"处女座", @"天秤座", @"天蝎座", @"射手座", @"摩羯座", @"水瓶座", @"双鱼座"];
}

@end
