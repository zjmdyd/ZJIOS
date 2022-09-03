//
//  ZJTouchMathEventViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/5/15.
//

#import "ZJTouchMathEventViewController.h"
#import "UIView+ZJToucMathEvent.h"
#import "CALayer+ZJLayer.h"

@interface ZJTouchMathEventViewController ()

@property (nonatomic, strong) UIView *touchView;

@end

@implementation ZJTouchMathEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self test0];
}

- (void)test0 {
    CGFloat width = 200;
    self.touchView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, width, width)];
    NSLog(@"c1:%@", NSStringFromCGPoint(self.view.center));
    self.touchView.center = self.view.center;
    self.touchView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.touchView];
    
    UIView *annularView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    annularView.backgroundColor = [UIColor greenColor];
    [annularView.layer setMaskCornerRadius:width/2];
    annularView.layer.borderWidth = 30;
    [self.touchView addSubview:annularView];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *th = touches.allObjects.firstObject;
    CGPoint point1 = [th locationInView:self.view];
    CGPoint point2 = [th locationInView:self.touchView];
    NSLog(@"p1:%@", NSStringFromCGPoint(point1));
    NSLog(@"p2:%@", NSStringFromCGPoint(point2));
    QuadrantTouchType type = [self.touchView quadrantOfTouchPoint:point2 separateType:AnnularSeparateTypeQuarter];
    NSLog(@"type = 第%zd象限", type);
    
    BOOL inTheAnnularView = [self.touchView touchInTheAnnularWithPoint:point2 annularWidth:30];
    NSLog(@"inTheAnnularView = %d", inTheAnnularView);
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
