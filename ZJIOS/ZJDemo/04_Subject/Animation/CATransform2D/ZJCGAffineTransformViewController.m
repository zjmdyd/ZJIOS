//
//  ZJCGAffineTransformViewController.m
//  ZJCoreAnimation
//
//  Created by YunTu on 15/7/23.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ZJCGAffineTransformViewController.h"

@interface ZJCGAffineTransformViewController ()

@property (weak, nonatomic) IBOutlet UIView *frontView;
@property (strong, nonatomic) IBOutletCollection(UISlider) NSArray *sliders;

@end

@implementation ZJCGAffineTransformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", NSStringFromCGAffineTransform(self.frontView.transform));
    [UIView animateWithDuration:2 animations:^{
        self.frontView.transform = CGAffineTransformMakeRotation(M_PI);
    }];
    /*
     CGAffineTransform使用方法:
     */
#if 1
#ifdef Method1
    //方法1:
    self.frontView.transform = CGAffineTransformMakeRotation(M_PI/6);   // 弧度数, pi/6 顺时针
    
#else
    //方法2
//    self.frontView.transform = CGAffineTransformRotate(self.frontView.transform, M_PI/6);
#endif
    
#else
    // A point that specifies the x- and y-coordinates to transform.
    // Returns the point resulting from an affine transformation of an existing point.
    CGPointApplyAffineTransform(CGPointMake(0, 0), self.frontView.transform);   // CGPointApplyAffineTransform //把变化应用到一个点上
    
    CGRectApplyAffineTransform(CGRectMake(0, 0, 100, 100), CGAffineTransformMakeRotation(M_PI/3));
    
#endif
    /*
     CTM:the current graphics state's transformation matrix
     */
}
/*
 仿射矩阵:将原坐标[x, y, 1] 转换为[x', y', 1]
 即:[x', y', 1] = [x, y, 1] x 仿射矩阵
 注意:仿射矩阵并不代表点的坐标，只是代表了一个转换关系，是一个转换矩阵而已
 struct CGAffineTransform {
 CGFloat a, b, c, d;
 CGFloat tx, ty;
 };
 
 __         __
 |  a  b  0  |
 |  c  d  0  |
 |  tx ty 1  |
 --         --
 
 一个视图的原始transform = CGAffineTransformIdentity : [1, 0, 0, 1, 0, 0]
 __      __
 |  1 0 0 |
 |  0 1 0 |
 |  0 0 1 |
 --      --
 */

- (IBAction)sliderEvent:(UISlider *)sender {
    if (sender.tag < 2) {       // Translation
        self.frontView.transform = CGAffineTransformMakeTranslation(((UISlider *)self.sliders[0]).value,
                                                                    ((UISlider *)self.sliders[1]).value);
    }else if (sender.tag < 4) { // Scale
        self.frontView.transform = CGAffineTransformMakeScale(((UISlider *)self.sliders[2]).value,
                                                              ((UISlider *)self.sliders[3]).value);
    }else {                     // Rotation
        // 默认会从初始状态开始改变transform的方法
        self.frontView.transform = CGAffineTransformMakeRotation(pow(-1, sender.tag)*sender.value/180 * M_PI);
    
        /*
          **    默认不会从初始状态开始改变transform的方法(会在上一次改变的基础上进行改变,所以每次在改变transform之前要进行还原)
          */
    //        self.frontView.transform = CGAffineTransformIdentity;
    //        self.frontView.transform = CGAffineTransformRotate(self.frontView.transform, sender.value/180 * M_PI);
    }
}

- (IBAction)resetEvent:(UIButton *)sender {
    self.frontView.transform = CGAffineTransformIdentity;
    for (UISlider *slider in self.sliders) {
        slider.value = (slider.maximumValue + slider.minimumValue) / 2;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
