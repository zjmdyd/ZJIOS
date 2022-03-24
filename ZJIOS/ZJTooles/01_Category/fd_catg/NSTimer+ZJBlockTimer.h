//
//  NSTimer+ZJBlockTimer.h
//  ZJIOS
//
//  Created by issuser on 2022/1/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (ZJBlockTimer)

+ (NSTimer *)zj_timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;
+ (NSTimer *)zj_timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats addToRunLoopWithMode:(NSRunLoopMode)mode block:(void (^)(NSTimer *timer))block;

+ (NSTimer *)zj_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;

@end

NS_ASSUME_NONNULL_END
