//
//  NSObject+ZJRuntime.h
//  ZJIOS
//
//  Created by Zengjian on 2021/7/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZJRuntime)

/**
 * 获取对象的所有属性
 */
- (NSArray *)objectProperties;
- (id)nextResponderWithTargetClassName:(NSString *)className;

- (void)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector;

@end

NS_ASSUME_NONNULL_END
