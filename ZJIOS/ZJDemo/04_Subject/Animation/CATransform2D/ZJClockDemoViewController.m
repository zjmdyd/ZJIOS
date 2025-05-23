//
//  ZJClockDemoViewController.m
//  ZJFoundation
//
//  Created by YunTu on 15/9/6.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ZJClockDemoViewController.h"

@interface ZJClockDemoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *hourHand;
@property (weak, nonatomic) IBOutlet UILabel *minuteHand;
@property (weak, nonatomic) IBOutlet UILabel *secondHand;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;

@end

@implementation ZJClockDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.secondHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);    //anchorPoint在label的底部，绕着label的底部旋转
    self.minuteHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    self.hourHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

- (void)tick {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger units = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    
    CGFloat hoursAngle = (components.hour / 12.0) * M_PI * 2.0;
    //calculate hour hand angle //calculate minute hand angle
    CGFloat minsAngle = (components.minute / 60.0) * M_PI * 2.0;
    //calculate second hand angle
    CGFloat secsAngle = (components.second / 60.0) * M_PI * 2.0;
    
    //rotate hands
    self.hourHand.transform = CGAffineTransformMakeRotation(hoursAngle);
    self.minuteHand.transform = CGAffineTransformMakeRotation(minsAngle);
    self.secondHand.transform = CGAffineTransformMakeRotation(secsAngle);
    
    //NSLog(@"%@", [NSDate date]);
    
    NSString *h = components.hour < 10 ? [NSString stringWithFormat:@"0%ld", (long)components.hour] : [NSString stringWithFormat:@"%ld", (long)components.hour];
    NSString *m = components.minute < 10 ? [NSString stringWithFormat:@"0%ld", (long)components.minute] : [NSString stringWithFormat:@"%ld", (long)components.minute];
    NSString *s = components.second < 10 ? [NSString stringWithFormat:@"0%ld", (long)components.second] : [NSString stringWithFormat:@"%ld", (long)components.second];
    self.currentTimeLabel.text = [NSString stringWithFormat:@"%@:%@:%@", h, m, s];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
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
