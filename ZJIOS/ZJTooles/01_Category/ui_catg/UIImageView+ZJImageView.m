//
//  UIImageView+ZJImageView.m
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import "UIImageView+ZJImageView.h"
#import "UIImage+ZJImage.h"

@implementation UIImageView (ZJImageView)

+ (UIImageView *)imageViewWithFrame:(CGRect)frame path:(NSString *)path {
    return [self imageViewWithFrame:frame path:path placehold:@""];
}

+ (UIImageView *)imageViewWithFrame:(CGRect)frame path:(NSString *)path placehold:(NSString *)placehold {
    UIImageView *iv = [[self alloc] initWithFrame:frame];
    iv.clipsToBounds = YES;
    iv.contentMode = UIViewContentModeScaleAspectFill;
    [iv setImageWithPath:path placehold:placehold];
    
    return iv;
}

- (void)setImageWithPath:(NSString *)path placehold:(NSString *)placehold {
    if (!placehold) {
        placehold = @"";
    }
    if (!path.length) {
        path = placehold;
    }
    
    if ([path hasPrefix:@"http:"] || [path hasPrefix:@"https:"]) {
#ifdef ZJSDWebImage
        [self sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:placehold.length ? [UIImage imageNamed:placehold] : nil options:SDWebImageRefreshCached];
#else
        self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:path]]];
#endif
    }else {
        self.image = [UIImage imageWithPath:path placehold:placehold];
    }
}

@end
