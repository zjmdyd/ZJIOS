//
//  ZJTestTimerViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/9/6.
//

#import "ZJTestTimerViewController.h"

@interface ZJTestTimerViewController ()

@end

@implementation ZJTestTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
}

- (void)initAry {
    self.vcType = ZJBaseTableViewTypeExecute;
    self.cellTitles = @[@"test0", @"test1", @"test2", @"test3", @"test4", @"test5"];
}

/*
 scheduledTimerWithTimeInterval:会默认将这个 NSTimer 以 NSDefaultRunLoopMode 模式放入当前线程的 RunLoop。
 */
- (void)test0 {
    NSLog(@"currentThread0 = %@", [NSThread currentThread]);
    if (@available(iOS 10.0, *)) {
        __weak typeof(self) weakSelf = self;    // 需要添加__weak关键字，不然会循环引用造成内存泄漏
        [NSTimer scheduledTimerWithTimeInterval:1.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSLog(@"currentThread1 = %@", [NSThread currentThread]);
            // block 方法中有用到self时，需要用weak修饰，不然vc不会被释放
            // vc虽然执行了dealloc方法，但timer的block方法还是会继续执行，因为timer没有被销毁，需手动销毁timer
            // 执行完invalid方法后timer才会被销毁，timer的block方法才不会再执行
            NSLog(@"gggg"); // VC销毁后还是会继续执行
            if (weakSelf) {
                NSLog(@"self没被销毁");     // 页面返回后,不会执行，因为self已经被销毁
            }else {
                NSLog(@"self已经被销毁");    // 页面返回后,会执行，因为timer没有被销毁
                [timer invalidate];
            }
        }];
    } else {
        
    }
}

/*
 scheduledTimerWithTimeInterval:会默认将这个 NSTimer 以 NSDefaultRunLoopMode 模式放入当前线程的 RunLoop。
 */
- (void)test1 {
    if (@available(iOS 10.0, *)) {
        __weak typeof(self) weakSelf = self;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
            // block 方法中有用到self时，需要用weak修饰，不然vc不会被释放
            // vc虽然执行了dealloc方法，但timer的block方法还是会继续执行，因为timer没有被销毁，需手动销毁timer
            // 执行完invalid方法后timer才会被销毁，timer的block方法才不会再执行
            NSLog(@"gggg"); // VC销毁后还是会继续执行
            if (weakSelf) {
                [weakSelf timerEvent:nil];  // 页面返回后,不会执行，因为self已经被销毁
            }else {
                NSLog(@"self已经被销毁");    // 页面返回后,会执行，因为timer没有被销毁
//                [timer invalidate];
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
- (void)test2 {
    if (@available(iOS 10.0, *)) {
        __weak typeof(self) weakSelf = self;
        self.timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            // block 方法中有用到self时，需要用weak修饰，不然vc不会被释放
            // vc虽然执行了dealloc方法，但timer的block方法还是会继续执行，因为timer没有被销毁，需手动销毁timer
            // 执行完invalid方法后timer才会被销毁，timer的block方法才不会再执行
            NSLog(@"kkkk"); // VC销毁后还是会继续执行
            if (weakSelf) {
                [weakSelf timerEvent:nil];  // 页面返回后,不会执行，因为self已经被销毁,执行else
            }else {
                NSLog(@"self已经被销毁");    // 页面返回后,会执行，因为timer没有被销毁
//                [timer invalidate];
            }
        }];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    } else {
        
    }
}

- (void)test3 {
    // 加入RunLoop的timer,此种情形不论我们的timer是strong还是weak都无济于事，因为api内部会强持有target
    // 需手动invalid才会释放timer,当repeat为NO的时候则不需要，会自动释放
    __weak typeof(self) weakSelf = self; // 用__weak修饰也没用,还是会强引用target,造成循环引用
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:weakSelf selector:@selector(timerEvent:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];   // 不加入RunLoop则出了此方法体，timer稍后会被释放
    // 赋值给weak变量
    self.timer = timer;
    [weakSelf testTimerValid];
}

- (void)testTimerValid {
    // weak修饰的的且没有添加到runLoop中的timer才会被释放
    if (self.timer == nil) {
        NSLog(@"timer被释放了");    // 执行test4()时,此处不会打印, 不会被立刻释放,稍后才会被释放,
    }
    // timer = <__NSCFTimer: 0x7b3000026d00>, valid = 1
    NSLog(@"timer = %@, valid = %d", self.timer, self.timer.isValid);
    
    if (@available(iOS 10.0, *)) {
        // timer = (null), valid = 0;  weak修饰的的且没有添加到runLoop中的timer才会被释放
        __weak typeof(self) weakSelf = self;    // 执行test4()和test5()时,不用__weak关键字self.timer也会被释放掉
        [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSLog(@"检查timer有效性,timer = %@, valid = %d", weakSelf.timer, weakSelf.timer.isValid);
            if (!weakSelf.timer.isValid) {
                [timer invalidate];
            }
        }];
    } else {
        // Fallback on earlier versions
    }
}

/*
 未加入RunLoopweak修饰的timer被释放了
 此种方式创建timer，timer 对象创建之后先加入 RunLoop 再赋值给weak修饰的self.timer变量，timer才不会被释放
 */
- (void)test4 {
    NSLog(@"%s", __func__);
    self.timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(timerEvent:) userInfo:nil repeats:YES];

    [self testTimerValid];
}

// timer销毁，VC才会执行dealloc方法，所以timer用strong和weak修饰没啥区别
- (void)test5 {
    // 执行完方法后timer会自动销毁
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerEvent:) userInfo:nil repeats:NO];
    [self testTimerValid];
}

- (void)timerEvent:(NSTimer *)sender {
    NSLog(@"%s", __func__);
    
    if (self.timer == nil) {
        NSLog(@"timer被释放了");
    }
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
