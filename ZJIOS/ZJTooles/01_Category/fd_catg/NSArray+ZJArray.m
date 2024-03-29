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
        NSMutableArray *subAry = [NSMutableArray arrayWithObject:value count:[array[i] count]];
        [ary addObject:subAry];
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

+ (NSArray *)timeStringWithType:(TimeStringType)type {
    NSMutableArray *ary = [NSMutableArray array];
    NSArray *nums = @[@12, @24, @60, @60];
    int count = [nums[type] intValue];
    for (int i = 0; i < count; i++) {
        [ary addObject:[NSString stringWithFormat:@"%02d", i]];
    }
    
    return ary;
}

+ (NSArray *)sexStrings {
    return @[@"男", @"女"];
}

+ (NSArray *)twelveConstellations {
    return @[@"白羊座", @"金牛座", @"双子座", @"巨蟹座", @"狮子座", @"处女座", @"天秤座", @"天蝎座", @"射手座", @"摩羯座", @"水瓶座", @"双鱼座"];
}

- (BOOL)multiSubAryHasBoolTrue {
    NSInteger bool_count = 0;
    for (id obj in self) {
        if ([obj isKindOfClass:[NSArray class]]) {
            BOOL hasTure = [((NSArray *)obj) hasBoolTrue];
            if (hasTure) {
                bool_count++;
            }
        }
    }
    if (bool_count == self.count) {
        return YES;
    }
    
    return NO;
}

- (BOOL)multiAryHasBoolTrue {
    for (id obj in self) {
        if ([obj isKindOfClass:[NSArray class]]) {
            BOOL hasTure = [((NSArray *)obj) hasBoolTrue];
            if (hasTure) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)hasBoolTrue {
    return [self hasBoolTrueFromIndex:0];
}

- (BOOL)hasBoolTrueFromIndex:(NSInteger)index {
    for(NSInteger i = index; i < self.count; i++) {
        if ([self[i] boolValue]) {
            return YES;
        }
    }
    return NO;
}

- (NSInteger)boolTrueCount {
    NSInteger count = 0;
    for(NSInteger i = 0; i < self.count; i++) {
        if ([self[i] boolValue]) {
            count++;
        }
    }
    
    return count;
}

- (NSInteger)checkEmptyIndex {
    for (int i = 0; i < self.count; i++) {
        NSString *value = self[i];
        if ([value isKindOfClass:[NSString class]] && value.length == 0) {
            return i;
        }
    }
    
    return -1;
}

- (BOOL)checkEmpty {
    for (NSString *value in self) {
        if ([value isKindOfClass:[NSString class]] && value.length == 0) {
            return YES;
        }
    }
    
    return NO;
}

@end
