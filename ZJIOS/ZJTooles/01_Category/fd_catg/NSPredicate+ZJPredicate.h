//
//  NSPredicate+ZJPredicate.h
//  ZJIOS
//
//  Created by issuser on 2021/11/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSPredicate (ZJPredicate)

+ (BOOL)judgeLetterWithString:(NSString *)string;
+ (BOOL)hasNumber:(NSString *)string;
+ (BOOL)isValidPhone:(NSString *)string;
+ (BOOL)isValidID:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
