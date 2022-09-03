//
//  ZJTabBar.m
//  HeLiCommunity
//
//  Created by ZJ on 2019/7/10.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJTabBar.h"

@implementation ZJTabBar

- (instancetype)initWithImageName:(NSString *)imgName {
    self = [super init];
    if (self) {
        [self initView:imgName];
    }
    
    return self;
}

- (void)initView:(NSString *)imgName {
    self.centerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //
    UIImage *img = [UIImage imageNamed:imgName];    // @"b-tab-41"
    self.centerBtn.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    
    
    [self.centerBtn setImage:img forState:UIControlStateNormal];
    self.centerBtn.tintColor = [UIColor whiteColor];
    self.centerBtn.backgroundColor = [UIColor mainColor];
    self.centerBtn.layer.cornerRadius = self.centerBtn.frame.size.width/2;
    self.centerBtn.layer.borderWidth = 3;
    self.centerBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    // 去除选择时高亮
    self.centerBtn.adjustsImageWhenHighlighted = NO;
    
    // 根据图片调整button的位置(图片中心在tabbar的中间最上部，这个时候由于按钮是有一部分超出tabbar的，所以点击无效，要进行处理)
    self.centerBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - img.size.width)/2.0, - img.size.height/2.0, img.size.width, img.size.height);
    [self addSubview:self.centerBtn];
}

//处理超出区域点击无效的问题
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.hidden) {
        return nil;
    }
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        //转换坐标
        CGPoint tempPoint = [self.centerBtn convertPoint:point fromView:self];
        //判断点击的点是否在按钮区域内
        if (CGRectContainsPoint(self.centerBtn.bounds, tempPoint)){
            // 返回按钮
            return self.centerBtn;
        }
    }
    return view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
