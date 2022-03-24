//
//  NSNumber+ZJNumber.m
//  ZJIOS
//
//  Created by Zengjian on 2021/7/2.
//

#import "NSNumber+ZJNumber.h"

@implementation NSNumber (ZJNumber)

- (NSInteger)validValueWithRange:(NSRange)range {
    return [self validValueWithRange:range defaultValue:0];
}

- (NSInteger)validValueWithRange:(NSRange)range defaultValue:(NSInteger)defaultValue {
    if ([self isKindOfClass:[NSNumber class]]) {
        NSInteger value = self.integerValue;
        if (NSLocationInRange(value, range)) {
            return value;
        }else {
            return defaultValue;
        }
    }
    
    return defaultValue;
}

@end
