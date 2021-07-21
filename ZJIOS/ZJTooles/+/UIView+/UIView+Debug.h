//
//  UIView+Debug.h
//
//  Created by Telen on 29/08/14.
//  Copyright (c) 2014 Telen. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define Debug_View_On //定义表示开启Debug

#define notNULL(a) (![(a) isKindOfClass:[NSNull class]])
#define nullToNil(a) if (!notNULL(a)){a = nil;}

@interface UIView (Debug)
@property(nonatomic,strong)UIColor* color_Debug_View;
- (void)removeAllSubViews;
+ (id)viewFromNibByDefaultClassName:(id)owner option:(NSDictionary*)dic;

+ (UIView *)dotWithFrame:(CGRect) frame;
@end

//解决部分设备，不释放 image的问题
@interface UIImageView(TLRunTime)

@end
