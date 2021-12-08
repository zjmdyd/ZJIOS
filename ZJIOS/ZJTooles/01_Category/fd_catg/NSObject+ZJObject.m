//
//  NSObject+ZJObject.m
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import "NSObject+ZJObject.h"
#import "NSString+ZJString.h"

@implementation NSObject (ZJObject)

- (NSString *)jsonString {
    if (!self) return nil;
    if (![NSJSONSerialization isValidJSONObject:self]) {
        return nil;
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return str;
}

- (NSString *)descriptionText {
    return [self descriptionTextWithDefault:@"--"];
}

- (NSString *)descriptionTextWithDefault:(NSString *)defaultText {
    if ([self isKindOfClass:[NSString class]]) {
        if (![((NSString *)self) isEmptyString]) {
            return (NSString *)self;
        }
    }else if ([self isKindOfClass:[NSNumber class]]) {
        return ((NSNumber *)self).stringValue;
    }
    
    return defaultText;
}

@end
