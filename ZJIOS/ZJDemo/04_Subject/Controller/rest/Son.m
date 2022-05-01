//
//  Son.m
//  ZJIOS
//
//  Created by issuser on 2021/11/22.
//

#import "Son.h"
#import "NSObject+ZJMethodSwizzling.h"

@implementation Son

+ (void)load {
    NSLog(@"%@-->load", self);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self exchangeMethod:@selector(eat) swizzledSelector:@selector(eatAnother)];
    });
}

- (void)eatAnother {
    NSLog(@"son eaAnother, self = %@", self.class);
    [self eatAnother];
}

/*
 - (void)eat {
    NSLog(@"son eaAnther, self = %@", self.class);
    [self eatAnother];
 }
 
 - (void)eaAnother {
    NSLog(@"eat, self = %@", self.class);
 }
 */

@end
