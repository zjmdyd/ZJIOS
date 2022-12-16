//
//  ZJTestRoundView.m
//  ZJIOS
//
//  Created by issuser on 2022/8/4.
//

#import "ZJTestRoundView.h"

@implementation ZJTestRoundView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGFloat radius1 = self.frame.size.width/2, radius2 = radius1*3/5, px = radius1, py = radius1;
    CGFloat line1Width = radius1/3, line2Width = radius2/3;
    for (int i = 0; i < self.angles.count; i++) {
        ZJAngleObject *obj = self.angles[i];
        
        UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(px, py) radius:radius1-line1Width/2 startAngle:obj.startAngle endAngle:obj.endAngle clockwise:YES];
        path1.lineWidth = line1Width;
        UIColor *strokeColor = self.colors[i];
        [strokeColor setStroke];
        [path1 stroke];
        
        UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(px, py) radius:radius2-line2Width/2 startAngle:obj.startAngle endAngle:obj.endAngle clockwise:YES];
        path2.lineWidth = line2Width;
        [path2 stroke];
    }
}

@end
