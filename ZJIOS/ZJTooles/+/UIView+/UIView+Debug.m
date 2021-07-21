//
//  UIView+Debug.h
//
//  Created by Telen on 29/08/14.
//  Copyright (c) 2014 Telen. All rights reserved.
//

#import "UIView+Debug.h"
#import "NSObject+Telen.h"
#import <objc/runtime.h>

@implementation UIView (Debug)

- (UIColor *)color_Debug_View
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setColor_Debug_View:(UIColor *)color
{
    objc_setAssociatedObject(self, @selector(color_Debug_View), color, OBJC_ASSOCIATION_RETAIN);
#ifdef Debug_View_On
    self.layer.borderColor = color.CGColor;
#endif
}

- (void)removeAllSubViews
{
    NSArray* arr = self.subviews;
    for (UIView* v in arr) {
        [v removeFromSuperview];
    }
}

#ifdef Debug_View_On
+(void)load{
    [self swizzleSelector:@selector(init) withSelector:@selector(init_debug)];
    [self swizzleSelector:@selector(awakeFromNib) withSelector:@selector(awakeFromNib_debug)];
    [self swizzleSelector:@selector(initWithFrame:) withSelector:@selector(initWithFrame_debug:)];
}
#endif

-(id)init_debug{
    
    self = [self init_debug];
    [self addBorders];
    return self;
}


-(void)awakeFromNib_debug{
    [self addBorders];
}

-(id)initWithFrame_debug:(CGRect)frame{
    self = [self initWithFrame_debug:frame];
    [self addBorders];
    return self;
}

-(void)addBorders{
    self.layer.borderColor = [UIColor redColor].CGColor;
    self.layer.borderWidth = 1.0;
}

+ (id)viewFromNibByDefaultClassName:(id)owner option:(NSDictionary*)dic
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:owner options:dic]lastObject];
}

+ (UIView *)dotWithFrame:(CGRect) frame {
    //height width == 8
    UIView * dotView = [[UIView alloc] initWithFrame:frame];
    dotView.backgroundColor = [UIColor redColor];
    dotView.layer.cornerRadius = 4;
    dotView.layer.masksToBounds = YES;
    return dotView;
}

@end


@implementation UIImageView (TLRunTime)
- (void)dealloc_TLRunTime
{
    self.image = nil;
    [self dealloc_TLRunTime];
}
+(void)load{
    [self swizzleSelector:NSSelectorFromString(@"dealloc") withSelector:@selector(dealloc_TLRunTime)];
}
@end
