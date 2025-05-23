//
//  ZJWriteView.h
//  ZJDraw
//
//  Created by YunTu on 15/3/16.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJWriteView : UIView

//用来设置线条的颜色
@property (nonatomic, strong) UIColor *color;

//用来设置线条的宽度
@property (nonatomic, assign) CGFloat lineWidth;

//用来记录已有线条
@property (nonatomic, strong) NSMutableArray *allLine;

//初始化相关参数
- (void)initMyView;

//unDo操作
- (void)backImage;

//reDo操作
- (void)forwardImage;

//clean操作
- (void)cleanImage;

@end
