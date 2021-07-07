//
//  NSTimer+ZJBlockTimer.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/17.
//

#import "NSTimer+ZJBlockTimer.h"

@implementation NSTimer (ZJBlockTimer)

+ (NSTimer *)zj_scheduledTimeWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)(void))block
                                       repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(zj_blockInvoke:) userInfo:[block copy]
                                        repeats:repeats];
}

+ (void)zj_blockInvoke:(NSTimer *)timer
{
    void (^block)(void) = timer.userInfo;
    if(block)
    {
        block();
    }
}

@end
