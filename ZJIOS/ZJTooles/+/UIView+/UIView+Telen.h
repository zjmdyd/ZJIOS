//
//  UIView+Telen.h
//  StoryMakeDemo
//
//  Created by telen on 15/6/26.
//  Copyright (c) 2015年 Creative Knowledge Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Telen)

- (UIImage*)tl_takePicture;

- (BOOL)tl_LayoutChange_width:(CGFloat)width animated:(BOOL)ani;
- (BOOL)tl_LayoutChange_Height:(CGFloat)height animated:(BOOL)ani;

- (BOOL)tl_LayoutChange_top:(CGFloat)top animated:(BOOL)ani;
- (BOOL)tl_LayoutChange_left:(CGFloat)left animated:(BOOL)ani;
- (BOOL)tl_LayoutChange_Bottom:(CGFloat)bottom animated:(BOOL)ani;
- (BOOL)tl_LayoutChange_right:(CGFloat)right animated:(BOOL)ani;

//为自己添加移动事件
- (UIPanGestureRecognizer*)addPanGesture_CanMove;
- (UIPanGestureRecognizer*)addPanGesture_Move_End:(void(^)(UIView* view, CGPoint offset)) MoveEnd;
//为自己添加点击事件，拦截响应
- (UITapGestureRecognizer*)addTapGesture_Undo;
- (UIPanGestureRecognizer*)addPanGesture_Undo;

@end
