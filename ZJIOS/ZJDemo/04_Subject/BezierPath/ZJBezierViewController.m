//
//  ZJBezierViewController.m
//  ZJBezier
//
//  Created by YunTu on 15/3/13.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ZJBezierViewController.h"
#import "UIViewExt.h"
#import "ZJPathView.h"

@interface ZJBezierViewController () {
    ZJPathView *_zjView;
    UIBezierPath *_bPath;
    NSInteger _clickNum;
    UIButton *_btn;
}

@end

@implementation ZJBezierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _zjView = [[ZJPathView alloc] initWithFrame:CGRectMake(10, 100, 300, 300)];
    _zjView.centerPoint = CGPointMake(_zjView.width*0.5, _zjView.height*0.5);
    _zjView.startAngle = -M_PI_2;
    _zjView.endAngle = 0;
    _zjView.backgroundColor = [UIColor lightGrayColor];
    _zjView.layer.masksToBounds = YES;
    [self.view addSubview:_zjView];
    
    _btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 120, 60)];
    _btn.center = CGPointMake(self.view.width * 0.5, _zjView.bottom+100);
    [_btn setTitle:@"Clean" forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(fillPath:) forControlEvents:UIControlEventTouchUpInside];
    _btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:_btn];
    _btn.layer.borderWidth = 1.0;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_zjView addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan locationInView:_zjView];
    switch ((int)pan.state) {
        case UIGestureRecognizerStateBegan:{
            _bPath = [UIBezierPath bezierPath];
            [_bPath moveToPoint:point];
            _zjView.isFill = NO;
            _clickNum = 0;
            [_btn setTitle:@"Fill" forState:UIControlStateNormal];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            [_bPath addLineToPoint:point];
            _zjView.bPath = _bPath;
            [_zjView setNeedsDisplay];
            break;
        }
        case UIGestureRecognizerStateEnded:{
            break;
        }
    }
}

- (void)fillPath:(UIButton *)sender {
    if (_clickNum % 2 == 0) {   // fill
        _zjView.isFill = YES;
        [_zjView setNeedsDisplay];
        [sender setTitle:@"Clean" forState:UIControlStateNormal];
    }else { // clean
        if (!_bPath) return;
        _zjView.isFill = NO;
        _bPath = nil;
        _zjView.bPath = nil;
        [_zjView setNeedsDisplay];
//        [sender setTitle:@"Fill" forState:UIControlStateNormal];
    }
    _clickNum++;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
