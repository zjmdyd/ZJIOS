//
//  NSTimer+ZJBlockTimer.m
//  ZJIOS
//
//  Created by issuser on 2022/1/25.
//

#import "NSTimer+ZJBlockTimer.h"

@implementation NSTimer (ZJBlockTimer)

+ (NSTimer *)zj_timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block {
    return [NSTimer timerWithTimeInterval:interval target:self selector:@selector(zj_blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (NSTimer *)zj_timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats addToRunLoopWithMode:(NSRunLoopMode)mode block:(void (^)(NSTimer *timer))block {
    NSTimer *timer = [NSTimer timerWithTimeInterval:interval target:self selector:@selector(zj_blockInvoke:) userInfo:[block copy] repeats:repeats];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:mode];
    
    return timer;
}

+ (NSTimer *)zj_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block {
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(zj_blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)zj_blockInvoke:(NSTimer *)timer {
    void (^block)(NSTimer *tm) = timer.userInfo;
    if (block) {
        block(timer);
    }
}

@end
