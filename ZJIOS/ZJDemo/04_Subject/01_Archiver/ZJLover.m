//
//  ZJLover.m
//  ZJFoundation
//
//  Created by YunTu on 15/7/3.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ZJLover.h"

@implementation ZJLover

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.age forKey:@"age"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.age = [aDecoder decodeIntegerForKey:@"age"];
    }
    
    return self;
}

@end
