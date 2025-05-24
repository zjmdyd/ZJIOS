//
//  ZJScaleReplicatorViewController.m
//  TestCategory
//
//  Created by ZJ on 18/10/2017.
//  Copyright © 2017 ZJ. All rights reserved.
//

#import "ZJScaleReplicatorViewController.h"
#import "ZJDefine.h"

@interface ZJScaleReplicatorViewController () {
//    UIView *_animationView;
}

@end

@implementation ZJScaleReplicatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self startAnimation];
}

- (void)startAnimation {
    //
    UIView *animationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 200)];
    animationView.center = self.view.center;
    animationView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:animationView];
    
    //
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    [animationView.layer addSublayer:replicatorLayer];

    //
    replicatorLayer.instanceCount = 3;
    replicatorLayer.instanceDelay = .3;
    
    // 动画图层,就是不停变大的那个圆
    CALayer *animationLayer = [CALayer layer];
    animationLayer.bounds = CGRectMake(0, 0, 20, 20);
    animationLayer.backgroundColor = [UIColor redColor].CGColor;
    animationLayer.cornerRadius = 10;
    animationLayer.position = CGPointMake(kScreenW/2, 100);
    [replicatorLayer addSublayer:animationLayer];
    
    // 放大动画
    CABasicAnimation *transformAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D transform = CATransform3DMakeScale(10, 10, 1);
    NSValue *value = [NSValue valueWithBytes:&transform objCType:@encode(CATransform3D)];
    transformAnim.toValue = value;
    
    // 透明度动画 (其实也可以直接设置CAReplicatorLayer的instanceAlphaOffset来实现)
    CABasicAnimation *alphaAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnim.toValue = @0; // （0表示完全透明，1表示完全不透明）
    
    //
    CAAnimationGroup *animGroup = [[CAAnimationGroup alloc] init];
    animGroup.animations = @[transformAnim, alphaAnim];
    animGroup.duration = 2;
    animGroup.repeatCount = HUGE;
    [animationLayer addAnimation:animGroup forKey:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
