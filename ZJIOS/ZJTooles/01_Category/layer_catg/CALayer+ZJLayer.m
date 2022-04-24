//
//  CALayer+ZJLayer.m
//  ZJIOS
//
//  Created by issuser on 2022/4/24.
//

#import "CALayer+ZJLayer.h"

@implementation CALayer (ZJLayer)

- (void)setMaskCornerRadius:(CGFloat)radius {
    self.cornerRadius = radius;
    self.masksToBounds = YES;
}

- (void)setBorderWidth:(CGFloat)width color:(UIColor *)color {
    [self setBorderWidth:width color:color cornerRadius:0];
}

- (void)setBorderWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    self.borderWidth = width;
    self.borderColor = color.CGColor;
    [self setMaskCornerRadius:cornerRadius];
}

- (void)addMaskLayerAtRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.mask = maskLayer;
}

- (void)addMaskLayerBorderAtRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.mask = maskLayer;
}

- (CAShapeLayer *)addBorderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType {
    return [self addDashBorderForColor:color borderWidth:borderWidth borderType:borderType needDash:NO xPosion:0 yPosition:0];
}

- (CAShapeLayer *)addDashBorderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType {
    return [self addDashBorderForColor:color borderWidth:borderWidth borderType:borderType needDash:YES xPosion:0 yPosition:0];
}

- (CAShapeLayer *)addDashBorderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType xPosion:(CGFloat)x yPosition:(CGFloat)y {
    return [self addDashBorderForColor:color borderWidth:borderWidth borderType:borderType needDash:YES xPosion:x yPosition:y];
}

- (CAShapeLayer *)addDashBorderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType needDash:(BOOL)need xPosion:(CGFloat)x yPosition:(CGFloat)y {
    if (borderType == UIBorderSideTypeAll) {
        self.borderWidth = borderWidth;
        self.borderColor = color.CGColor;
    }
    CGFloat originX = x > 0 ? x : self.frame.size.width;
    CGFloat originY = y > 0 ? y : self.frame.size.height;
    CAShapeLayer *layer;
        
    // 左侧
    if (borderType & UIBorderSideTypeLeft) {
         // 左侧线路径
        layer = [self shapeLayerFromPoint:CGPointMake(0.0f, 0.f) toPoint:CGPointMake(0.0f, originY) color:color borderWidth:borderWidth needDash:need];
    }
    
    // 右侧
    if (borderType & UIBorderSideTypeRight) {
        // 右侧线路径
        layer = [self shapeLayerFromPoint:CGPointMake(originX, 0.0f) toPoint:CGPointMake(originX, originY) color:color borderWidth:borderWidth needDash:need];
    }
    
    // top
    if (borderType & UIBorderSideTypeTop) {
        // top线路径
        layer = [self shapeLayerFromPoint:CGPointMake(0.0f, 0.0f) toPoint:CGPointMake(originX, 0.0f) color:color borderWidth:borderWidth needDash:need];
    }
    
    // bottom
    if (borderType & UIBorderSideTypeBottom) {
        // bottom线路径
        layer = [self shapeLayerFromPoint:CGPointMake(0.0f, originY) toPoint:CGPointMake(originX, originY) color:color borderWidth:borderWidth needDash:need];
    }
    [self addSublayer:layer];
    
    return layer;
}

- (CAShapeLayer *)shapeLayerFromPoint:(CGPoint)p0 toPoint:(CGPoint)p1 color:(UIColor *)color borderWidth:(CGFloat)borderWidth needDash:(BOOL)needDash {
    return [self shapeLayerFromPoint:p0 toPoint:p1 color:color borderWidth:borderWidth needDash:needDash lineDashPattern:@[@5, @5]];
}

- (CAShapeLayer *)shapeLayerFromPoint:(CGPoint)p0 toPoint:(CGPoint)p1 color:(UIColor *)color borderWidth:(CGFloat)borderWidth needDash:(BOOL)needDash lineDashPattern:(NSArray<NSNumber *> *)pattern{
    // 线的路径
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:p0];
    [bezierPath addLineToPoint:p1];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor  = [UIColor clearColor].CGColor;
    shapeLayer.path = bezierPath.CGPath;    // 添加路径
    if (needDash) {
        shapeLayer.lineDashPattern = pattern;
    }
    shapeLayer.lineWidth = borderWidth;     // 线宽度
    
    return shapeLayer;
}

@end
