//
//  ZJTestScaleAnimationViewController.m
//  ZJUIKit
//
//  Created by ZJ on 2/23/16.
//  Copyright © 2016 YunTu. All rights reserved.
//

#import "ZJTestScaleAnimationViewController.h"

@interface ZJTestScaleAnimationViewController () {
    CGFloat _size;
}

@property (weak, nonatomic) IBOutlet UILabel *myLabel;

@end

@implementation ZJTestScaleAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _size = 15;
}

/* CATransform3D Key Paths
  旋转x,y,z分别是绕x,y,z轴旋转
static NSString *kCARotation = @"transform.rotation";
static NSString *kCARotationX = @"transform.rotation.x";
static NSString *kCARotationY = @"transform.rotation.y";
static NSString *kCARotationZ = @"transform.rotation.z";
  
 缩放x,y,z分别是对x,y,z方向进行缩放
static NSString *kCAScale = @"transform.scale";
static NSString *kCAScaleX = @"transform.scale.x";
static NSString *kCAScaleY = @"transform.scale.y";
static NSString *kCAScaleZ = @"transform.scale.z";

  平移x,y,z同上
static NSString *kCATranslation = @"transform.translation";
static NSString *kCATranslationX = @"transform.translation.x";
static NSString *kCATranslationY = @"transform.translation.y";
static NSString *kCATranslationZ = @"transform.translation.z";

  
 平面 CGPoint中心点改变位置，针对平面
static NSString *kCAPosition = @"position";
static NSString *kCAPositionX = @"position.x";
static NSString *kCAPositionY = @"position.y";

 CGRect
static NSString *kCABoundsSize = @"bounds.size";
static NSString *kCABoundsSizeW = @"bounds.size.width";
static NSString *kCABoundsSizeH = @"bounds.size.height";
static NSString *kCABoundsOriginX = @"bounds.origin.x";
static NSString *kCABoundsOriginY = @"bounds.origin.y";
 
  透明度
static NSString *kCAOpacity = @"opacity";
 背景色
static NSString *kCABackgroundColor = @"backgroundColor";
 圆角
static NSString *kCACornerRadius = @"cornerRadius";
 边框
static NSString *kCABorderWidth = @"borderWidth";
 阴影颜色
static NSString *kCAShadowColor = @"shadowColor";
 偏移量CGSize
static NSString *kCAShadowOffset = @"shadowOffset";
 阴影透明度
static NSString *kCAShadowOpacity = @"shadowOpacity";
 阴影圆角
static NSString *kCAShadowRadius = @"shadowRadius";
 */
- (IBAction)test:(UIButton *)sender {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @1;
    animation.toValue = @(1.5);
    animation.duration = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.myLabel.layer addAnimation:animation forKey:nil];
}

//API_DEPRECATED
- (void)test1:(UIButton *)sender {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:2];
    self.myLabel.transform = CGAffineTransformScale(self.myLabel.transform, 1.5, 1.5);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
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
