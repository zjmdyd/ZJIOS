//
//  GravityWithCollisionBehavior.m
//  UIDynamic
//
//  Created by YunTu on 14/12/29.
//  Copyright (c) 2014年 YunTu. All rights reserved.
//

#import "GravityWithCollisionBehavior.h"

@interface GravityWithCollisionBehavior ()

@property (nonatomic, strong) UICollisionBehavior *cb;

@end

@implementation GravityWithCollisionBehavior

- (instancetype)initWithItem:(NSArray *)items {
    if (self = [super init]) {
        UIGravityBehavior *gb = [[UIGravityBehavior alloc] initWithItems:items];
        self.cb = [[UICollisionBehavior alloc] initWithItems:items];
        self.cb.translatesReferenceBoundsIntoBoundary = YES;
        [self addChildBehavior:gb];
        [self addChildBehavior:self.cb];
    }
    return self;
}

- (void)setDelegate:(id<UICollisionBehaviorDelegate>)delegate {
    _delegate = delegate;
    
    self.cb.collisionDelegate = _delegate;
}

@end
