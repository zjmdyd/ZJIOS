//
//  UIDevice+ZJDevice.m
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import "UIDevice+ZJDevice.h"
#import <sys/stat.h>
#import "sys/utsname.h"
#import <AVFoundation/AVCaptureDevice.h>

@implementation UIDevice (ZJDevice)

+ (BOOL)authorizationStatusForMediaType:(AVMediaType)type {
    NSString *mediaType = type; // 读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType]; // 读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        return NO;
    }
    
    return YES;
}

+ (NSString *)systemVersion {
    return [UIDevice currentDevice].systemVersion;
}

/**
 获取设备名称
 */
+ (NSString *)iPhoneType {
    struct utsname systemInfo;
    uname(&systemInfo); // 获取系统设备信息
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    NSDictionary *dict = @{
                           // iPhone
                           @"iPhone4,1" : @"iPhone 4s",
                           @"iPhone5,3" : @"iPhone 5c",
                           @"iPhone5,4" : @"iPhone 5c",
                           @"iPhone6,1" : @"iPhone 5s",
                           @"iPhone6,2" : @"iPhone 5s",
                           @"iPhone7,1" : @"iPhone 6 Plus",
                           @"iPhone7,2" : @"iPhone 6",
                           @"iPhone8,1" : @"iPhone 6s",
                           @"iPhone8,2" : @"iPhone 6s Plus",
                           @"iPhone8,4" : @"iPhone SE",
                           @"iPhone9,1" : @"iPhone 7",
                           @"iPhone9,2" : @"iPhone 7 Plus",
                           @"iPhone10,1" : @"iPhone 8",
                           @"iPhone10,4" : @"iPhone 8",
                           @"iPhone10,2" : @"iPhone 8 Plus",
                           @"iPhone10,5" : @"iPhone 8 Plus",
                           @"iPhone10,3" : @"iPhone X",
                           @"iPhone10,6" : @"iPhone X",
                           @"iPhone11,2" : @"iPhone XS",
                           @"iPhone11,4" : @"iPhone XS Max",
                           @"iPhone11,6" : @"iPhone XS Max",
                           @"iPhone11,8" : @"iPhone XR",
                           @"i386" : @"iPhone Simulator",
                           @"x86_64" : @"iPhone Simulator",
                           // iPad
                           @"iPad4,1" : @"iPad Air",
                           @"iPad4,2" : @"iPad Air",
                           @"iPad4,3" : @"iPad Air",
                           @"iPad5,3" : @"iPad Air 2",
                           @"iPad5,4" : @"iPad Air 2",
                           @"iPad6,7" : @"iPad Pro 12.9",
                           @"iPad6,8" : @"iPad Pro 12.9",
                           @"iPad6,3" : @"iPad Pro 9.7",
                           @"iPad6,4" : @"iPad Pro 9.7",
                           @"iPad6,11" : @"iPad 5",
                           @"iPad6,12" : @"iPad 5",
                           @"iPad7,1" : @"iPad Pro 12.9 inch 2nd gen",
                           @"iPad7,2" : @"iPad Pro 12.9 inch 2nd gen",
                           @"iPad7,3" : @"iPad Pro 10.5",
                           @"iPad7,4" : @"iPad Pro 10.5",
                           @"iPad7,5" : @"iPad 6",
                           @"iPad7,6" : @"iPad 6",
                           // iPad mini
                           @"iPad2,5" : @"iPad mini",
                           @"iPad2,6" : @"iPad mini",
                           @"iPad2,7" : @"iPad mini",
                           @"iPad4,4" : @"iPad mini 2",
                           @"iPad4,5" : @"iPad mini 2",
                           @"iPad4,6" : @"iPad mini 2",
                           @"iPad4,7" : @"iPad mini 3",
                           @"iPad4,8" : @"iPad mini 3",
                           @"iPad4,9" : @"iPad mini 3",
                           @"iPad5,1" : @"iPad mini 4",
                           @"iPad5,2" : @"iPad mini 4",
                           // Apple Watch
                           @"Watch1,1" : @"Apple Watch",
                           @"Watch1,2" : @"Apple Watch",
                           @"Watch2,6" : @"Apple Watch Series 1",
                           @"Watch2,7" : @"Apple Watch Series 1",
                           @"Watch2,3" : @"Apple Watch Series 2",
                           @"Watch2,4" : @"Apple Watch Series 2",
                           @"Watch3,1" : @"Apple Watch Series 3",
                           @"Watch3,2" : @"Apple Watch Series 3",
                           @"Watch3,3" : @"Apple Watch Series 3",
                           @"Watch3,4" : @"Apple Watch Series 3",
                           @"Watch4,1" : @"Apple Watch Series 4",
                           @"Watch4,2" : @"Apple Watch Series 4",
                           @"Watch4,3" : @"Apple Watch Series 4",
                           @"Watch4,4" : @"Apple Watch Series 4"
                           };
    NSString *name = dict[platform];
    
    return name ? name : platform;
}

+ (BOOL)jailbroken {
    struct stat stat_info;
    if (0 == stat("/Applications/Cydia.app", &stat_info)) {
        NSLog(@"Device is jailbroken");
        return YES;
    }
    
    return NO;
}

@end

/// APP信息:
/*
 //手机序列号
 NSString* identifierNumber = [[UIDevice currentDevice] uniqueIdentifier];
 NSLog(@"手机序列号: %@",identifierNumber);
 //手机别名： 用户定义的名称
 NSString* userPhoneName = [[UIDevice currentDevice] name];
 NSLog(@"手机别名: %@", userPhoneName);
 //设备名称
 NSString* deviceName = [[UIDevice currentDevice] systemName];
 NSLog(@"设备名称: %@",deviceName );
 //手机系统版本
 NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
 NSLog(@"手机系统版本: %@", phoneVersion);
 //手机型号
 NSString* phoneModel = [[UIDevice currentDevice] model];
 NSLog(@"手机型号: %@",phoneModel );
 //地方型号  （国际化区域名称）
 NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
 NSLog(@"国际化区域名称: %@",localPhoneModel );
 */
