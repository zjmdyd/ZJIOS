//
//  UINavigationController+telen.h
//  Reader
//
//  Created by telen on 14-4-20.
//  Copyright (c) 2014年 Creative Knowledge Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 ** type
 *
 *  各种动画效果  其中除了'fade', `moveIn', `push' , `reveal' ,其他属于私有的API(我是这么认为的,可以点进去看下注释).
 *  ↑↑↑上面四个可以分别使用'kCATransitionFade', 'kCATransitionMoveIn', 'kCATransitionPush', 'kCATransitionReveal'来调用.
 *  @"cube"                     立方体翻滚效果
 *  @"moveIn"                   新视图移到旧视图上面
 *  @"reveal"                   显露效果(将旧视图移开,显示下面的新视图)
 *  @"fade"                     交叉淡化过渡(不支持过渡方向)             (默认为此效果)
 *  @"pageCurl"                 向上翻一页
 *  @"pageUnCurl"               向下翻一页
 *  @"suckEffect"               收缩效果，类似系统最小化窗口时的神奇效果(不支持过渡方向)
 *  @"rippleEffect"             滴水效果,(不支持过渡方向)
 *  @"oglFlip"                  上下左右翻转效果
 *  @"rotate"                   旋转效果
 *  @"push"
 *  @"cameraIrisHollowOpen"     相机镜头打开效果(不支持过渡方向)
 *  @"cameraIrisHollowClose"    相机镜头关上效果(不支持过渡方向)
 *
 
 ** type
 *
 *  kCATransitionFade            交叉淡化过渡
 *  kCATransitionMoveIn          新视图移到旧视图上面
 *  kCATransitionPush            新视图把旧视图推出去
 *  kCATransitionReveal          将旧视图移开,显示下面的新视图
 
 animation.type = type;
 
 ** subtype
 *
 *  各种动画方向
 *
 *  kCATransitionFromRight;      同字面意思(下同)
 *  kCATransitionFromLeft;
 *  kCATransitionFromTop;
 *  kCATransitionFromBottom;
 *
 
 ** subtype
 *
 *  当type为@"rotate"(旋转)的时候,它也有几个对应的subtype,分别为:
 *  90cw    逆时针旋转90°
 *  90ccw   顺时针旋转90°
 *  180cw   逆时针旋转180°
 *  180ccw  顺时针旋转180°
 *
 
 **
 *  type与subtype的对应关系(必看),如果对应错误,动画不会显现.
 *
 *  @see http://iphonedevwiki.net/index.php/CATransition
 *
 
 animation.subtype = subType;
 */

@interface UINavigationController (telen)

//提供4组动画
- (void)pushViewController: (UIViewController*)controller animatedWithTransition: (UIViewAnimationTransition)transition;
- (UIViewController*)popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)transition;

//提供更多动画效果
- (void)pushViewController:(UIViewController*)controller animatedType:(NSString*)AniType subType:(NSString*)AniSubType;
- (UIViewController*)popViewControllerAnimatedType:(NSString*)AniType subType:(NSString*)AniSubType;

//模拟ios5的效果
- (void)pushViewControllerDefaultAnimation:(UIViewController*)controller;
- (UIViewController*)popViewControllerDefaultAnimation;

//模拟present dismiss效果
- (void)pushViewControllerAnimation_Present:(UIViewController*)controller;
- (UIViewController*)popViewControllerAnimation_Dismiss;
- (NSArray*)popToRootViewControllerAnimated_Dismiss;

//page左侧切入切出
- (void)pushViewControllerAnimation_Page:(UIViewController*)controller;
- (UIViewController*)popViewControllerAnimation_Page;

@end



@interface UINavigationController (TLEdgePanPan)

//把 边缘 右滑返回 系统方式，嫁接到 无边缘要求
- (void)addPanPopGestureRecognizer_once;
- (BOOL)super_gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;

@end

