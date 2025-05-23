//
//  ZJFlipAnimationViewController.m
//  FlipAnimation
//
//  Created by YunTu on 15/3/17.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ZJFlipAnimationViewController.h"
#import "UIViewExt.h"

@interface ZJFlipAnimationViewController (){
    NSArray *_bgImgs;
    NSArray *_fgImgs;
    NSMutableArray *_btnAry;
}

@end

#define kDuration 0.7   // 动画持续时间(秒)

@implementation ZJFlipAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"翻转动画";
    _fgImgs = [NSArray arrayWithObjects:@"fg1", @"fg2", @"fg3", @"fg4", @"fg5", @"fg6", nil];
    _bgImgs = [NSArray arrayWithObjects:@"bg1", @"bg2", @"bg3", @"bg4", @"bg5", @"bg6", nil];
    _btnAry = [NSMutableArray array];
    
    CGFloat width = (self.view.width) * 0.5;
    CGFloat height = (self.view.height-64) / 3;
    for (int i = 0; i < _fgImgs.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(width*(i%2), 64 + height*(i/2), width, height)];
        btn.contentMode = UIViewContentModeScaleAspectFit;
        btn.tag = i;
        btn.backgroundColor = [UIColor orangeColor];
        btn.layer.borderWidth = 1.0;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [btn addTarget:self action:@selector(flipAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:_fgImgs[i]] forState:UIControlStateNormal];
        [_btnAry addObject:[NSNumber numberWithInt:0]];
        [self.view addSubview:btn];
    }
}

- (void)flipAction:(UIButton *)sender {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:kDuration];
    
    if ([_btnAry[sender.tag] intValue] == 0) {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:sender cache:YES];  //左翻转
        [sender setBackgroundImage:[UIImage imageNamed:_bgImgs[sender.tag]] forState:UIControlStateNormal];
        [_btnAry replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithInt:1]];
    }else {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:sender cache:YES]; //右翻转
        [sender setBackgroundImage:[UIImage imageNamed:_fgImgs[sender.tag]] forState:UIControlStateNormal];
        [_btnAry replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithInt:0]];
    }
    
    [UIView setAnimationDelegate:self];

    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
