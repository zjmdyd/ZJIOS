//
//  UIImageView+ZJImageView.h
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (ZJImageView)

+ (UIImageView *)imageViewWithFrame:(CGRect)frame path:(NSString *)path;
+ (UIImageView *)imageViewWithFrame:(CGRect)frame path:(NSString *)path placehold:(NSString *)placehold;
- (void)setImageWithPath:(NSString *)path placehold:(NSString *)placehold;

@end

NS_ASSUME_NONNULL_END
