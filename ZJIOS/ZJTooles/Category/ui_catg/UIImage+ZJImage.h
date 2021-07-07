//
//  UIImage+ZJImage.h
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZJImage)

+ (UIImage *)imageWithPath:(NSString *)path placehold:(NSString *)placehold;
+ (UIImage *)imageWithPath:(NSString *)path size:(CGSize)size opaque:(BOOL)opaque;
+ (UIImage *)imageWithPath:(NSString *)path placehold:(NSString *)placehold size:(CGSize)size opaque:(BOOL)opaque;

/**
 *  根据颜色获取UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  根据颜色获取UIImage
 *  @param frame  特定区域着色
 */
+ (UIImage *)imageWithColor:(UIColor *)color frame:(CGRect)frame;

#pragma mark - 生成二维码

+ (UIImage *)qrImageWithContent:(NSString *)content;

/**
 *   色值 0~255
 */
+ (UIImage *)qrImageWithContent:(NSString *)content size:(CGFloat)size red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

+ (UIImage *)qrImageWithContent:(NSString *)content logo:(UIImage *)logo size:(CGFloat)size red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

@end

NS_ASSUME_NONNULL_END
