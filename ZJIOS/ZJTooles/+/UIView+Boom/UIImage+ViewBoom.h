//
//  UIImage+ViewBoom.h
//  ViewBoom
//
//  Created by Telen on 16/5/14.
//  Copyright © 2016年 Telen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ViewBoom)

- (UIColor*)getPixelColorAtLocation:(CGPoint)point;
- (UIImage*)scaleImageToSize:(CGSize)size;

@end
