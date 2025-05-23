//
//  ZJCATransform3DViewController.h
//  ZJCoreAnimation
//
//  Created by YunTu on 10/8/15.
//  Copyright © 2015 YunTu. All rights reserved.
//

#import "ZJViewController.h"

typedef NS_ENUM(NSUInteger, TransformDType) {
    Transform3DTranslate,   // 平移
    Transform3DScale,       // 缩放
    Transform3DPerspect,    // 正交投影
    Transform3DRotate       // 旋转
};

@interface ZJCATransform3DViewController : ZJViewController

@property (nonatomic, assign) TransformDType transformType;

@end
