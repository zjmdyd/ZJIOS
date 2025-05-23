//
//  ZJContextView.m
//  ZJCoreGraphics
//
//  Created by YunTu on 10/7/15.
//  Copyright © 2015 YunTu. All rights reserved.
//

#import "ZJContextView.h"
#import "UIViewExt.h"

@implementation ZJContextView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIImage *img = [UIImage imageNamed:@"light"];
    // 将绘图坐标系原点沿X/Y轴移动指定距离
    CGContextTranslateCTM(context, 0, img.size.height); //  先把y移上去再翻转
    CGContextScaleCTM(context, 1.0, -1.0);  // Y 轴镜像翻转
    
    if (self.tag == 0) {
        
    }else if (self.tag == 1) {
        CGContextTranslateCTM(context, 0, -self.height/3);  // 下移1/3
    }else if (self.tag == 2) {
        CGContextScaleCTM(context, 0.5, 0.5);   // 缩小1/2
    }else if(self.tag > 2){
        CGContextScaleCTM(context, 0.5, 0.5);   // 缩小1/2
        CGContextTranslateCTM(context, 0, self.height/2);   // 上移1/2
        if (self.tag == 4) {
            CGContextTranslateCTM(context, self.width*2/3, 0);   // 右移
            CGContextRotateCTM(context, M_PI/5);
        }else if (self.tag == 5) {
            CGContextRotateCTM(context, -M_PI/4);
        }
    }
    CGContextDrawImage(context, CGRectMake(0, 0, img.size.width, img.size.height), img.CGImage);
}

@end
/*
 
 iOS开发中，有时候展示图片等内容的时候，会出现锯齿。比如笔者最近使用 iCarousel 控件的Cover flow效果来展示几幅图片时，两侧的图片出现了较为严重的锯齿，着实不好看。这里列出两个方式：
 
 在info.plist中打开抗锯齿，但是会对影响整个应用的渲染速度；
 Renders with edge antialisasing = YES （UIViewEdgeAntialiasing）
 Renders with group opacity = YES （UIViewGroupOpacity）
 View.layer.shouldRasterize = YES；
 */
