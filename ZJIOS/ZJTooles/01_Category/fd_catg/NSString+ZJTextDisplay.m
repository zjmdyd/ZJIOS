//
//  NSString+ZJTextDisplay.m
//  ZJIOS
//
//  Created by issuser on 2021/11/24.
//

#import "NSString+ZJTextDisplay.h"
#import "NSString+ZJString.h"

@implementation NSString (ZJTextDisplay)

- (NSString *)descriptionStr {
    return [self descriptionStrWithDefault:@"--"];
}

- (NSString *)descriptionStrWithDefault:(NSString *)defaultStr {
    if ([self isEmptyString]) {
        return defaultStr;
    }
    
    return self;
}

#pragma mark - 填充字符串

- (NSString *)fillStringWithCharacter:(NSString *)character len:(NSInteger)len {
    return [self fillStringWithCharacter:character len:len atBegan:YES];
}

- (NSString *)fillStringWithCharacter:(NSString *)character len:(NSInteger)len atBegan:(BOOL)began {
    if (self.length < len) {
        NSMutableString *str = [self mutableCopy];
        NSInteger count = len - self.length;
        for (int i = 0; i < count; i++) {
            if (began) {
                [str insertString:character atIndex:0];
            }else {
                [str appendString:character];
            }
        }
        
        return str;
    }
    
    return self;
}
@end
