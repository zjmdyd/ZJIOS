//
//  UIApplication+Network.h
//  ZJIOS
//
//  Created by issuser on 2021/10/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (Network)

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

@end

NS_ASSUME_NONNULL_END
