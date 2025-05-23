//
//  ZJTestCAGradientLayerViewController.m
//  ZJTest
//
//  Created by ZJ on 2019/3/26.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJTestCAGradientLayerViewController.h"
#import "ZJFuncDefine.h"

@interface ZJTestCAGradientLayerViewController ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *colorView;

@end

@implementation ZJTestCAGradientLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = self.view.bounds.size.width;
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, width - 60, 150)];
    self.bgView.center = CGPointMake(width/2, 300);
    [self.view addSubview:self.bgView];
    
    NSLog(@"self.bgView.frame = %@", NSStringFromCGRect(self.bgView.frame));
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.bgView.bounds;
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(1, 0);
    self.gradientLayer.colors = @[
                                  (__bridge id)UIColorFromHex(0xff0000).CGColor,
                                  (__bridge id)UIColorFromHex(0xff00ff).CGColor,
                                  (__bridge id)UIColorFromHex(0x0000ff).CGColor,
                                  (__bridge id)UIColorFromHex(0x00ffff).CGColor,
                                  (__bridge id)UIColorFromHex(0x00ff00).CGColor,
                                  (__bridge id)UIColorFromHex(0xffff00).CGColor,
                                  (__bridge id)UIColorFromHex(0xff0000).CGColor
                                  ];
    [self.bgView.layer addSublayer:self.gradientLayer];
    
    CGRect frame = self.bgView.frame;
    self.colorView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + 170, frame.size.width, 150)];
    self.colorView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.colorView];
}

/*
 CGContextRef CGBitmapContextCreate(
     void *data,                 // 指向存储像素数据的内存块（可为NULL）:ml-citation{ref="1,2" data="citationList"}
     size_t width,               // 位图宽度（像素）:ml-citation{ref="1,2" data="citationList"}
     size_t height,              // 位图高度（像素）:ml-citation{ref="1,2" data="citationList"}
     size_t bitsPerComponent,    // 每个颜色分量的位数（如RGBA中每通道8bit）:ml-citation{ref="2,4" data="citationList"}
     size_t bytesPerRow,         // 每行字节数（需对齐，可为0自动计算）:ml-citation{ref="1,7" data="citationList"}
     CGColorSpaceRef colorspace, // 颜色空间（如sRGB）:ml-citation{ref="1,4" data="citationList"}
     CGBitmapInfo bitmapInfo     // 像素格式与Alpha通道配置:ml-citation{ref="1,7" data="citationList"}
 );
 */
- (UIColor *)colorOfPoint:(CGPoint)point {
    NSLog(@"point = %@", NSStringFromCGPoint(point));
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.gradientLayer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    NSLog(@"pixel: %d-->%d-->%d-->%d", pixel[0], pixel[1], pixel[2], pixel[3]);
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *th = touches.allObjects.firstObject;
    CGPoint point = [th locationInView:self.bgView];
    UIColor *color = [self colorOfPoint:point];
    self.colorView.backgroundColor = color;
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
