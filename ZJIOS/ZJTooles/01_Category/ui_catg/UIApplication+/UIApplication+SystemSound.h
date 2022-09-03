//
//  UIApplication+SystemSound.h
//  ZJIOS
//
//  Created by issuser on 2021/10/9.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (SystemSound)

/**
 *  系统震动音
 */
+ (void)playSystemVibrate;

/**
 *  根据系统声音名播放声音
 *
 *  @param name 系统提供的声音名
 */
+ (void)playSystemSoundWithName:(NSString *)name;

/**
 根据地址播放音频
 */
+ (SystemSoundID)playWithUrl:(NSURL *)url;
+ (SystemSoundID)playWithUrl:(NSURL *)url repeat:(BOOL)repeat;
+ (void)stopSystemSoundWithSoundID:(SystemSoundID)sound;

/**
 *  播放用户提供的音频文件
 *
 *  @param name 文件名
 *  @param type         文件类型(.mp3 .wav等)
 */
+ (void)playSoundWithResourceName:(NSString *)name type:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
