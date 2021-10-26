//
//  UIImage+ZJImage.m
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import "UIImage+ZJImage.h"
#import "CIImage+ZJCIImage.h"

@implementation UIImage (ZJImage)

+ (UIImage *)imageWithPath:(NSString *)path placehold:(NSString *)placehold {
    UIImage *icon;

    if ([path hasPrefix:@"http:"] || [path hasPrefix:@"https:"]) {
        icon = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:path]]];
    }else {
        icon = [UIImage imageNamed:path];
    }
    if (icon == nil) {
        if (placehold.length == 0) {
            return nil;
        }
        icon = [UIImage imageNamed:placehold];
    }
    
    return icon;
}

+ (UIImage *)imageWithPath:(NSString *)path size:(CGSize)size opaque:(BOOL)opaque {
    return [UIImage imageWithPath:path placehold:@"" size:size opaque:opaque];
}

+ (UIImage *)imageWithPath:(NSString *)path placehold:(NSString *)placehold size:(CGSize)size opaque:(BOOL)opaque {
    UIImage *icon = [UIImage imageWithPath:path placehold:placehold];
    
    // 获得用来处理图片的图形上下文。利用该上下文，你就可以在其上进行绘图，并生成图片 ,三个参数含义是设置大小、透明度 （NO为不透明）、缩放（0代表不缩放）
    UIGraphicsBeginImageContextWithOptions(size, opaque, 0.0);
    CGRect frame = CGRectMake(0.0, 0.0, size.width, size.height);
    [icon drawInRect:frame];
    
    return UIGraphicsGetImageFromCurrentImageContext();
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self createImageWithColor:color frame:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
}

+ (UIImage *)imageWithColor:(UIColor *)color frame:(CGRect)frame {
    return [self createImageWithColor:color frame:frame];
}

+ (UIImage *)createImageWithColor:(UIColor *)color frame:(CGRect)frame {
    UIGraphicsBeginImageContext(frame.size);

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, frame);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - 二维码

+ (CIImage *)imageWithContent:(NSString *)content {
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:data forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    CIImage *qrImage = qrFilter.outputImage;
    return qrImage;
}

+ (UIImage *)qrImageWithContent:(NSString *)content {
    CIImage *qrImage = [UIImage imageWithContent:content];
    return [qrImage image];
}

void ProviderReleaseData (void *info, const void *data, size_t size) {
    free((void*)data);
}

+ (UIImage *)qrImageWithContent:(NSString *)content size:(CGFloat)size red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue {
    UIImage *image = [UIImage qrImageWithContent:content];
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,  kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900)    // 将白色变成透明
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }
        else
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // 输出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

+ (UIImage *)qrImageWithContent:(NSString *)content logo:(UIImage *)logo size:(CGFloat)size red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue {
    UIImage* resultUIImage = [self qrImageWithContent:content size:size red:red green:green blue:blue];
    
    // 添加logo
    CGFloat logoW = resultUIImage.size.width / 5.;
    CGRect logoFrame = CGRectMake(logoW * 2, logoW * 2, logoW, logoW);
    UIGraphicsBeginImageContext(resultUIImage.size);
    [resultUIImage drawInRect:CGRectMake(0, 0, resultUIImage.size.width, resultUIImage.size.height)];
    [logo drawInRect:logoFrame];
    UIImage *kk = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return kk;
}

@end
