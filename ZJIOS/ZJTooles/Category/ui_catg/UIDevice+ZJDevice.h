//
//  UIDevice+ZJDevice.h
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (ZJDevice)

+ (NSString *)systemVersion;

// 授权判断
+ (BOOL)authorizationStatusForMediaType:(AVMediaType)type;

+ (NSString *)iPhoneType;

/**
 检测设备是否越狱
 */
+ (BOOL)jailbroken;

@end

NS_ASSUME_NONNULL_END
