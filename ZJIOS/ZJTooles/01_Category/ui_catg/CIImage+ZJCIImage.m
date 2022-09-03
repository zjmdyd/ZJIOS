//
//  CIImage+ZJCIImage.m
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import "CIImage+ZJCIImage.h"

@implementation CIImage (ZJCIImage)

- (UIImage *)image {
    CGSize size = CGSizeMake(300, 300);
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:self fromRect:self.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1, -1);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    
    return codeImage;
}

@end
