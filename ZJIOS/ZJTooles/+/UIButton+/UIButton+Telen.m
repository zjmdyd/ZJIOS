//
//  UIButton+Telen.m
//  KidReading
//
//  Created by telen on 15/11/3.
//  Copyright © 2015年 Creative Knowledge Ltd. All rights reserved.
//

#import "UIButton+Telen.h"
#import "NSObject+Associated.h"

@interface UIButton()
@property(nonatomic,strong)NSMutableArray* viewsarr;
@property(nonatomic,strong)NSNumber* scaleTransTo;
@property(nonatomic,strong)NSNumber* scaleTransDefault;
@end

@implementation UIButton(Telen)

ASSOCIATED(viewsarr, setViewsarr, NSMutableArray*, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
ASSOCIATED(scaleTransTo, setScaleTransTo, NSNumber*, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
ASSOCIATED(scaleTransDefault, setScaleTransDefault, NSNumber*, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

- (void)setScaleTransitionsValue:(CGFloat)scale
{
    self.scaleTransTo = @(scale);
}

- (void)setScaleTransitionsDefaultValue:(CGFloat)scale
{
    self.scaleTransDefault = @(scale);
}

- (void)addTouchScaleTransitions
{
    [self addViewToScale:self];
    [self add_Targets];
}

- (void)addTouchScaleTransitions_forView:(UIView *)view
{
    [self addViewToScale:view];
    [self add_Targets];
}

- (void)addTouchScaleTransitions_forViews:(UIView *)view, ...
{
    //变参处理
    va_list params;//定义一个指向个数可变的参数列表指针
    va_start(params, view);//va_start 得到第一个可变参数地址
    [self addViewToScale:view];
    if (view) {
        UIView* arg = nil;
        while ((arg = va_arg(params, UIView *))) {
            if (arg) {
                [self addViewToScale:arg];
            }
        }
    }
    va_end(params);
    [self add_Targets];
}

- (void)removeTouchScaleTransitions_forViews:(UIView *)view, ...
{
    //变参处理
    va_list params;//定义一个指向个数可变的参数列表指针
    va_start(params, view);//va_start 得到第一个可变参数地址
    [self removeViewFromScale:view];
    if (view) {
        UIView* arg = nil;
        while ((arg = va_arg(params, UIView *))) {
            if (arg) {
                [self removeViewFromScale:arg];
            }
        }
    }
    va_end(params);
}
- (void)addTouchUpInside_Ripple
{
    [self addTarget:self action:@selector(handleTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
}
ASSOCIATED(rippleColor, setRippleColor, UIColor*, OBJC_ASSOCIATION_RETAIN);
-(void)handleTouchUpInside:(UIButton*)sender {
    
    if (!sender.superview) {
        return;
    }
    
    UIColor* rippleColor = self.rippleColor;
    UIView* view = sender;
    UIView* ripplePathView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [ripplePathView.layer setCornerRadius:ripplePathView.bounds.size.width*0.5];
    
    UIColor *stroke = rippleColor ? rippleColor : [UIColor colorWithWhite:0.8 alpha:0.8];
    
    CGRect pathFrame = CGRectMake(-CGRectGetMidX(ripplePathView.bounds), -CGRectGetMidY(ripplePathView.bounds), ripplePathView.bounds.size.width, ripplePathView.bounds.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:ripplePathView.layer.cornerRadius];
    
    // accounts for left/right offset and contentOffset of scroll view
    CGPoint point = sender.center;
    CGPoint shapePosition = point;//[view convertPoint:view.center fromView:nil];
    
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = path.CGPath;
    circleShape.position = shapePosition;
    circleShape.fillColor = [UIColor clearColor].CGColor;
    circleShape.opacity = 0;
    circleShape.strokeColor = stroke.CGColor;
    circleShape.lineWidth = 3;
    
    [view.superview.layer addSublayer:circleShape];
    
    
    [CATransaction begin];
    //remove layer after animation completed
    [CATransaction setCompletionBlock:^{
        [circleShape removeFromSuperlayer];
    }];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.5, 2.5, 1)];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.duration = 0.5f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [circleShape addAnimation:animation forKey:nil];
    
    [CATransaction commit];
}


#pragma mark- private

- (void)addViewToScale:(UIView*)view
{
    if (view && [view isKindOfClass:[UIView class]]) {
        if (self.viewsarr == nil) {
            self.viewsarr = [NSMutableArray new];
        }
        [self.viewsarr addObject:[NSValue valueWithNonretainedObject:view]];
    }
}

- (void)removeViewFromScale:(UIView*)view
{
    if (self.viewsarr) {
        for (NSValue* value in self.viewsarr) {
            UIView* vview = [value nonretainedObjectValue];
            if (view == vview) {
                [self.viewsarr removeObject:vview];
                return;
            }
        }
    }
}

- (void)add_Targets
{
    [self addTarget:self action:@selector(clickDown_telen) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(clickUp_telen) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(clickUp_telen) forControlEvents:UIControlEventTouchCancel];
    [self addTarget:self action:@selector(clickUp_telen) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)clickDown_telen
{
    CGFloat scale = self.scaleTransTo.floatValue;
    if (scale <= 0) {
        scale = 1.05;
    }
    [UIView animateWithDuration:0.1 animations:^{
        for (NSValue* value in self.viewsarr) {
            UIView* view = [value nonretainedObjectValue];
            view.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }];
}

- (void)clickUp_telen
{
    CGFloat scale = self.scaleTransDefault.floatValue;
    if (scale <= 0) {
        scale = 1;
    }
    [UIView animateWithDuration:0.1 delay:0.1 options:0 animations:^{
        for (NSValue* value in self.viewsarr) {
            UIView* view = [value nonretainedObjectValue];
            view.transform = CGAffineTransformMakeScale(scale, scale);
        }
    } completion:nil];
}



@end
