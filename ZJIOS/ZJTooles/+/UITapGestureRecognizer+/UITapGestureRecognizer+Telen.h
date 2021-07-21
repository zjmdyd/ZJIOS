//
//  UITapGestureRecognizer+Telen.h
//  KidReading
//
//  Created by telen on 16/2/1.
//  Copyright © 2016年 Creative Knowledge Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITapGestureRecognizer(Telen)
@property(nonatomic,strong)UIColor * rippleColor; //光圈颜色

- (void)addTapRipple;//添加点击光圈

@end
