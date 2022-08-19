//
//  ZJMergeViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/6/15.
//

#import "ZJMergeViewController.h"

#define kRGBA(r, g, b, a)   [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

@interface ZJMergeViewController ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation ZJMergeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *colors = @[
    kRGBA(218, 143, 129, 1),
    kRGBA(241, 166, 130, 1),
    kRGBA(252, 161, 133, 1),
    ];
    
    CAGradientLayer *graLayer = [CAGradientLayer layer];
    graLayer.frame = CGRectMake(0, 0, 200, 200);
    graLayer.colors = @[
        (__bridge id)kRGBA(218, 143, 129, 1).CGColor,
        (__bridge id)kRGBA(241, 166, 130, 1).CGColor,
        (__bridge id)kRGBA(252, 161, 133, 1).CGColor
    ];
    graLayer.locations = @[@0, @0.3, @0.6];
    graLayer.startPoint = CGPointMake(0, 0);
    graLayer.endPoint = CGPointMake(1, 1);
    [self.bgView.layer addSublayer:graLayer];
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
