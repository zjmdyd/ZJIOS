//
//  NSObject+ZJMethodSwizzling.h
//  ZJIOS
//
//  Created by issuser on 2021/11/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZJMethodSwizzling)

+ (void)exchangeMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

@end

NS_ASSUME_NONNULL_END
