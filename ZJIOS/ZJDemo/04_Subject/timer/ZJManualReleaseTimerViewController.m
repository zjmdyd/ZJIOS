//
//  ZJManualReleaseTimerViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/5/1.
//

#import "ZJManualReleaseTimerViewController.h"

@interface ZJManualReleaseTimerViewController ()

@end

@implementation ZJManualReleaseTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initAry];
}

- (void)initAry {
    self.vcType = ZJBaseTableViewTypeExecute;
    self.cellTitles = @[@"test0", @"test1"];
}

// vc不会执行dealloc方法，因为timer会强引用target，即使用weak修饰self也一样，因为timer运行的时候执行事件导致target无法被释放
- (void)test0 {
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerEvent:) userInfo:nil repeats:YES];
}

// 当强制释放self后，vc会执行dealloc方法，但必须手动对timer执行invalid操作，否则可能会出现野指针访问crash
// 非法访问:Thread 1: EXC_BAD_ACCESS (code=EXC_I386_GPFLT)
- (void)test1 {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerEvent:) userInfo:nil repeats:YES];
}

- (void)timerEvent:(NSTimer *)sender {
    NSLog(@"%s", __func__);
    
    if (self.timer != sender) {
        [sender invalidate];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.timer) {
        // 强制释放self,必须再手动释放timer，不然会出现野指针访问crash,所以在父类的dealloc统一处理销毁timer
//        CFRelease((__bridge CFTypeRef)(self));
        // 直接释放timer更保险
        [self.timer invalidate];
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
