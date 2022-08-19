//
//  ZJTestVectorViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/5/30.
//

#import "ZJTestVectorViewController.h"

@interface ZJTestVectorViewController ()

@end

@implementation ZJTestVectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test1];
}

- (void)test0 {
    UILabel *label0 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 135, 82.55)];
    label0.backgroundColor = [UIColor whiteColor];
    label0.layer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor;
    label0.center = self.view.center;
    [self.view addSubview:label0];
    label0.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 135, 21.4)];
    label1.backgroundColor = [UIColor whiteColor];
    label1.layer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.64].CGColor;
    label1.translatesAutoresizingMaskIntoConstraints = NO;
    [label0 addSubview:label1];
}

- (void)test1 {
    UILabel *label0 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 613.14, 308.43)];
    label0.backgroundColor = [UIColor whiteColor];
    label0.layer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor;
    label0.center = self.view.center;
    [self.view addSubview:label0];
    label0.translatesAutoresizingMaskIntoConstraints = NO;
    
    [label0.widthAnchor constraintEqualToConstant:613.14].active = YES;
    [label0.heightAnchor constraintEqualToConstant:308.43].active = YES;
    [label0.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:107].active = YES;
    [label0.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:821].active = YES;
    
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 467.62, 308.43)];
    label1.backgroundColor = [UIColor whiteColor];
    label1.layer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor;
    [label0 addSubview:label1];
    label1.translatesAutoresizingMaskIntoConstraints = NO;
    
    [label1.widthAnchor constraintEqualToConstant:467.62].active = YES;
    [label1.heightAnchor constraintEqualToConstant:308.43].active = YES;
    [label1.leadingAnchor constraintEqualToAnchor:label0.leadingAnchor constant:107].active = YES;
    [label1.topAnchor constraintEqualToAnchor:label0.topAnchor constant:821].active = YES;
    
    // strock
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 238.9, 433.61)];
    label2.backgroundColor = [UIColor whiteColor];
    
    // layer
    CAGradientLayer *layer0 = [CAGradientLayer layer];
    layer0.colors = @[(__bridge id)[UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:0.933 green:0.949 blue:0.961 alpha:1].CGColor];
    layer0.locations = @[@0, @1];
    layer0.startPoint = CGPointMake(0.25, 0.5);
    layer0.endPoint = CGPointMake(0.75, 0.5);
    layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransformMake(0, 0.65, -0.5, 0, 0.44, 0.33));
    layer0.bounds = CGRectInset(label2.bounds, -0.5*label2.bounds.size.width, -0.5*label2.bounds.size.height);
    layer0.position = label2.center;
    label2.translatesAutoresizingMaskIntoConstraints = NO;
    [label2.layer addSublayer:layer0];
    [label1 addSubview:label2];
    
    [label2.widthAnchor constraintEqualToConstant:238.9].active = YES;
    [label2.heightAnchor constraintEqualToConstant:433.61].active = YES;
    [label2.leadingAnchor constraintEqualToAnchor:label1.leadingAnchor constant:107].active = YES;
    [label2.topAnchor constraintEqualToAnchor:label1.topAnchor constant:1056.5].active = YES;
    
    // vector
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 322.5, 216)];
    label3.backgroundColor = [UIColor whiteColor];
    label3.translatesAutoresizingMaskIntoConstraints = NO;
    [label2 addSubview:label3];
    
    [label3.widthAnchor constraintEqualToConstant:322.5].active = YES;
    [label3.heightAnchor constraintEqualToConstant:216].active = YES;
    [label3.leadingAnchor constraintEqualToAnchor:label2.leadingAnchor constant:120.5].active = YES;
    [label3.topAnchor constraintEqualToAnchor:label2.topAnchor constant:856.5].active = YES;
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
