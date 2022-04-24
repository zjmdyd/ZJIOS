//
//  UIApplication+ZJApplication.h
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AppInfoType) {
    AppInfoTypeOfDisplayName,
    AppInfoTypeOfBundleName,
    AppInfoTypeOfVersion,
    AppInfoTypeOfBundleVersion,
    AppInfoTypeOfBundleIdentifier
};

@interface UIApplication (ZJApplication)

+ (CGFloat)getStatusBarHight;

/**
 获取当前屏幕显示的viewcontroller
 */
+ (UIViewController *)currentVC;
+ (UIViewController *)zj_getCurrentViewController;


#pragma mark - App info

+ (NSString *)appInfoWithType:(AppInfoType)type;

/**
 是否是企业版
 */
+ (BOOL)isComVersion;


//#pragma mark - 判断是否安装某APP

+ (BOOL)installedQQ;
+ (BOOL)installedWeiXin;
+ (BOOL)installedAlipay;

@end

NS_ASSUME_NONNULL_END
