//
//  NSTimer+ZJBlockTimer.h
//  ZJIOS
//
//  Created by Zengjian on 2021/6/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (ZJBlockTimer)

+ (NSTimer *)zj_scheduledTimeWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)(void))block
                                       repeats:(BOOL)repeats;
@end

NS_ASSUME_NONNULL_END
