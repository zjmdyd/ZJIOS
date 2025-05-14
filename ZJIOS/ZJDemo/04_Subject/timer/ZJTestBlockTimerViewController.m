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
    [self initAry];
}

- (void)initAry {
    self.vcType = ZJBaseTableViewTypeExecute;
    self.cellTitles = @[@"test0", @"test1", @"test2",  @"test3"];
}

- (void)initSetting {
    self.index = 0;
}

/*
 vc会执行dealloc方法，self.timer会被释放, 需使用__weak关键字
 此方法与系统方法同一个效果
 */
- (void)test0 {
    __weak typeof(self) weakSelf = self;    // 需使用__weak关键字
    self.timer = [NSTimer zj_scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timer = %@, self.timer = %@, valid = %d", timer, weakSelf.timer, weakSelf.timer.isValid);
        if (!weakSelf.timer.isValid) {
            [timer invalidate];
        }
    }];
    
    NSLog(@"self.timer = %@", self.timer);
}

/*
 vc不会执行dealloc方法，self.timer不会被释放,
 因为self.index变量导致block()强引用self,解决办法: 使用__weak关键字修饰
 */
- (void)test1 {
    __weak typeof(self) weakSelf = self;    // 需使用__weak关键字

    self.timer = [NSTimer zj_scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        weakSelf.index++;
        NSLog(@"执行timer的方法:%@, index = %zd", timer, weakSelf.index);
        if (!weakSelf.timer.isValid) {
            [timer invalidate];
        }
    }];
}

/*
 vc会执行dealloc方法，self.timer会被释放
 */
- (void)test2 {
    __weak typeof(self) weakSelf = self;    // 需使用__weak关键字
    NSTimer *timer = [NSTimer zj_timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timerEvent1:%@", timer);
        if (!weakSelf.timer.isValid) {
            [timer invalidate];
        }
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    self.timer = timer;
    NSLog(@"self.timer = %@", self.timer);
}

// test2()的简化版
- (void)test3 {
    __weak typeof(self) weakSelf = self;    // 需使用__weak关键字
    self.timer = [NSTimer zj_timerWithTimeInterval:1 repeats:YES addToRunLoopWithMode:NSDefaultRunLoopMode block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timerEvent2:%@", timer);
        if (!weakSelf.timer.isValid) {
            [timer invalidate];
        }
    }];
    NSLog(@"self.timer = %@", self.timer);
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
