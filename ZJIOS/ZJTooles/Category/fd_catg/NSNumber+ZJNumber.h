//
//  NSNumber+ZJNumber.h
//  ZJIOS
//
//  Created by Zengjian on 2021/7/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (ZJNumber)

// 判断数值是否在合理数值范围
- (NSInteger)validValueWithRange:(NSRange)range;
- (NSInteger)validValueWithRange:(NSRange)range defaultValue:(NSInteger)value;

@end

NS_ASSUME_NONNULL_END
