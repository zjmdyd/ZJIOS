//
//  Father.m
//  ZJIOS
//
//  Created by issuser on 2021/11/22.
//

#import "Father.h"

@implementation Father

+ (void)load {
    NSLog(@"%@-->load", self);
}

- (void)eat {
    NSLog(@"eat, self = %@", self.class);
}

@end
