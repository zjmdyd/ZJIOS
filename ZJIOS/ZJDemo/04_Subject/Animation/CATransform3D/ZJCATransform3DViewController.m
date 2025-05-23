//
//  ZJCATransform3DViewController.m
//  ZJCoreAnimation
//
//  Created by YunTu on 10/8/15.
//  Copyright © 2015 YunTu. All rights reserved.
//

#import "ZJCATransform3DViewController.h"
#import "UIViewExt.h"

@interface ZJCATransform3DViewController () {
    CATransform3D _temptTransform3D;
}

@property (weak, nonatomic) UIView *frontView;

@property (strong, nonatomic) IBOutletCollection(UISlider) NSArray *sliders;

@end

@implementation ZJCATransform3DViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSetting];
}

- (void)initSetting {
    for (int i = 0; i < 2; i++) {
        CGRect frame = CGRectMake((self.view.width - 220 ) / 2, 100, 220, 220);
        UIView *view = [[UIView alloc] initWithFrame:frame];
        if (i == 0) {   // 底部对照view
            view.backgroundColor = [UIColor redColor];
            if (self.transformType == Transform3DPerspect || self.transformType == Transform3DRotate) {
                view.alpha = 0.5;
            }
        }else {
#ifdef ChangeAnchorPoint
            frame.origin.x -= frame.size.width / 2;
            frame.origin.y -= frame.size.height / 2;
            view.frame = frame;
            view.layer.anchorPoint = CGPointZero;
#endif
            view.backgroundColor = [UIColor greenColor];
            self.frontView = view;
            
            if (self.transformType == Transform3DRotate) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
                label.text = @"Rotation";
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor whiteColor];
                label.backgroundColor = [UIColor blueColor];
                label.center = CGPointMake(view.center.x - view.left, view.center.y - view.top);
                [view addSubview:label];
            }
        }
        
        [self.view addSubview:view];
    }
    
    _temptTransform3D = self.frontView.layer.transform;
    
    for (UISlider *slider in self.sliders) {
        if (self.transformType == Transform3DTranslate) {
            slider.minimumValue = -self.frontView.width;
            slider.maximumValue = self.frontView.width;
            
            slider.value = 0;
        }else if (self.transformType == Transform3DScale) {
            slider.minimumValue = 0;
            slider.maximumValue = 2;
            
            slider.value = 1;
        }else if(self.transformType == Transform3DPerspect) {
            slider.minimumValue = -M_PI;
            slider.maximumValue = M_PI;
            
            slider.value = 0;
        } else if (self.transformType == Transform3DRotate) {
            slider.minimumValue = -M_PI;
            slider.maximumValue = M_PI;
            
            slider.value = 0;
        }
    }
}

- (IBAction)sliderValueChange:(UISlider *)sender {
    if (self.transformType == Transform3DTranslate) {   // 平移 t' =  [1 0 0 0; 0 1 0 0; 0 0 1 0; tx ty tz 1]
        if (sender.tag == 0) {
            self.frontView.layer.transform = CATransform3DMakeTranslation(sender.value, _temptTransform3D.m42, _temptTransform3D.m43);
        }else if (sender.tag == 1) {
            self.frontView.layer.transform = CATransform3DMakeTranslation(_temptTransform3D.m41, sender.value, _temptTransform3D.m43);
        }else {
            self.frontView.layer.transform = CATransform3DMakeTranslation(_temptTransform3D.m41, _temptTransform3D.m42, sender.value);
        }
    }else if (self.transformType == Transform3DScale) { // 缩放 t' = [sx 0 0 0; 0 sy 0 0; 0 0 sz 0; 0 0 0 1]
        if (sender.tag == 0) {
            self.frontView.layer.transform = CATransform3DMakeScale(sender.value, _temptTransform3D.m22, _temptTransform3D.m33);
        }else if (sender.tag == 1) {
            self.frontView.layer.transform = CATransform3DMakeScale(_temptTransform3D.m11, sender.value, _temptTransform3D.m33);
        }else {
            self.frontView.layer.transform = CATransform3DMakeScale( _temptTransform3D.m11, _temptTransform3D.m22, sender.value);
        }
    }else if (self.transformType == Transform3DPerspect) {  // 正交投影
        self.frontView.layer.transform = CATransform3DIdentity;
        CATransform3D rotate;
        if (sender.tag == 0) {
            rotate = CATransform3DMakeRotation(sender.value, 1, 0, 0);
        }else if (sender.tag == 1) {
            rotate = CATransform3DMakeRotation(sender.value, 0, 1, 0);
        }else {
            rotate = CATransform3DMakeRotation(sender.value, 0, 0, 1);
        }
        
        self.frontView.layer.transform = CATransform3DPerspect(rotate, CGPointZero, 200);
    }else {
        if (sender.tag == 0) { // angle大于0逆时针旋转,小于0顺时针，绕着坐标轴(锚点)旋转
            self.frontView.layer.transform = CATransform3DMakeRotation(sender.value, 1, 0, 0);
        }else if (sender.tag == 1) {
            self.frontView.layer.transform = CATransform3DMakeRotation(sender.value, 0, 1, 0);// 大于零逆时针旋转
        }else {
            self.frontView.layer.transform = CATransform3DMakeRotation(sender.value, _temptTransform3D.m13, 0, 1);

        }
    }
    /*
     缩放、旋转bounds不会发生改变,frame会改变
     */
    _temptTransform3D = self.frontView.layer.transform;
}

CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ) {
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f / disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}

CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ) {
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ));
}

- (IBAction)resetAction:(UIButton *)sender {
    self.frontView.layer.transform = CATransform3DIdentity;
    _temptTransform3D = CATransform3DIdentity;
    
    for (UISlider *slider in self.sliders) {
        if (self.transformType == Transform3DScale) {
            slider.value = 1;
        }else {
            slider.value = 0;
        }
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
 CGFloat m21（x切变）, m22（y缩放）, m23（）,     m24（）;
 CGFloat m31（旋转）,  m32（）,     m33（z缩放）, m34（透视效果，要操作的这个对象要有旋转的角度，否则没有效果。正直/负值都有意义）;
 CGFloat m41（x平移）, m42（y平移）, m43（z平移）, m44（）;
 };
 __          __
 |  1  0  0  0|
 |  0  1  0  0|
 |  0  0  1  0|
 | tx ty tz  1|
 --          --
 
 从m11到m44定义的含义如下：
 m11：x轴方向进行缩放
 m12：和m21一起决定z轴的旋转
 m13:和m31一起决定y轴的旋转
 m14:

 m21:和m12一起决定z轴的旋转
 m22:y轴方向进行缩放
 m23:和m32一起决定x轴的旋转
 m24:
 
 m31:和m13一起决定y轴的旋转
 m32:和m23一起决定x轴的旋转
 m33:z轴方向进行缩放
 m34:透视效果m34= -1/D，D越小，透视效果越明显，必须在有旋转效果的前提下，才会看到透视效果

 m41:x轴方向进行平移
 m42:y轴方向进行平移
 m43:z轴方向进行平移
 m44:初始为1
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

