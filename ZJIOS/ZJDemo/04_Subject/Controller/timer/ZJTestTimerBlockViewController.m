//
//  ZJTestTimerBlockViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/1/25.
//

#import "ZJTestTimerBlockViewController.h"
#import "NSTimer+ZJBlockTimer.h"

@interface ZJTestTimerBlockViewController ()

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger index;

@end

@implementation ZJTestTimerBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSetting];
    [self test5];
}

- (void)initSetting {
    self.index = 0;
}

// test4()的简化版本
- (void)test5 {
    self.timer = [NSTimer zj_timerWithTimeInterval:2 repeats:YES addToRunLoopWithMode:NSDefaultRunLoopMode block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timerEvent2:%@", timer);
    }];
}

- (void)test4 {
    NSTimer *timer = [NSTimer zj_timerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timerEvent1:%@", timer);
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    self.timer = timer;
}

/*
 解决方法:self转成weak_self
 */
- (void)test3 {
    __weak typeof(self) weak_self = self;
    self.timer = [NSTimer zj_scheduledTimerWithTimeInterval:5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        weak_self.index++;
        NSLog(@"执行timer的方法:%@, index = %zd", timer, weak_self.index);
    }];
}

/*
 vc不会执行dealloc方法，timer不会被释放,因为self.index变量导致block()强引用self,
 */
- (void)test2 {
    self.timer = [NSTimer zj_scheduledTimerWithTimeInterval:5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        self.index++;
        NSLog(@"执行timer的方法:%@, index = %zd", timer, self.index);
    }];
}

/*
 vc会执行dealloc方法，timer会被释放
 */
- (void)test1 {
    self.timer = [NSTimer zj_scheduledTimerWithTimeInterval:5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"执行timer的方法:%@", timer);
    }];
}

/*
 用weak修饰timer:控制器弱引用了timer,timer强引用了控制器
 NSTimer 一直强引用着 vc 导致 vc 无法调用 dealloc 方法,所以timer无法被释放
 */
- (void)test0 {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerEvent:) userInfo:nil repeats:YES];
}

- (void)timerEvent:(NSTimer *)sender {
    NSLog(@"调用了timer事件");
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    [self.timer invalidate];
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
