//
//  ZJCALayerFirstViewController.m
//  ZJCoreAnimation
//
//  Created by YunTu on 15/8/29.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ZJCALayerFirstViewController.h"
#import "UIViewExt.h"

@interface ZJCALayerFirstViewController ()<CALayerDelegate>

@property (strong, nonatomic) UIView *lightgrayView;
@property (strong, nonatomic) CALayer *blueLayer;

@end

@implementation ZJCALayerFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // lightgrayView
    self.lightgrayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.lightgrayView.center = self.view.center;
    self.lightgrayView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.lightgrayView];
    
    // blueLayer
    self.blueLayer = [CALayer layer];
    self.blueLayer.frame = CGRectMake(30, 30, self.lightgrayView.width - 60, self.lightgrayView.height - 60);
    self.blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    
    //set controller as layer delegate
    self.blueLayer.delegate = self;
    
    [self.lightgrayView.layer addSublayer:self.blueLayer];
    
    // CGImageRef   CGColorRef
    // UIImage      UIColor
    UIImage *image = [UIImage imageNamed:@"baby.jpg"];
    self.blueLayer.contents = (__bridge id)(image.CGImage);
    self.blueLayer.contentsGravity = kCAGravityResizeAspect;            // 等同 UIViewContentModeScaleAspectFit
    self.blueLayer.contentsScale = image.scale;
//    self.blueLayer.contentsRect = CGRectMake(0, 0, 0.5, 0.5);          // 显示图片的区域(0~1) 默认:(0, 0, 1, 1)
//    self.blueLayer.contentsCenter = CGRectMake(0.2, 0.2, 0.6, 0.6);
    
    //#ifndef Max
    //force layer to redraw
    [self.blueLayer display];   // 如果contents为空,则此方法失效,不会执行重画方法(drawLayer方法)
    //#endif
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //get touch position relative to main view
    CGPoint point = [[touches anyObject] locationInView:self.view];
    CALayer *layer = [self.lightgrayView.layer hitTest:point];
    
    if (layer == self.blueLayer) {
        [[[UIAlertView alloc] initWithTitle:@"Inside Blue Layer"
                                    message:nil
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else if (layer == self.lightgrayView.layer) {
        [[[UIAlertView alloc] initWithTitle:@"Inside lightGray Layer"
                                    message:nil
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    
#ifdef Max //另一种获取point的方法
    //convert point to the white layer's coordinates
    point = [self.layerView.layer convertPoint:point fromLayer:self.view.layer];
    //get layer using containsPoint:
    if ([self.layerView.layer containsPoint:point]) {
        //convert point to blueLayer’s coordinates
        point = [self.blueLayer convertPoint:point fromLayer:self.layerView.layer];
        
        if ([self.blueLayer containsPoint:point]) {
            [[[UIAlertView alloc] initWithTitle:@"Inside Blue Layer"
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Inside lightGray Layer"
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    }
#endif
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    NSLog(@"%s", __func__);
    //draw a thick red circle
    CGContextSetLineWidth(ctx, 10.0f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);    // Ellipse : 椭圆
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"%s", __func__);
    self.blueLayer.delegate = nil;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
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
