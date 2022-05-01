//
//  ZJRunLoopViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/16.
//

#import "ZJRunLoopViewController.h"

@interface ZJRunLoopViewController ()

@end
/*
struct __CFRunLoop {
     pthread_t _pthread;//线程
    CFMutableSetRef _commonModes;     // commonModes下的两个mode（kCFRunloopDefaultMode和UITrackingMode）
    CFMutableSetRef _commonModeItems; // 在commonModes状态下运行的对象（例如Timer）
    CFMutableSetRef _modes;           // 运行的所有模式（CFRunloopModeRef类）
    CFRunLoopModeRef _currentMode;//在当前loop下运行的mode
};

struct __CFRunLoopMode {
    CFStringRef _name;            // Mode Name, 例如 @"kCFRunLoopDefaultMode"
    CFMutableSetRef _sources0;    // Set
    CFMutableSetRef _sources1;    // Set
    CFMutableArrayRef _observers; // Array
    CFMutableArrayRef _timers;    // Array
};*/

@implementation ZJRunLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (NSThread *)networkRequestThread {
    static NSThread *_networkRequestThread = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _networkRequestThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint:) object:nil];
        [_networkRequestThread start];
    });
    return _networkRequestThread;
}

+ (void)networkRequestThreadEntryPoint:(id)__unused object {
    @autoreleasepool {
        [[NSThread currentThread] setName:@"AFNetworking"];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}

/*
 首先我们要明确一个概念，线程一般都是一次执行完毕任务，就销毁了。
 而在线程中添加了runloop，并运行起来，实际上是添加了一个do，while循环，这样这个线程的程序就一直卡在do，while循环上，这样相当于线程的任务一直没有执行完，所有线程一直不会销毁。
 所以，一旦我们添加了一个runloop，并run了，我们如果要销毁这个线程，必须停止runloop
 runloop开始跑起来，但是要注意，这种runloop，只有一种方式能停止。
 [NSRunloop currentRunloop] removePort
 Runloop，顾名思义就是跑圈，他的本质就是一个do，while循环，当有事做时就做事，没事做时就休眠。至于怎么做事，怎么休眠,这个是由系统内核来调度的，我们后面会讲到。

 每个线程都由一个Run Loop，主线程的Run Loop会在App运行的时自动运行，子线程需要手动获取运行，第一次获取时，才会去创建。
 每个Run Loop都会以一个模式mode来运行，可以使用NSRunLoop的方法运行在某个特定的mode。
 总结一下：
 Run Loop 运行时只能以一种固定的模式运行，如果我们需要它切换模式，只有停掉它，再重新开其它
 运行时它只会监控这个模式下添加的Timer Source和Input Source，如果这个模式下没有相应的事件源，RunLoop的运行也会立刻返回的。注意Run Loop不能在运行在NSRunLoopCommonModes模式，因为NSRunLoopCommonModes其实是个模式集合，而不是一个具体的模式，我可以添加事件源的时候使用NSRunLoopCommonModes，只要Run Loop运行在NSRunLoopCommonModes中任何一个模式，这个事件源都可以被触发。

 
 */
/*
- (void)testDemo1{
    dispatch_async(dispatch_get_global_queue(0,0), ^ {
        NSLog(@"线程开始");
        // 获取当前线程
        self.thread = [NSThread currentThread];
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        // 添加一个Port，同理为了防止runloop没事干直接退出
        [runloop addPort: [NSMachPort port] forMode: NSDefaultRunLoopMode];
        // 运行一个runloop， [NSDate distantFuture]:很久很久以后才让它失效
        [runloop runMode:NSDefaultRunLoopMode beforeDate: [NSDate distantFuture]];
        NSLog(@"线程结束");
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(2*NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
        // 在我们开启的异步线程调用方法
        [self performSelector:@selector(recieveMsg) onThread: self.thread withObject: nil waitUntilDone: NO];
    });
}

- (void)recieveMsg {
    NSLog(@"收到消息了，在这个线程：%@", [NSThread currentThread]);
}
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
