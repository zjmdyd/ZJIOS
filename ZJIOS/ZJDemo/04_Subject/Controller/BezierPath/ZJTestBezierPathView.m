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
    bezierPath.lineWidth = 4;
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(200, 0)];
    [bezierPath addLineToPoint:CGPointMake(200, 200)];
    [bezierPath addLineToPoint:CGPointMake(0, 200)];
    [bezierPath addLineToPoint:CGPointMake(0, 0)];

    [[UIColor yellowColor] setFill];
    [[UIColor redColor] setStroke];
    
    [bezierPath fill];

    // 调用stroke()方法画线,需要在fill之后调用,不然会被fill覆盖掉,显示不出边框
    [bezierPath stroke];
}


@end
