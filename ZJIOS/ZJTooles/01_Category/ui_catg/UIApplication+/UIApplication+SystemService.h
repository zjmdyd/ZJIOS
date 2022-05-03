//
//  UIApplication+SystemService.h
//  ZJIOS
//
//  Created by issuser on 2021/10/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SystemServiceType) {
    SystemServiceTypePhone,
    SystemServiceTypeMessage,
};

@interface UIApplication (SystemService)

+ (void)systemServiceWithPhone:(NSString *)phone type:(SystemServiceType)type;
+ (void)openURLWithURLString:(NSString *)urlString completionHandler:(void (^)(BOOL success))completion;
+ (void)openAppDownloadPageWithAppID:(NSString *)appID;

@end

NS_ASSUME_NONNULL_END
