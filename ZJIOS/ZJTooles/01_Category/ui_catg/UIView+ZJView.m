//
//  UIView+ZJView.m
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import "UIView+ZJView.h"
#import "UIColor+ZJColor.h"
#import "UIImageView+ZJImageView.h"

#define tapEvent @"tapEvent:"

@implementation UIView (ZJView)

+ (UIView *)maskViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor maskViewColor];
    view.alpha = 0.4;
    
    return view;
}

- (UIView *)subViewWithTag:(NSInteger)tag {
    for (UIView *view in self.subviews) {
        if (view.tag == tag) {
            return view;
        }
    }
    
    return nil;
}

- (NSString *)stringWithCount:(int)count {
    NSMutableString *str = [[NSMutableString alloc] init];
    for (int i = 0; i < count; i++) {
        [str appendString:@"-"];
    }
    
    return str;
}

- (UIView *)fetchSubViewWithClassName:(NSString *)className {
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(className)]) {
            return view;
        }else {
            UIView *backView = [view fetchSubViewWithClassName:className];
            if ([backView isKindOfClass:NSClassFromString(className)]) {
                return backView;
            }
        }
    }
    
    return nil;
}

- (UIView *)fetchSuperViewWithClassName:(NSString *)className {
    if (self.superview) {
        if ([self.superview isKindOfClass:NSClassFromString(className)]) {
            return self.superview;
        }else {
            UIView *backView = [self.superview fetchSuperViewWithClassName:className];
            if ([backView isKindOfClass:NSClassFromString(className)]) {
                return backView;
            }
        }
    }
    
    return nil;
}

+ (UIView *)createViewWithNibName:(NSString *)name {
    return [[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil].firstObject;
}

- (void)logSubViews {
    for (UIView *view in self.subviews) {
        NSLog(@"view = %@", view);
        [view logSubViews];
    }
    NSLog(@"\n\n");
}

- (void)removeAllSubViews {
    for (UIView *sView in self.subviews) {
        [sView removeFromSuperview];
    }
}

- (UITapGestureRecognizer *)addTapGestureWithDelegate:(id <UIGestureRecognizerDelegate>)delegate target:(id)target {
    SEL s = NSSelectorFromString(tapEvent);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:s];
    tap.delegate = delegate;
    [self addGestureRecognizer:tap];
    
    return tap;
}

#pragma mark - supplementView

- (void)addIconBadgeWithImage:(UIImage *)image {
    [self createImageViewWithImage:image bgColor:nil];
}

- (void)addIconBadgeWithImage:(UIImage *)image bgColor:(UIColor *)color {
    [self createImageViewWithImage:image bgColor:color];
}

- (void)createImageViewWithImage:(UIImage *)image bgColor:(UIColor *)color {
    CGFloat width = 15;
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-10, 0, width, width)];
    iv.image = image;
    if (color) {
        iv.backgroundColor = color;
    }
    iv.layer.cornerRadius = width / 2;
    iv.layer.masksToBounds = YES;
    
    [self addSubview:iv];
}

+ (UIView *)createTitleIVWithFrame:(CGRect)frame path:(NSString *)path placehold:(NSString *)placehold title:(NSString *)title {
    UIView *view = [[UIView alloc] initWithFrame:frame];

    CGFloat height = view.frame.size.height, width = view.frame.size.width;
    
    UIImageView *iv = [UIImageView imageViewWithFrame:frame path:path placehold:placehold];
    [view addSubview:iv];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x + iv.frame.size.width+4, 2.5, width-iv.frame.size.width-4, height-5)];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
    
    return view;
}

@end
