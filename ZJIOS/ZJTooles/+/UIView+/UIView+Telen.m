//
//  UIView+Telen.m
//  StoryMakeDemo
//
//  Created by telen on 15/6/26.
//  Copyright (c) 2015年 Creative Knowledge Ltd. All rights reserved.
//

#import "UIView+Telen.h"
#import <objc/runtime.h>

@implementation UIView (Telen)

- (UIImage *)tl_takePicture
{
    return [self snapshot_view];
}

- (UIImage *)snapshot_view
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size,YES,0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)snapshot_layer
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (BOOL)tl_LayoutChange_width:(CGFloat)width animated:(BOOL)ani
{
    if (self.translatesAutoresizingMaskIntoConstraints == YES) {
        return NO;
    }
    for (NSLayoutConstraint* constraint in self.constraints) {
        if (constraint.firstItem == self
            && constraint.firstAttribute == NSLayoutAttributeWidth) {
            constraint.constant = width;
        }
    }
    if (ani) {
        [UIView animateWithDuration:0.3f animations:^{
            [self layoutIfNeeded];
        }];
    }else{
        [self layoutIfNeeded];
    }
    return YES;
}

- (BOOL)tl_LayoutChange_Height:(CGFloat)height animated:(BOOL)ani
{
    if (self.translatesAutoresizingMaskIntoConstraints == YES) {
        return NO;
    }
    for (NSLayoutConstraint* constraint in self.constraints) {
        if (constraint.firstItem == self
            && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = height;
        }
    }
    if (ani) {
        [UIView animateWithDuration:0.3f animations:^{
            [self layoutIfNeeded];
        }];
    }else{
        [self layoutIfNeeded];
    }
    return YES;
}

//-------------------
- (BOOL)tl_LayoutChange_top:(CGFloat)top animated:(BOOL)ani
{
    if (self.translatesAutoresizingMaskIntoConstraints == YES) {
        return NO;
    }
    for (NSLayoutConstraint* constraint in self.superview.constraints) {
        if (constraint.secondItem == self && constraint.firstAttribute == NSLayoutAttributeTop) {
            constraint.constant = top;
        }
    }
    if (ani) {
        [UIView animateWithDuration:0.3f animations:^{
            [self layoutIfNeeded];
        }];
    }else{
        [self layoutIfNeeded];
    }
    return YES;
}

- (BOOL)tl_LayoutChange_left:(CGFloat)left animated:(BOOL)ani
{
    if (self.translatesAutoresizingMaskIntoConstraints == YES) {
        return NO;
    }
    for (NSLayoutConstraint* constraint in self.superview.constraints) {
        if (constraint.secondItem == self && constraint.firstAttribute == NSLayoutAttributeLeft) {
            constraint.constant = left;
        }
    }
    if (ani) {
        [UIView animateWithDuration:0.3f animations:^{
            [self layoutIfNeeded];
        }];
    }else{
        [self layoutIfNeeded];
    }
    return YES;
}

- (BOOL)tl_LayoutChange_Bottom:(CGFloat)bottom animated:(BOOL)ani
{
    if (self.translatesAutoresizingMaskIntoConstraints == YES) {
        return NO;
    }
    for (NSLayoutConstraint* constraint in self.superview.constraints) {
        if (constraint.secondItem == self && constraint.firstAttribute == NSLayoutAttributeBottom) {
            constraint.constant = bottom;
        }
    }
    if (ani) {
        [UIView animateWithDuration:0.3f animations:^{
            [self layoutIfNeeded];
        }];
    }else{
        [self layoutIfNeeded];
    }
    return YES;
}

- (BOOL)tl_LayoutChange_right:(CGFloat)right animated:(BOOL)ani
{
    if (self.translatesAutoresizingMaskIntoConstraints == YES) {
        return NO;
    }
    for (NSLayoutConstraint* constraint in self.superview.constraints) {
        if (constraint.secondItem == self && constraint.firstAttribute == NSLayoutAttributeRight) {
            constraint.constant = right;
        }
    }
    if (ani) {
        [UIView animateWithDuration:0.3f animations:^{
            [self layoutIfNeeded];
        }];
    }else{
        [self layoutIfNeeded];
    }
    return YES;
}

#pragma mark-
#define propertyName_MoveEndBlock "MoveEndBlock"
- (UITapGestureRecognizer*)addTapGesture_Undo
{
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(undoTap)];
    [self addGestureRecognizer:tap];
    return tap;
}
- (UIPanGestureRecognizer*)addPanGesture_Undo
{
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(undoTap)];
    [self addGestureRecognizer:pan];
    return pan;
}
- (UIPanGestureRecognizer*)addPanGesture_CanMove
{
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragged:)];
    [self addGestureRecognizer:pan];
    return pan;
}
- (UIPanGestureRecognizer*)addPanGesture_Move_End:(void(^)(UIView*, CGPoint)) MoveEnd
{
    objc_setAssociatedObject(self, propertyName_MoveEndBlock, MoveEnd, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragged:)];
    [self addGestureRecognizer:pan];
    return pan;
}
- (void)undoTap{}
- (void)didDragged:(UIPanGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateChanged ||
        sender.state == UIGestureRecognizerStateEnded) {
        //注意，这里取得的参照坐标系是该对象的上层View的坐标。
        CGPoint offset = [sender translationInView:self.superview];
        UIView *draggableObj = self;
        //通过计算偏移量来设定draggableObj的新坐标
        CGPoint pt = CGPointMake(draggableObj.center.x + offset.x, draggableObj.center.y + offset.y);
        [draggableObj setCenter:pt];
        //初始化sender中的坐标位置。如果不初始化，移动坐标会一直积累起来。
        [sender setTranslation:CGPointMake(0, 0) inView:self.superview];
        //
        void(^blockEnd)(UIView*, CGPoint) = objc_getAssociatedObject(self, propertyName_MoveEndBlock);
        if (blockEnd) {
            blockEnd(self,offset);
        }
    }
}

#pragma mark-

@end
