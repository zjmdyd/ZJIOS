//
//  ZJTestTimerViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/9/6.
//

#import "ZJTestTimerViewController.h"

@interface ZJTestTimerViewController ()

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation ZJTestTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSetting];
    [self test0];
}

- (void)initSetting {
    self.index = 0;
}

/*
 NSTimer 对象创建之后先加入 RunLoop 再赋值给weak修饰的timer变量，timer不会被释放
 */
- (void)test3 {
    NSLog(@"%s", __func__);
    NSTimer *timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(timerEvent:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];   // 不加入RunLoop则出了此方法体，timer就会被释放
    // 赋值给weak变量
    self.timer = timer;
    if (self.timer == nil) {
        NSLog(@"timer被释放了");
    }else {
        NSLog(@"timer不会被释放");
    }
}

/*
 weak修饰的timer被释放
 */
- (void)test2 {
    NSLog(@"%s", __func__);
    self.timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(timerEvent:) userInfo:nil repeats:YES];
    if (self.timer == nil) {
        NSLog(@"timer被释放了");
    }
}

/*
 timerWithTimeInterval:需要调用 RunLoop 的 addTimer:forMode: 方法将 NSTimer 放入 RunLoop，这样 NSTimer 才能正常工作。
 RunLoop 对加入其中的 NSTimer 会添加一个强引用。
 */
- (void)test1 {
    if (@available(iOS 10.0, *)) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:5 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self timerEvent:nil];
        }];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    } else {
        NSTimer *timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(timerEvent:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }
}

/*
 scheduledTimerWithTimeInterval:会将这个 NSTimer 以 NSDefaultRunLoopMode 模式放入当前线程的 RunLoop。
 */
- (void)test0 {
    if (@available(iOS 10.0, *)) {
        [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self timerEvent:nil];  // vc不会执行dealloc方法，timer不会被释放,因为block()强引用self, 解决方法:self-->weak_self
        }];
    } else {
        // Fallback on earlier versions
        [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timerEvent:) userInfo:nil repeats:YES];
    }
}

- (void)timerEvent:(NSTimer *)sender {
    self.index++;
    
    NSLog(@"index = %ld", (long)self.index);
//    NSLog(@"currentRunLoop = %@", [NSRunLoop currentRunLoop]);
//    NSLog(@"currentMode = %@", [NSRunLoop currentRunLoop].currentMode);
}

/*
 虽然用weak修饰timer(vc弱引用了timer), 但是timer强引用了控制器
 NSTimer 一直强引用着 vc 导致 vc 无法调用 dealloc 方法,所以timer无法被释放
 */
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
