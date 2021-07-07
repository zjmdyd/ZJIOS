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

- (NSInteger)validValueWithRange:(NSRange)range defaultValue:(NSInteger)value {
    if ([self isKindOfClass:[NSNumber class]]) {
        NSInteger aValue = self.integerValue;
        if (aValue < range.location || aValue > range.length) {
            return value;
        }else {
            return aValue;
        }
    }
    
    return value;
}

@end
