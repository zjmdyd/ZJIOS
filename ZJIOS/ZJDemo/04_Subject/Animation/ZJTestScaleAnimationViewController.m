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

- (IBAction)test:(UIButton *)sender {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:5];
    self.myLabel.transform = CGAffineTransformScale(self.myLabel.transform, 1.2, 1.2);

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
