//
//  ZJTestBlockTimerViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/1/25.
//

#import "ZJTestBlockTimerViewController.h"
#import "NSTimer+ZJBlockTimer.h"

@interface ZJTestBlockTimerViewController ()

@property (nonatomic, assign) NSInteger index;

@end

@implementation ZJTestBlockTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSetting];
    [self test3];
}

- (void)initSetting {
    self.index = 0;
}

/*
 vc会执行dealloc方法，timer会被释放
 */
- (void)test0 {
    self.timer = [NSTimer zj_scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"执行timer的方法:%@", timer);
    }];
}

/*
 vc不会执行dealloc方法，timer不会被释放,因为self.index变量导致block()强引用self,
 */
- (void)test1 {
    self.timer = [NSTimer zj_scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        self.index++;
        NSLog(@"执行timer的方法:%@, index = %zd", timer, self.index);
    }];
}

/*
 解决方法:self转成weak_self
 */
- (void)test2 {
    __weak typeof(self) weak_self = self;
    self.timer = [NSTimer zj_scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        weak_self.index++;
        NSLog(@"执行timer的方法:%@, index = %zd", timer, weak_self.index);
    }];
}

- (void)test3 {
    NSTimer *timer = [NSTimer zj_timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timerEvent1:%@", timer);
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    self.timer = timer;
}

// test3()的简化版
- (void)test4 {
    self.timer = [NSTimer zj_timerWithTimeInterval:1 repeats:YES addToRunLoopWithMode:NSDefaultRunLoopMode block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timerEvent2:%@", timer);
    }];
}

- (void)timerEvent:(NSTimer *)sender {
    NSLog(@"调用了timer事件");
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
