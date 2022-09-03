//
//  UIApplication+International.h
//  ZJIOS
//
//  Created by issuser on 2021/10/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (International)
/**
 简体中文判断
 */
+ (BOOL)isSimplifiedChinese;
+ (NSString *)getLanguageTitleWithAbbr:(NSString *)abbr;

@end

NS_ASSUME_NONNULL_END
