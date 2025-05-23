//
//  GravityWithCollisionBehavior.h
//  UIDynamic
//
//  Created by YunTu on 14/12/29.
//  Copyright (c) 2014年 YunTu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GravityWithCollisionBehavior : UIDynamicBehavior

- (instancetype) initWithItem:(NSArray *)items;

@property (nonatomic, weak) id <UICollisionBehaviorDelegate> delegate;

@end
