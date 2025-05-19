//
//  Father.m
//  ZJIOS
//
//  Created by issuser on 2021/11/22.
//

#import "Father.h"

@implementation Father

+ (void)load {
    NSLog(@"%s", __func__);
}

- (void)eat {
    NSLog(@"eat, self = %@", self.class);
}

@end
