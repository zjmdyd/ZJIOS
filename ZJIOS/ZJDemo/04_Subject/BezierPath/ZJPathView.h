//
//  ZJView.h
//  ZJBezier
//
//  Created by YunTu on 15/3/13.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJPathView : UIView

@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;
@property (nonatomic, assign) CGPoint centerPoint;

@property (nonatomic, assign) BOOL isInit;
@property (nonatomic, assign) BOOL isFill;
@property (nonatomic, strong) UIBezierPath *bPath;

@end
