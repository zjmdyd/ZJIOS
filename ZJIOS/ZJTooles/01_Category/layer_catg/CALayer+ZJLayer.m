//
//  CALayer+ZJLayer.m
//  ZJIOS
//
//  Created by issuser on 2022/4/24.
//

#import "CALayer+ZJLayer.h"
#import "UIBezierPath+ZJBezierPath.h"

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

- (ZJShapeLayer *)addBorderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType {
    return [self addBorderForColor:color borderWidth:borderWidth borderType:borderType posion_value_1:-1 posion_value_2:-1 needDash:NO];
}

- (ZJShapeLayer *)addBorderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType posion_value_1:(CGFloat)p_value_1 posion_value_2:(CGFloat)p_value_2 {
    return [self addBorderForColor:color borderWidth:borderWidth borderType:borderType posion_value_1:p_value_1 posion_value_2:p_value_2 needDash:NO];
}

- (ZJShapeLayer *)addDashBorderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType {
    return [self addBorderForColor:color borderWidth:borderWidth borderType:borderType posion_value_1:-1 posion_value_2:-1 needDash:YES];
}

- (ZJShapeLayer *)addDashBorderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType posion_value_1:(CGFloat)p_value_1 posion_value_2:(CGFloat)p_value_2 {
    return [self addBorderForColor:color borderWidth:borderWidth borderType:borderType posion_value_1:p_value_1 posion_value_2:p_value_2 needDash:YES];
}

- (ZJShapeLayer *)addBorderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType posion_value_1:(CGFloat)p_value_1 posion_value_2:(CGFloat)p_value_2 needDash:(BOOL)need {
    ZJShapeLayer *layer;

    if (borderType == UIBorderSideTypeAll) {
        UIBezierPath *bezierPath = [UIBezierPath pathWithBorderRectSize:self.frame.size];
        layer = [self shapeLayerWithPath:bezierPath color:color borderWidth:borderWidth needDash:need lineDashPattern:@[@5, @5]];
    }else {
        CGFloat s_width = self.frame.size.width;
        CGFloat s_height = self.frame.size.height;
        
        CGFloat vertical_p_value_1 = p_value_1 > 0 ? p_value_1 : 0;
        CGFloat vertical_p_value_2 = p_value_2 > 0 ? p_value_2 : s_height;
        
        CGFloat horizontal_ps1 = p_value_1 > 0 ? p_value_1 : 0;
        CGFloat horizontal_ps2 = p_value_2 > 0 ? p_value_2 : s_width;

        CGPoint startPoint = CGPointZero, endPoint = CGPointZero;
        
        CGFloat fixed_value;
        if ((borderType & UIBorderSideTypeLeft) || (borderType & UIBorderSideTypeRight)) {
            if (borderType & UIBorderSideTypeLeft) {    // 左侧线路径
                fixed_value = 0.0f;
            }else {                                     // 右侧线路径
                fixed_value = s_width;
            }
            startPoint = CGPointMake(fixed_value, vertical_p_value_1);
            endPoint = CGPointMake(fixed_value, vertical_p_value_2);
        }else {
            if (borderType & UIBorderSideTypeTop) {     // top线路径
                fixed_value = 0.0f;
            }else {                                     // bottom线路
                fixed_value = s_height;
            }
            startPoint = CGPointMake(horizontal_ps1, fixed_value);
            endPoint = CGPointMake(horizontal_ps2, fixed_value);
        }
        
        layer = [self shapeLayerFromPoint:startPoint toPoint:endPoint color:color borderWidth:borderWidth needDash:need];
    }
    layer.borderType = borderType;
    NSLog(@"添加layer前的sublayers:%@", self.sublayers);
    [self addSublayer:layer];
    NSLog(@"添加layer后的sublayers:%@", self.sublayers);
    
    return layer;
}

- (ZJShapeLayer *)shapeLayerFromPoint:(CGPoint)p0 toPoint:(CGPoint)p1 color:(UIColor *)color borderWidth:(CGFloat)borderWidth needDash:(BOOL)needDash {
    return [self shapeLayerFromPoint:p0 toPoint:p1 color:color borderWidth:borderWidth needDash:needDash lineDashPattern:@[@5, @5]];
}

- (ZJShapeLayer *)shapeLayerFromPoint:(CGPoint)p0 toPoint:(CGPoint)p1 color:(UIColor *)color borderWidth:(CGFloat)borderWidth needDash:(BOOL)needDash lineDashPattern:(NSArray<NSNumber *> *)pattern {
    UIBezierPath *path = [UIBezierPath pathWithPoint:p0 toPoint:p1];
    
    return [self shapeLayerWithPath:path color:color borderWidth:borderWidth needDash:needDash lineDashPattern:pattern];
}

- (ZJShapeLayer *)shapeLayerWithPath:(UIBezierPath *)bezierPath color:(UIColor *)color borderWidth:(CGFloat)borderWidth needDash:(BOOL)needDash lineDashPattern:(NSArray<NSNumber *> *)pattern{
    ZJShapeLayer *shapeLayer = [ZJShapeLayer layer];
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor  = [UIColor clearColor].CGColor;
    shapeLayer.path = bezierPath.CGPath;    // 添加路径
    if (needDash) {
        shapeLayer.lineDashPattern = pattern;
    }
    shapeLayer.lineWidth = borderWidth;     // 线宽度
    
    return shapeLayer;
}

- (void)removeBorderWithType:(UIBorderSideType)borderType {
    NSLog(@"移除前sublayers = %@", self.sublayers);
    for(int i = 0; i < self.sublayers.count; i++) {
        ZJShapeLayer *obj = self.sublayers[i];
        if (borderType == UIBorderSideTypeAll) {
            [obj removeFromSuperlayer];
            NSLog(@"移除后sublayers = %@", self.sublayers);
            i--;
        }else {
            if (obj.borderType == borderType) {
                [obj removeFromSuperlayer];
                NSLog(@"移除后sublayers = %@", self.sublayers);
                break;
            }
        }
    }
}

@end
