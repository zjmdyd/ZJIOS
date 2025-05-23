//
//  ZJFrameBoundsViewController.m
//  ZJFrame_Bounds
//
//  Created by YunTu on 15/5/13.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ZJFrameBoundsViewController.h"

@interface ZJFrameBoundsViewController (){
    UIView *_subView;
    NSTimer *_timer;
}

@end

@implementation ZJFrameBoundsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
        frame: 该view在父view坐标系统中的位置和大小。（参照点是，父亲的坐标系统）
        bounds：该view在本地坐标系统中的位置和大小。（参照点是，本地坐标系统，就相当于ViewB自己的坐标系统，以0,0点为起点）
        center：该view的中心点在父view坐标系统中的位置和大小。（参照点是，父亲的坐标系统）
     */
    
    NSLog(@"leftBarButtonItem.customView.frame = %@", NSStringFromCGRect(self.navigationItem.leftBarButtonItem.customView.frame));
    // navi的背景图片会覆盖状态栏所以navi背景图片的大小应该为320*64(ip5/s) 虽然naviBar的size是(320, 44)
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"red"] forBarMetrics:UIBarMetricsDefault];
    
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(200, 150, 100, 100)];
    blueView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:blueView];
    
    UIView *orangeView = [[UIView alloc] initWithFrame:CGRectMake(200, 250, 100, 100)];
    orangeView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:orangeView];
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(50, 250, 100, 100)];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    
    CGRect bounds = redView.bounds;
    bounds.origin = CGPointMake(30, 30);
    bounds.size = CGSizeMake(150, 300);
    redView.bounds = bounds;
    /*
        setBounds的作用是：
            1. origin变化
                强制将自己（view）坐标系的左上角点，改为（30，30）。那么当_subView的原点为(0, 0)，自然就向在上偏移（30，30）。
            2. size变化
                将自己宽高均匀拉伸(上下左右均匀拉伸)
     
            frame定义了一个相对父视图的一个框架（容器），bounds则是真实显示区域。如果，bounds比frame小了，可以放到框架（容器）里。
            如果bounds比frame大，感觉frame被“撑大”了。bounds比frame宽大了50，高大了200像素，那么四条边平衡一下，宽溢出“25”像素，高溢出100像素。所以y轴和blueView相同
     
        bounds的有以下两个特点：
     
        1. 它可以修改自己坐标系的原点位置，进而影想到“子view”的显示位置。这个作用更像是移动原点的意思。
     
        2. bounds，它可以改变的frame。如果bounds比frame大。那么frame也会跟着变大。这个作用更像边界和大小的意思。
     */
    
    _subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 300)];
    _subView.backgroundColor = [UIColor greenColor];
    [redView addSubview:_subView];
    
    [UIView animateWithDuration:5 animations:^{
        CGRect frame = self->_subView.frame;
        frame.origin.x = 100;
        self->_subView.frame = frame;

    } completion:^(BOOL finished) {
        NSLog(@"\nredView.frame = %@\nredView.bounds = %@", NSStringFromCGRect(redView.frame), NSStringFromCGRect(redView.bounds));
        [self->_timer invalidate];
    }];

   _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showFrame) userInfo:nil repeats:YES];
}

// 实时输出Frame
- (void)showFrame {
    NSLog(@"_subView.frame = %@", NSStringFromCGRect([[_subView.layer presentationLayer] frame]));
    //    NSLog(@"_subView.frame = %@", NSStringFromCGRect(_subView.frame)); // 不能实时输出frame
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
