//
//  ZJTestLayerMaskViewController.m
//  ZJTest
//
//  Created by ZJ on 2019/7/10.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJTestLayerMaskViewController.h"

@interface ZJTestLayerMaskViewController ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation ZJTestLayerMaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    UIView *testview = [[UIView alloc] initWithFrame:self.bgView.bounds];
    //    [self.bgView addSubview: testview];
    //
    //    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:testview.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(16,16)];
    //    //创建 layer
    //    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //    maskLayer.frame = testview.bounds;
    //    //赋值
    //    maskLayer.path = maskPath.CGPath;
    //    testview.layer.mask = maskLayer;
    //    maskLayer.borderWidth = 10;
    //    maskLayer.borderColor = [UIColor greenColor].CGColor;
}
- (IBAction)btnEvent:(UIButton *)sender {
    if (sender.tag == 0) {
        [self test0];
    }else if (sender.tag == 1) {
        [self test1];
    }else if (sender.tag == 2) {
        [self test2];
    }
}

- (void)test0 {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(16, 16)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = maskPath.CGPath;
    shapeLayer.borderWidth = 10;
    shapeLayer.borderColor = [UIColor greenColor].CGColor;
    self.bgView.layer.mask = shapeLayer;
}
/*
 public struct CACornerMask: OptionSet {
     public static var kCALayerMinXMinYCorner: CACornerMask // 左上角:ml-citation{ref="1,3" data="citationList"}
     public static var kCALayerMaxXMinYCorner: CACornerMask // 右上角:ml-citation{ref="1,3" data="citationList"}
     public static var kCALayerMinXMaxYCorner: CACornerMask // 左下角:ml-citation{ref="1,3" data="citationList"}
     public static var kCALayerMaxXMaxYCorner: CACornerMask // 右下角:ml-citation{ref="1,3" data="citationList"}
 }
 */
- (void)test1 {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(16, 16)];
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.path = maskPath.CGPath;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor redColor].CGColor;
    borderLayer.lineWidth = 2;
    borderLayer.frame = self.bgView.bounds;
    [borderLayer setName:@"lit"];
    
    [self.bgView.layer addSublayer:borderLayer];
    self.bgView.layer.cornerRadius = 16;
    self.bgView.layer.maskedCorners = kCALayerMinXMaxYCorner | kCALayerMaxXMinYCorner;
}

- (void)test2 {
    for (CALayer *layer in self.bgView.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
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
