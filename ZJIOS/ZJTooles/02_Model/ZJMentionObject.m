//
//  ZJMentionObject.m
//  AoShiTong
//
//  Created by ZJ on 2018/9/7.
//  Copyright © 2018 HY. All rights reserved.
//

#import "ZJMentionObject.h"

@implementation ZJMentionObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.duration = 0.25;
        self.firstText = @"";
        self.secondText = @"";
    }
    return self;
}
@end
