//
//  NSMutableDictionary+NullSafe.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/17.
//

#import "NSMutableDictionary+NullSafe.h"
#import "NSObject+SwizzleMethod.h"

@implementation NSMutableDictionary (NullSafe)

//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        id obj = [[self alloc] init];
//        [obj swizzleMethod:@selector(setObject:forKey:) withMethod:@selector(safe_setObject:forKey:)];
//    });
//}
//
//- (void)safe_setObject:(id)value forKey:(NSString *)key {
//    if (value) {
//        NSLog(@"设置值");
//        [self setObject:value forKey:key];
//    }else {
//        NSLog(@"***[NSMutableDictionary setObject: forKey:], Object cannot be nil");
//    }
//}

@end
