//
//  UIApplication+SystemSound.m
//  ZJIOS
//
//  Created by issuser on 2021/10/9.
//

#import "UIApplication+SystemSound.h"

@implementation UIApplication (SystemSound)

#pragma mark - 系统声音

#ifndef AudioPath
#define AudioPath @"/System/Library/Audio/UISounds/"
#endif

+ (void)playSystemVibrate {
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

+ (void)playSystemSoundWithName:(NSString *)name {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", AudioPath, name]];
    
    [self playWithUrl:url];
}

+ (void)playSoundWithResourceName:(NSString *)name type:(NSString *)type {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    if (path) {
        [self playWithUrl:[NSURL fileURLWithPath:path]];
    }
}

+ (SystemSoundID)playWithUrl:(NSURL *)url {
    return [self playWithUrl:url repeat:NO];
}

+ (void)stopSystemSoundWithSoundID:(SystemSoundID)sound {
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
    AudioServicesDisposeSystemSoundID(sound);
    AudioServicesRemoveSystemSoundCompletion(sound);
}

void soundCompleteCallback(SystemSoundID sound, void * clientData) {
    //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);  //震动
    AudioServicesPlaySystemSound(sound);  // 播放系统声音 这里的sound是我自定义的，不要 copy 哈，没有的
}

+ (SystemSoundID)playWithUrl:(NSURL *)url repeat:(BOOL)repeat {
    if (url) {
        SystemSoundID soundID;
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
        if (error == kAudioServicesNoError) {
            NSLog(@"soundID = %d", soundID);
            //            AudioServicesPlayAlertSound(soundID);
            AudioServicesPlaySystemSound(soundID);
            if (repeat) {
                AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
            }
            return soundID;
        }else {
            NSLog(@"******Failed to create sound********");
            return 0;
        }
    }
    
    return 0;
}

@end
