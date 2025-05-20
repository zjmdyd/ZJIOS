//
//  ZJTestBezierPathView.m
//  ZJIOS
//
//  Created by issuser on 2022/5/16.
//

#import "ZJTestBezierPathView.h"

@implementation ZJTestBezierPathView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(200, 0)];
    [bezierPath addLineToPoint:CGPointMake(200, 200)];
    [bezierPath addLineToPoint:CGPointMake(0, 200)];
    [bezierPath addLineToPoint:CGPointMake(0, 0)];
    
    if (!self.needAnimation) {
        bezierPath.lineWidth = 4;
        [[UIColor yellowColor] setFill];
        [[UIColor redColor] setStroke];
        
        [bezierPath fill];

        // 调用stroke()方法画线,需要在fill之后调用,不然会被fill覆盖掉,显示不出边框
        [bezierPath stroke];
    }else {
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        lineLayer.path = bezierPath.CGPath;
        lineLayer.lineWidth = 4;
        lineLayer.fillColor = [UIColor yellowColor].CGColor;
        lineLayer.strokeColor = [UIColor redColor].CGColor;
        lineLayer.lineDashPattern = @[@5, @2];
        [self.layer addSublayer:lineLayer];
        lineLayer.strokeStart = 0;
        lineLayer.strokeEnd = 0;
        
        if (@available(iOS 10.0, *)) {
            [NSTimer scheduledTimerWithTimeInterval:0.15 repeats:YES block:^(NSTimer * _Nonnull timer) {
                if (lineLayer.strokeEnd >= 1) {
                    [timer invalidate];
                }else {
                    lineLayer.strokeEnd += 0.1;
                }
            }];
        } else {
            // Fallback on earlier versions
        }
    }
}


@end
