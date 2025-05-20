//
//  ZJTestBezierPathViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/5/16.
//

#import "ZJTestBezierPathViewController.h"
#import "UIView+ZJToucMathEvent.h"
#import "ZJTestRoundView.h"

@interface ZJTestBezierPathViewController ()

@property (nonatomic, strong) ZJTestRoundView *touchView;
@property (nonatomic, assign) CGFloat annularWidth1;
@property (nonatomic, strong) NSArray *angleObjects;
@property (nonatomic, strong) NSArray *colors;

@end

@implementation ZJTestBezierPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initAry];
    [self test1];
}

- (void)initAry {
    NSMutableArray *ary = [NSMutableArray array];
    CGFloat began = 0;
    CGFloat span = M_PI*2/5;
    
    for (int i = 0; i < 5; i++) {
        ZJAngleObject *obj = [ZJAngleObject new];
        obj.startAngle = began + span*i;
        obj.endAngle = began + span + span*i;
        [ary addObject:obj];
    }
    self.angleObjects = ary.copy;
    self.colors = @[[UIColor greenColor], [UIColor purpleColor], [UIColor orangeColor], [UIColor cyanColor], [UIColor yellowColor]];
}

- (void)test1 {
    self.touchView = [[ZJTestRoundView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.touchView.center = self.view.center;
    self.touchView.angles = self.angleObjects;
    self.touchView.colors = self.colors;
    [self.view addSubview:self.touchView];
    
    self.annularWidth1 = self.touchView.frame.size.width/6;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *th = touches.allObjects.firstObject;
    CGPoint touchPoint = [th locationInView:self.touchView];
    NSLog(@"touchPoint:%@", NSStringFromCGPoint(touchPoint));
    
    BOOL inTheAnnularView = [self.touchView touchInTheAnnularWithPoint:touchPoint annularWidth:self.annularWidth1];
    NSLog(@"inTheAnnularView = %d", inTheAnnularView);
}

/*
 //    NSArray *ary = @[@[@(M_PI_2*3), @(M_PI*2-margin)], @[@0, @(M_PI_2-margin)], @[@M_PI_2, @(M_PI-margin)], @[@M_PI, @(M_PI_2*3-margin)]];

 float ary1[] = {0.1, 0.2};

 NSLog(@"sizeof1 = %zd", sizeof(ary1)/sizeof(float));
 
 float ary2[][2] = {{0.1, 0.2}, {0.3, 0.4}};
 NSLog(@"sizeof2 = %zd", sizeof(ary2)/sizeof(float));
 NSLog(@"sizeof3 = %zd", sizeof(ary)/sizeof(CGFloat));


 */
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
