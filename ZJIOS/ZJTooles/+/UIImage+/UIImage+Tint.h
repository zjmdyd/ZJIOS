//
//  UIImage+Tint.h
//  remind
//
//  Created by Telen on 14-10-13.
//  Copyright (c) 2014年 Telen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tint)

- (UIImage *) imageWithTintColor:(UIColor *)tintColor;
- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;

//--
-(UIImage *)colorWithColor:(UIColor *)theColor;//基于白色
-(UIImage *)maskWithImage2:(UIImage *)theMaskImage;
-(UIImage*)changeUicolor:(UIColor*)color toUicolor:(UIColor*)clr;//替换指定的RGB色
-(UIImage*)changeAllColo_RGB_toUicolor:(UIColor*)clr;//将所有颜色至为这个颜色，透明的除外
//
-(UIImage*)alphaEdgeWithPx:(NSInteger)edge;//将边沿

+ (UIImage *) setImage:(UIImage *)image withAlpha:(CGFloat)alpha;//设置图片透明度 （未验证使用）
+ (UIImage *) changeImage:(UIImage *)image allColo_RGB_toUicolor:(UIColor*)clr;
//
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;//设置图片透明度

@end
