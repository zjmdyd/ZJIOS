//
//  ZJTestTimerViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/9/6.
//

#import "ZJTestTimerViewController.h"

@interface ZJTestTimerViewController ()

//@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ZJTestTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test3];
}

/*
 scheduledTimerWithTimeInterval:会默认将这个 NSTimer 以 NSDefaultRunLoopMode 模式放入当前线程的 RunLoop。
 */
- (void)test0 {
    if (@available(iOS 10.0, *)) {
        __weak typeof(self) weakSelf = self;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
            // block 方法中有用到self时，需要用weak修饰，不然vc不会被释放
            // vc虽然执行了dealloc方法，但timer的block方法还是会继续执行，因为timer没有被销毁，需手动销毁timer
            // 执行完invalid方法后timer才会被销毁，timer的block方法才不会再执行
            NSLog(@"gggg"); // VC销毁后还是会继续执行
            if (weakSelf) {
                [weakSelf timerEvent:nil];  // 不会执行，因为self已经被销毁
            }else {
                NSLog(@"self已经被销毁");    // 会执行，因为timer没有被销毁
            }
        }];
    } else {
        // 需手动invalid才会释放timer,当repeat为NO的时候则不需要
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerEvent:) userInfo:nil repeats:NO];
    }
}

/*
 timerWithTimeInterval:需要调用 RunLoop 的 addTimer:forMode: 方法将 NSTimer 放入 RunLoop，这样 NSTimer 才能正常工作。
 RunLoop 对加入其中的 NSTimer 会添加一个强引用。
 */
- (void)test1 {
    if (@available(iOS 10.0, *)) {
        __weak typeof(self) weakSelf = self;
        self.timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            // block 方法中有用到self时，需要用weak修饰，不然vc不会被释放
            // vc虽然执行了dealloc方法，但timer的block方法还是会继续执行，因为timer没有被销毁，需手动销毁timer
            // 执行完invalid方法后timer才会被销毁，timer的block方法才不会再执行
            NSLog(@"kkkk"); // VC销毁后还是会继续执行
            if (weakSelf) {
                [weakSelf timerEvent:nil];  // 不会执行，因为self已经被销毁
            }else {
                NSLog(@"self已经被销毁");    // 会执行，因为timer没有被销毁
            }
        }];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    } else {
        // 此种情形不论我们的timer是strong还是weak都无济于事，因为api内部会强持有
        // 需手动invalid才会释放timer,当repeat为NO的时候则不需要，会自动释放
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerEvent:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];   // 不加入RunLoop则出了此方法体，timer就会被释放
        // 赋值给weak变量
        self.timer = timer;
    }
}

/*
 weak修饰的timer被释放了
 此种方式创建timer，timer 对象创建之后先加入 RunLoop 再赋值给weak修饰的self.timer变量，timer才不会被释放
 */
- (void)test2 {
    NSLog(@"%s", __func__);
    self.timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(timerEvent:) userInfo:nil repeats:YES];
    if (self.timer == nil) {
        NSLog(@"timer被释放了");
    }
}

// 只要timer销毁了，VC就会执行dealloc方法，所以timer用strong和weak修饰没啥区别
- (void)test3 {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerEvent:) userInfo:nil repeats:NO];
}

- (void)timerEvent:(NSTimer *)sender {
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
