//
//  ZJTimerViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/9/6.
//

#import "ZJTimerViewController.h"

@interface ZJTimerViewController ()

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ZJTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.index = 0;
//    NSLog(@"backgroundTimeRemaining = %f", [UIApplication sharedApplication].backgroundTimeRemaining);
    __block UIBackgroundTaskIdentifier bgIdt = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
//        [[UIApplication sharedApplication] endBackgroundTask:bgIdt];
    }];
     self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerEvent:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timerEvent:(NSTimer *)sender {
    self.index++;
    NSLog(@"index = %ld", (long)self.index);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)dealloc {
    NSLog(@"%s", __func__);
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
