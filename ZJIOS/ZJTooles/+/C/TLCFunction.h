//
//  TLCFunction.h
//  KidReading
//
//  Created by telen on 16/3/17.
//  Copyright © 2016年 Creative Knowledge Ltd. All rights reserved.
//

#ifndef TLCFunction_h
#define TLCFunction_h

#import <UIKit/UIKit.h>

static inline CGRect //CG_INLINE
TLRectMakeOriginSize(CGPoint origin, CGSize size)
{
    CGRect rect;
    rect.origin = origin;
    rect.size = size;
    return rect;
}

static inline CGRect //CG_INLINE
TLRectMakeCenterSize(CGPoint center, CGSize size)
{
    CGRect rect;
    rect.origin = CGPointMake(center.x-size.width*0.5, center.y-size.height*0.5);
    rect.size = size;
    return rect;
}

static inline CGRect //CG_INLINE
TLRectMakeTLSize(CGPoint topLeft, CGSize size)
{
    return TLRectMakeOriginSize(topLeft, size);
}

static inline CGRect //CG_INLINE
TLRectMakeBLSize(CGPoint bottomLeft, CGSize size)
{
    CGRect rect;
    rect.origin = CGPointMake(bottomLeft.x, bottomLeft.y-size.height);
    rect.size = size;
    return rect;
}

static inline CGRect //CG_INLINE
TLRectMakeTRSize(CGPoint topRight, CGSize size)
{
    CGRect rect;
    rect.origin = CGPointMake(topRight.x-size.width, topRight.y);
    rect.size = size;
    return rect;
}

static inline CGRect //CG_INLINE
TLRectMakeBRSize(CGPoint bottomRight, CGSize size)
{
    CGRect rect;
    rect.origin = CGPointMake(bottomRight.x-size.width, bottomRight.y-size.height);
    rect.size = size;
    return rect;
}

static inline CGRect //CG_INLINE
TLRectMakePointToPoint(CGPoint pt1, CGPoint pt2)
{
    CGRect rect;
    rect.origin = CGPointMake(MIN(pt1.x, pt2.x), MIN(pt1.y, pt2.y));
    rect.size = CGSizeMake(fabs(pt1.x-pt2.x), fabs(pt1.y-pt2.y));
    return rect;
}

static inline CGRect //CG_INLINE
TLRectMakeOriginCenter(CGPoint origin, CGPoint center)
{
    CGRect rect;
    CGPoint pt1 = origin;
    CGPoint pt2 = center;
    rect.origin = CGPointMake(MIN(pt1.x, pt2.x*2-pt1.x), MIN(pt1.y, pt2.y*2-pt1.y));
    rect.size = CGSizeMake(fabs(pt1.x-pt2.x)*2, fabs(pt1.y-pt2.y)*2);
    return rect;
}

#pragma mark- Fucntion MSG
//类名，类方法，方法传参，是否需要返回值
id tl_oc_msgToClass(NSString * className ,NSString *menthed ,NSArray* refArr ,BOOL retNeed);
//对象，对象方法，方法传参，是否需要返回值
id tl_oc_msgToTarget(id target ,NSString *menthed ,NSArray* refArr ,BOOL retNeed);
//非对象传参
id tl_oc_msgToTarget_ref(id target ,NSString *menthed ,void* ref,BOOL retNeed);

#endif /* TLCFunction_h */
