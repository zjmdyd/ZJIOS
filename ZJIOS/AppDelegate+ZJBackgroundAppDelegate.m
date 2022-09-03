//
//  AppDelegate+ZJBackgroundAppDelegate.m
//  ZJIOS
//
//  Created by issuser on 2022/2/10.
//

#import "AppDelegate+ZJBackgroundAppDelegate.h"


@implementation AppDelegate (ZJBackgroundAppDelegate)

// 进入前台，停止任务
- (void)applicationDidBecomeActive:(UIApplication *)application {
//    if (self.backgroundTaskIdentifier != UIBackgroundTaskInvalid){
//        [self endBackgroundTask];
//    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"%s", __func__);
    if ([self isMutiltaskingSupported] == NO) {
        NSLog(@"--->不支持多任务");
        return;
    }

    UIApplication *app = [UIApplication sharedApplication];
    
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"触发ExpirationHandler");
        if (bgTask != UIBackgroundTaskInvalid) {
            NSLog(@"bgTask赋值__UIBackgroundTaskInvalid");
            bgTask = UIBackgroundTaskInvalid;
        }else {
            NSLog(@"直接结束任务");
        }
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid) {
                bgTask = UIBackgroundTaskInvalid;
                NSLog(@"bgTask赋值**UIBackgroundTaskInvalid");
            }else {
                NSLog(@"bgTask==UIBackgroundTaskInvalid");
            }
        });
    });
}

// 任务完成，处理释放对象
- (void)endBackgroundTask{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    __weak AppDelegate *weakSelf = self;
    dispatch_async(mainQueue, ^{
        if (weakSelf != nil) {
//            [weakSelf.myTimer invalidate];
//            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
//            weakSelf.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        }
    });
}

- (BOOL)isMutiltaskingSupported {
    BOOL result = NO;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) {
        result = [[UIDevice currentDevice] isMultitaskingSupported];
    }

    return result;
}

@end
