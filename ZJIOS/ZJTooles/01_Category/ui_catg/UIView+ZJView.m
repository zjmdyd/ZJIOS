//
//  UIView+ZJView.m
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import "UIView+ZJView.h"
#import "UIColor+ZJColor.h"
#import "UIImageView+ZJImageView.h"

#define tapEvent @"tapEvent:"

@implementation UIView (ZJView)

- (void)setCornerRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

- (void)setBorderWidth:(CGFloat)width color:(UIColor *)color {
    [self setBorderWidth:width color:color cornerRadius:0];
}

- (void)setBorderWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
    [self setCornerRadius:cornerRadius];
}

- (void)addTapGestureWithDelegate:(id <UIGestureRecognizerDelegate>)delegate target:(id)target {
    SEL s = NSSelectorFromString(tapEvent);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:s];
    tap.delegate = delegate;
    [self addGestureRecognizer:tap];
}

+ (UIView *)maskViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor maskViewColor];
    view.alpha = 0.4;
    
    return view;
}

- (UIView *)subViewWithTag:(NSInteger)tag {
    for (UIView *view in self.subviews) {
        if (view.tag == tag) {
            return view;
        }
    }
    
    return nil;
}

- (void)logSubViews {
    for (UIView *view in self.subviews) {
        NSLog(@"view = %@", view);
        [view logSubViews];
    }
    NSLog(@"\n\n");
}

- (UIView *)fetchSubViewWithClassName:(NSString *)className {
    UIView *mView;
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(className)]) {
            return view;
        }else {
            [view fetchSubViewWithClassName:className];
        }
    }
    
    return mView;
}

- (UIView *)fetchSuperViewWithClassName:(NSString *)className {
    if (self.superview) {
        if ([self.superview isKindOfClass:NSClassFromString(className)]) {
            return self.superview;
        }else {
            return [self.superview fetchSuperViewWithClassName:className];
        }
    }
    
    return nil;
}

+ (UIView *)createTitleIVWithFrame:(CGRect)frame path:(NSString *)path placehold:(NSString *)placehold title:(NSString *)title {
    UIView *view = [[UIView alloc] initWithFrame:frame];

    CGFloat height = view.frame.size.height, width = view.frame.size.width;
    
    UIImageView *iv = [UIImageView imageViewWithFrame:frame path:path placehold:placehold];
    [view addSubview:iv];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x + iv.frame.size.width+4, 2.5, width-iv.frame.size.width-4, height-5)];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
    
    return view;
}

- (void)addMaskLayerAtRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)addMaskLayerBorderAtRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (CAShapeLayer *)addBorderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType {
    return [self addDashBorderForColor:color borderWidth:borderWidth borderType:borderType needDash:NO width:0 height:0];
}

- (CAShapeLayer *)addDashBorderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType {
    return [self addDashBorderForColor:color borderWidth:borderWidth borderType:borderType needDash:YES width:0 height:0];
}

- (CAShapeLayer *)addDashBorderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType width:(CGFloat)width height:(CGFloat)height {
    return [self addDashBorderForColor:color borderWidth:borderWidth borderType:borderType needDash:YES width:width height:height];
}

- (CAShapeLayer *)addDashBorderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType needDash:(BOOL)need width:(CGFloat)width height:(CGFloat)height {
    if (borderType == UIBorderSideTypeAll) {
        self.layer.borderWidth = borderWidth;
        self.layer.borderColor = color.CGColor;
    }
    CGFloat wd = width > 0 ? width : self.frame.size.width;
    CGFloat ht = height > 0 ? height : self.frame.size.height;
    CAShapeLayer *layer;
    
    /// 左侧
    if (borderType & UIBorderSideTypeLeft) {
        /// 左侧线路径
        layer = [self addLineOriginPoint:CGPointMake(0.f, 0.f) toPoint:CGPointMake(0.0f, ht) color:color borderWidth:borderWidth needDash:need];
    }
    
    /// 右侧
    if (borderType & UIBorderSideTypeRight) {
        /// 右侧线路径
        layer = [self addLineOriginPoint:CGPointMake(wd, 0.0f) toPoint:CGPointMake(wd, ht) color:color borderWidth:borderWidth needDash:need];
    }
    
    /// top
    if (borderType & UIBorderSideTypeTop) {
        /// top线路径
        layer = [self addLineOriginPoint:CGPointMake(0.0f, 0.0f) toPoint:CGPointMake(wd, 0.0f) color:color borderWidth:borderWidth needDash:need];
    }
    
    /// bottom
    if (borderType & UIBorderSideTypeBottom) {
        /// bottom线路径
        layer = [self addLineOriginPoint:CGPointMake(0.0f, ht) toPoint:CGPointMake(wd, ht) color:color borderWidth:borderWidth needDash:need];
    }
    [self.layer addSublayer:layer];
    return layer;
}

- (CAShapeLayer *)addLineOriginPoint:(CGPoint)p0 toPoint:(CGPoint)p1 color:(UIColor *)color borderWidth:(CGFloat)borderWidth needDash:(BOOL)needDash {
    /// 线的路径
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:p0];
    [bezierPath addLineToPoint:p1];
    
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor  = [UIColor clearColor].CGColor;
    /// 添加路径
    shapeLayer.path = bezierPath.CGPath;
    if (needDash) {
        shapeLayer.lineDashPattern = @[@5, @5];
    }
    /// 线宽度
    shapeLayer.lineWidth = borderWidth;
    
    return shapeLayer;
}

#pragma mark - supplementView

- (void)addIconBadgeWithImage:(UIImage *)image {
    [self createImageViewWithImage:image bgColor:nil];
}

- (void)addIconBadgeWithImage:(UIImage *)image bgColor:(UIColor *)color {
    [self createImageViewWithImage:image bgColor:color];
}

- (void)createImageViewWithImage:(UIImage *)image bgColor:(UIColor *)color {
    CGFloat width = 15;
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-10, 0, width, width)];
    iv.image = image;
    if (color) {
        iv.backgroundColor = color;
    }
    iv.layer.cornerRadius = width / 2;
    iv.layer.masksToBounds = YES;
    
    [self addSubview:iv];
}

- (QuadrantTouchType)quadrantOfTouchPoint:(CGPoint)point separateType:(AnnularSeparateType)type {
    CGFloat x = point.x, y = point.y;
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    if (type == AnnularSeparateTypeOfQuarter) {
        if (x <= width/2 && y <= height/2) {
            return QuadrantTouchTypeOfSecond;
        }else if (x > width/2 && y <= height/2) {
            return QuadrantTouchTypeOfFirst;
        }else if (x <= width/2 && y > height/2) {
            return QuadrantTouchTypeOfThird;
        }else {
            return QuadrantTouchTypeOfFourth;
        }
    }else {
        if (y <= width/2) {
            return QuadrantTouchTypeOfFirst ;
        }else {
            return QuadrantTouchTypeOfSecond;
        }
    }
}

- (BOOL)touchPointInTheAnnular:(CGPoint)point annularWidth:(CGFloat)annularWidth {
    CGFloat x = point.x, y = point.y;
    CGFloat width = self.bounds.size.width;
    CGFloat dx = fabs(x-width/2);
    CGFloat dy = fabs(y-width/2);
    CGFloat dis = sqrt(dx*dx + dy*dy);
    if (dis<width/2 && dis>(width/2-annularWidth)) {
        return YES;
    }
    return NO;
}

@end
