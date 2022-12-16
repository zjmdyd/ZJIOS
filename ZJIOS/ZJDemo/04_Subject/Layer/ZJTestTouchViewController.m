//
//  ZJTestTouchViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/6/12.
//

#import "ZJTestTouchViewController.h"

@interface ZJTestTouchViewController ()

@property (nonatomic, strong) UIView *moveView;
@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, assign) BOOL hasTouchIn;
@property (nonatomic, assign) CGFloat border_width;

@end

@implementation ZJTestTouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test0];
//    [self test2];
    [self test1];
}
//frame = {{70, 297}, {250, 250}}
- (void)test0 {
    self.border_width = 10;
    self.circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    self.circleView.layer.borderWidth = self.border_width;
    self.circleView.layer.borderColor = [UIColor blueColor].CGColor;
    self.circleView.center = self.view.center;
    [self.view addSubview:self.circleView];
    NSLog(@"frame = %@", NSStringFromCGRect(self.circleView.frame));
}

- (void)test2 {
    UIView *sView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    sView.center = self.view.center;
    sView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:sView];
}

- (void)test1 {
    self.moveView = [[UIView alloc] initWithFrame:CGRectMake(150, 150, 50, 50)];
    self.moveView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.moveView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
//    NSLog(@"touches = %@", touches);
//    NSLog(@"event = %@", event);
    UITouch *touch = touches.allObjects.firstObject;
    UIView *sView = touch.view;
    NSLog(@"%@", sView);
    if (sView == self.moveView) {
        NSLog(@"点钟view");
        self.hasTouchIn = YES;
    }
    CGPoint tPoint = [touch locationInView:self.view];
    NSLog(@"tPoint = %@", NSStringFromCGPoint(tPoint));
}

- (BOOL)validY:(CGPoint)tPoint {
    BOOL hasMatchY = NO;
    CGFloat circle_y = self.circleView.frame.origin.y;

    // 上轨
    return YES;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    if (self.hasTouchIn) {
        UITouch *touch = touches.allObjects.firstObject;
        CGPoint tPoint = [touch locationInView:self.view];
        CGFloat circle_left = self.circleView.frame.origin.x;
        CGFloat circle_Top = self.circleView.frame.origin.y;
        CGFloat circle_w = self.circleView.frame.size.width;
        CGFloat circle_h = self.circleView.frame.size.height;
        
        CGFloat circle_right = circle_left + circle_w;
        CGFloat circle_bottom = circle_Top + circle_h;

        BOOL flagRight = NO;
        if (tPoint.x < circle_left + self.border_width/2) {
            tPoint.x = circle_left + self.border_width/2;
        }else if (tPoint.x > circle_right - self.border_width/2) {
            tPoint.x = circle_right - self.border_width/2;
            flagRight = YES;
        }
        
        BOOL flagTop = YES;
        if (tPoint.y < circle_Top + self.border_width/2) {
            tPoint.y = circle_Top + self.border_width/2;
        }else if (tPoint.y > circle_bottom - self.border_width/2) {
            tPoint.y = circle_bottom - self.border_width/2;
        }
        
        CGRect inValidRect = CGRectMake(circle_left + self.border_width, circle_Top + self.border_width, circle_w - self.border_width*2, circle_h - self.border_width*2);
        BOOL contain = CGRectContainsPoint(inValidRect, tPoint);
        if (contain) {
            if (flagTop) {
                tPoint.y = circle_Top + self.border_width/2;
            }else if (flagRight) {
                tPoint.x = circle_right - self.border_width/2;
            }
        }
        
        self.moveView.center = tPoint;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.hasTouchIn = NO;
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
