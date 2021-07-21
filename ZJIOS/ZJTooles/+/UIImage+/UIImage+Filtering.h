//
//  UIImage+Filters.h
//  NYXImagesKit
//
//  Created by @Nyx0uf on 02/05/11.
//  Copyright 2012 Nyx0uf. All rights reserved.
//  www.cocoaintheshell.com
//


#import "NYXImagesHelper.h"


@interface UIImage (NYX_Filtering)

-(UIImage*)brightenWithValue:(float)factor;//发亮

-(UIImage*)contrastAdjustmentWithValue:(float)value;//对比度

-(UIImage*)edgeDetectionWithBias:(NSInteger)bias;//边缘纹路

-(UIImage*)embossWithBias:(NSInteger)bias;//浮雕纹路

-(UIImage*)gammaCorrectionWithValue:(float)value;//Gamma修正 显示差

-(UIImage*)grayscale;//灰度级图片

-(UIImage*)invert;//反转颜色

-(UIImage*)opacity:(float)value;//透明度

-(UIImage*)sepia;//乌贼墨红色调

-(UIImage*)sharpenWithBias:(NSInteger)bias;//锐化，加重

-(UIImage*)unsharpenWithBias:(NSInteger)bias;

@end
