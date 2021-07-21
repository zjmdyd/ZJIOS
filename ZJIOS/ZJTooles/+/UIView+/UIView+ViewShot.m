//
//  UIView+ViewShot.m
//  TakePhotoDemo
//
//  Created by YangShuai on 16/9/2.
//  Copyright © 2016年 ys. All rights reserved.
//

#import "UIView+ViewShot.h"

@implementation UIView (ViewShot)
- (UIImage*)viewShot{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage*)viewShot_clear{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
