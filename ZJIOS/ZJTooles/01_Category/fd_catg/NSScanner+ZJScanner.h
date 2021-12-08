//
//  NSScanner+ZJScanner.h
//  ZJIOS
//
//  Created by issuser on 2021/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSScanner (ZJScanner)

+ (BOOL)isPureInt:(NSString *)string;
+ (BOOL)isPureFloat:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
