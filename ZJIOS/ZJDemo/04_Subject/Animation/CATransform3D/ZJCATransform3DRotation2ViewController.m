//
//  ZJCATransform3DViewController.m
//  ZJCoreAnimation
//
//  Created by YunTu on 10/8/15.
//  Copyright © 2015 YunTu. All rights reserved.
//

#import "ZJCATransform3DRotation2ViewController.h"
#import "UIViewExt.h"
#import "ZJDefine.h"

@interface ZJCATransform3DRotation2ViewController () {
    CATransform3D _temptTransform3D;
}

@property (weak, nonatomic) UIView *frontView;

@property (strong, nonatomic) IBOutletCollection(UISlider) NSArray *sliders;

@end

@implementation ZJCATransform3DRotation2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSetting];
}

- (void)initSetting {
    for (int i = 0; i < 2; i++) {
        CGRect frame = CGRectMake(0, 84, 220, 220);
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.center = CGPointMake(kScreenW/2, view.center.y);
        if (i == 0) {
            view.backgroundColor = [UIColor redColor];
            view.alpha = 0.5;
        }else {
            
#ifdef ChangeAnchorPoint
            frame.origin.x -= frame.size.width / 2;
            frame.origin.y -= frame.size.height / 2;
            view.frame = frame;
            view.layer.anchorPoint = CGPointZero;
#endif
            view.backgroundColor = [UIColor greenColor];
            self.frontView = view;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            label.text = @"Rotation";
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor blueColor];
            label.center = CGPointMake(view.center.x - view.left, view.center.y - view.top);
            [view addSubview:label];
        }
        
        [self.view addSubview:view];
    }
    
    _temptTransform3D = self.frontView.layer.transform;
    
    for (UISlider *slider in self.sliders) {
        slider.minimumValue = -M_PI;
        slider.maximumValue = M_PI;
    }
}

/*
    angle大于0逆时针旋转,小于0顺时针，绕着坐标轴(锚点)旋转
 
    CATransform3D CATransform3DRotate (CATransform3D t, CGFloat angle, CGFloat x, CGFloat y, CGFloat z)
    (x, y, z)确定一个空间向量--->空间坐标轴，绕着此坐标轴旋转
 */


- (IBAction)sliderValueChange:(UISlider *)sender {
//    self.frontView.layer.transform = CATransform3DIdentity;
    if (sender.tag == 0) {
        self.frontView.layer.transform = CATransform3DMakeRotation(sender.value, 1, 1, 0);
    }else if (sender.tag == 1) {
        self.frontView.layer.transform = CATransform3DMakeRotation(sender.value, 1, 0, 1);
    }else if (sender.tag == 2) {
        self.frontView.layer.transform = CATransform3DMakeRotation(sender.value, 0, 1, 1);
    }else if (sender.tag == 3) {
        self.frontView.layer.transform = CATransform3DMakeRotation(sender.value, 1, 1, 1);
    }
    _temptTransform3D = self.frontView.layer.transform;
}

- (IBAction)resetAction:(UIButton *)sender {
    self.frontView.layer.transform = CATransform3DIdentity;
    _temptTransform3D = CATransform3DIdentity;
    
    for (UISlider *slider in self.sliders) {
        slider.value = 0;
    }
}

/*
 if (i == 0) {
 
 }else if (i == 1) {
 view.layer.transform = CATransform3DMakeTranslation(50, 50, 20);
 }else if (i == 2) {
 view.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1);
 
 sx：X轴缩放，代表一个缩放比例，一般都是 0 --- 1 之间的数字。
 sy：Y轴缩放。
 sz：整体比例变换时，也就是m11（sx）== m22（sy）时，若m33（sz）>1，图形整体缩小，若0<1，图形整体放大，若m33（sz）<0，发生关于原点的对称等比变换。
 
 }else if (i == 3) {
 view.layer.transform = CATransform3DMakeRotation(M_PI/6, 0, 1, 0);
 }
 */

/*
 仿射矩阵:将原坐标[x, y, z, 1] 转换为[x', y', z', 1]
 即:[x', y', z', 1] = [x, y, z, 1] x 仿射矩阵
 注意:仿射矩阵并不代表点得坐标，只是代表了一个转换关系，是一个转换矩阵而已
 struct CATransform3D
 {
 CGFloat m11, m12, m13, m14;
 CGFloat m21, m22, m23, m24;
 CGFloat m31, m32, m33, m34;
 CGFloat m41, m42, m43, m44;
 };
 
 一个视图的原始transform = CGAffineTransformIdentity : [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]
 
 struct CATransform3D
 {
 CGFloat m11（x缩放）, m12（y切变）, m13（旋转）, m14（）;
 CGFloat m21（x切变）, m22（y缩放）, m23（）, m24（）;
 CGFloat m31（旋转）, m32（）, m33（）, m34（透视效果，要操作的这个对象要有旋转的角度，否则没有效果。正直/负值都有意义）;
 CGFloat m41（x平移）, m42（y平移）, m43（z平移）, m44（）;
 };
 __          __
 |  1  0  0  0|
 |  0  1  0  0|
 |  0  0  1  0|
 | tx ty tz  1|
 --          --
 */

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
