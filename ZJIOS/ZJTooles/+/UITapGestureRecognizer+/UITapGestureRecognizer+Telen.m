//
//  UITapGestureRecognizer+Telen.m
//  KidReading
//
//  Created by telen on 16/2/1.
//  Copyright © 2016年 Creative Knowledge Ltd. All rights reserved.
//

#import "UITapGestureRecognizer+Telen.h"
#import "NSObject+Associated.h"

@implementation UITapGestureRecognizer(Telen)

ASSOCIATED(rippleColor, setRippleColor, UIColor*, OBJC_ASSOCIATION_RETAIN);

- (void)addTapRipple
{
    [self addTarget:self action:@selector(handleTap:)];
}

-(void)handleTap:(UITapGestureRecognizer*)sender {
    
    UIColor* rippleColor = self.rippleColor;
    UIView* view = sender.view;
    UIView* ripplePathView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [ripplePathView.layer setCornerRadius:ripplePathView.bounds.size.width*0.5];
    
    UIColor *stroke = rippleColor ? rippleColor : [UIColor colorWithWhite:0.8 alpha:0.8];
    
    CGRect pathFrame = CGRectMake(-CGRectGetMidX(ripplePathView.bounds), -CGRectGetMidY(ripplePathView.bounds), ripplePathView.bounds.size.width, ripplePathView.bounds.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:ripplePathView.layer.cornerRadius];
    
    // accounts for left/right offset and contentOffset of scroll view
    CGPoint point = [sender locationInView:view];
    CGPoint shapePosition = point;//[view convertPoint:view.center fromView:nil];
    
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = path.CGPath;
    circleShape.position = shapePosition;
    circleShape.fillColor = [UIColor clearColor].CGColor;
    circleShape.opacity = 0;
    circleShape.strokeColor = stroke.CGColor;
    circleShape.lineWidth = 3;
    
    [view.layer addSublayer:circleShape];
    
    
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

@end
