//
//  GravityWithCollisionBehavior.m
//  UIDynamic
//
//  Created by YunTu on 14/12/29.
//  Copyright (c) 2014年 YunTu. All rights reserved.
//

#import "GravityWithCollisionBehavior.h"

@implementation GravityWithCollisionBehavior

- (instancetype)initWithItem:(NSArray *)items {
    if (self = [super init]) {
        UIGravityBehavior *gb = [[UIGravityBehavior alloc] initWithItems:items];
        UICollisionBehavior *cb = [[UICollisionBehavior alloc] initWithItems:items];
        cb.translatesReferenceBoundsIntoBoundary = YES;
        [self addChildBehavior:gb];
        [self addChildBehavior:cb];
    }
    return self;
}

@end
