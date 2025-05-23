//
//  ZJView.m
//  ZJBezier
//
//  Created by YunTu on 15/3/13.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ZJPathView.h"
#import "UIViewExt.h"

#define LineWidth 13

@implementation ZJPathView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    if (!self.isInit) {
        // startAngle = -M_PI_2;
        // endAngle = 0;
        
        // 淡蓝色环(一圈)
        UIBezierPath *path = [[UIBezierPath alloc]init];
        [path addArcWithCenter:self.centerPoint radius:(self.width-LineWidth)*0.5 startAngle:self.startAngle endAngle:M_PI*3/2 clockwise:YES];
        UIColor *color = [UIColor colorWithRed:0.5 green:0.74 blue:0.90 alpha:0.64];
        [color setStroke];
        path.lineWidth = LineWidth;
        [path stroke];
        [path closePath];
        
        // 1/4白环
        UIBezierPath *path2 = [[UIBezierPath alloc]init];
        [path2 addArcWithCenter:self.centerPoint radius:(self.width-LineWidth)*0.5 startAngle:self.startAngle endAngle:self.endAngle clockwise:YES];
        [[UIColor whiteColor] setStroke];
        path2.lineWidth = LineWidth;
        [path2 stroke];
        [path2 closePath];
        
        // 1/4扇形区域
        UIBezierPath *path3 = [UIBezierPath bezierPath];
        [path3 moveToPoint:self.centerPoint];
        [path3 addArcWithCenter:self.centerPoint radius:self.width*0.5-LineWidth startAngle:self.startAngle endAngle:self.endAngle clockwise:YES];
        if (self.endAngle > -M_PI_2) {
            UIColor *color = [UIColor colorWithRed:0 green:0.758 blue:0.82 alpha:0.485];
            [color setStroke];
            [color setFill];
            [path3 stroke];
            [path3 fill];
        }
        [path3 closePath];
        
        self.isInit = YES;
    }else{
        [[UIColor redColor] setStroke];
        [[UIColor yellowColor] setFill];
        [self.bPath stroke];
        if (self.isFill) {
            [self.bPath fill];
        }
    }

    CGContextRestoreGState(context);
}


@end
