//
//  UIView+CornerRadius.h
//  KidReading
//
//  Created by YangShuai on 16/5/5.
//  Copyright © 2016年 Creative Knowledge Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CornerRadius)

- (void)viewAddBezierPathWithRoundedRect:(CGRect)rect byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

@end
