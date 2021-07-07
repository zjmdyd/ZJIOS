//
//  UIApplication+ZJApplication.h
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SystemServiceType) {
    SystemServiceTypeOfPone,
    SystemServiceTypeOfMessage,
};

typedef NS_ENUM(NSInteger, AppInfoType) {
    AppInfoTypeOfDisplayName,
    AppInfoTypeOfBundleName,
    AppInfoTypeOfVersion,
    AppInfoTypeOfBundleVersion,
    AppInfoTypeOfBundleIdentifier
};

@interface UIApplication (ZJApplication)

/**
 获取当前屏幕显示的viewcontroller
 */
+ (UIViewController *)currentVC;
+ (UIViewController *)zj_getCurrentViewController;

/**
 *  Cookie
 */
- (void)synCooks;
- (void)storeCooks;
- (void)removeCooks;

#pragma mark - 声音

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

#pragma mark - 系统服务

+ (void)systemServiceWithPhone:(NSString *)phone type:(SystemServiceType)type;
+ (void)openURLWithURLString:(NSString *)urlString completionHandler:(void (^)(BOOL success))completion;
+ (void)openAppDownloadPage:(NSString *)appID;

#pragma mark - App info

+ (NSString *)appInfoWithType:(AppInfoType)type;

/**
 是否是企业版
 */
+ (BOOL)isComVersion;

/**
 简体中文判断
 */
+ (BOOL)isSimplifiedChinese;
+ (NSString *)getLanguageTitleWithAbbr:(NSString *)abbr;

#pragma mark - Network state

/**
 *  获取网络状态
 */
+ (NSString *)netWorkStates;

/**
 * 获取当前WiFi信息 {
 BSSID = "82:89:17:c4:b2:43";
 SSID = hanyou03;
 SSIDDATA = <68616e79 6f753033>;
 }*/
+ (id)fetchCurrentWiFiInfo;

+ (NSString *)ipAddress;

//#pragma mark - 判断是否安装某APP

+ (BOOL)installedQQ;
+ (BOOL)installedWeiXin;
+ (BOOL)installedAlipay;

@end

NS_ASSUME_NONNULL_END
