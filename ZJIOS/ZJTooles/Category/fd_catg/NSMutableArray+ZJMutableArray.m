//
//  NSMutableArray+ZJMutableArray.m
//  ZJIOS
//
//  Created by Zengjian on 2021/7/2.
//

#import "NSMutableArray+ZJMutableArray.h"

@implementation NSMutableArray (ZJMutableArray)

+ (NSMutableArray *)arrayWithObject:(id)obj count:(NSInteger)count {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        [array addObject:obj?:@""];
    }
    
    return array;
}


- (void)resetBoolValues {
    for(int i = 0; i < self.count; i++) {
        if ([self[i] boolValue]) {
            self[i] = @(NO);
        }
    }
}

- (void)changeBoolValueAtIndex:(NSInteger)index {
    [self changeBoolValueAtIndex:index needReset:NO];
}

- (void)changeBoolValueAtIndex:(NSInteger)index needReset:(BOOL)need {
    BOOL select = [self[index] boolValue];
    self[index] = @(!select);
    if (need) {
        for(int i = 0; i < self.count; i++) {
            if (i != index && [self[i] boolValue]) {
                self[i] = @(NO);
            }
        }
    }
}

@end
