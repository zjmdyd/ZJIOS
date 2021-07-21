//
//  UIWindow+Telen.h
//  ccc
//
//  Created by Telen on 2017/3/11.
//  Copyright © 2017年 Telen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (Telen)
@property(nonatomic,assign)UIInterfaceOrientationMask defaultRotation; //UIInterfaceOrientationMaskAllButUpsideDown
@property(nonatomic,assign)UIInterfaceOrientationMask rotation;
@end
