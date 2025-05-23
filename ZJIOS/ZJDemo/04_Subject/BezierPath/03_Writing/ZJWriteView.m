//
//  ZJWriteView.m
//  ZJDraw
//
//  Created by YunTu on 15/3/16.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ZJWriteView.h"

@interface ZJWriteView ()

//声明贝塞尔曲线
@property(nonatomic, strong) UIBezierPath *bezier;

//存储Undo出来的线条
@property(nonatomic, strong) NSMutableArray *cancleArray;

@end

@implementation ZJWriteView

- (void)initMyView {
    self.color = [UIColor redColor];
    self.lineWidth = 1;
    self.allLine = [NSMutableArray arrayWithCapacity:50];
    self.cancleArray = [NSMutableArray arrayWithCapacity:50];
}

/*
    Undo功能的封装，相当于两个栈，把显示的线条出栈，进入为不显示的线条栈中，每执行一次此操作显示线条栈中的元素会少一条而不显示线条栈中会多一条
 */
- (void)backImage {
    if (self.allLine.count > 0) {
        NSInteger index = self.allLine.count - 1;
        
        [self.cancleArray addObject:self.allLine[index]];
        
        [self.allLine removeObjectAtIndex:index];
        
        [self setNeedsDisplay];
    }
}

/*
 Redo操作和Undo操作相反，从未显示栈中取出元素放入显示的栈中
 */
- (void)forwardImage {
    if (self.cancleArray.count > 0) {
        NSInteger index = self.cancleArray.count - 1;
        
        [self.allLine addObject:self.cancleArray[index]];
        
        [self.cancleArray removeObjectAtIndex:index];
        
        [self setNeedsDisplay];
    }
}

/*
 彻底清除
 */
- (void)cleanImage {
    [self.allLine removeAllObjects];
    [self.cancleArray removeAllObjects];
    [self setNeedsDisplay];
}

/*
 当开始触摸时我们新建一个BezierPath,把触摸起点设置成BezierPath的起点，并把将要画出的线条以及线条对应的属性封装成字典添加到显示栈中
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //新建贝塞斯曲线
    self.bezier = [UIBezierPath bezierPath];    //每一次都创建一条新曲线
    
    //获取触摸的点
    UITouch *myTouche = [touches anyObject];
    CGPoint point = [myTouche locationInView:self];
    
    //把刚触摸的点设置为bezier的起点
    [self.bezier moveToPoint:point];
    
    //把每条线存入字典中
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:3];
    [tempDic setObject:self.color forKey:@"color"];
    [tempDic setObject:[NSNumber numberWithFloat:self.lineWidth] forKey:@"lineWidth"];
    [tempDic setObject:self.bezier forKey:@"line"];
    
    //把线加入数组中
    [self.allLine addObject:tempDic];
}

/*
    当移动也就是划线的时候把点存储到BezierPath中
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *myTouche = [touches anyObject];
    CGPoint point = [myTouche locationInView:self];
    
    [self.bezier addLineToPoint:point];
    
    //重绘界面
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    for (int i = 0; i < self.allLine.count; i ++) {
        NSDictionary *tempDic = self.allLine[i];
        UIColor *color = tempDic[@"color"];
        CGFloat width = [tempDic[@"lineWidth"] floatValue];
        UIBezierPath *path = tempDic[@"line"];
        
        [color setStroke];
        [path setLineWidth:width];
        [path stroke];
    }
}


@end
