//
//  NSObject+SwizzleMethod.h
//  ZJIOS
//
//  Created by Zengjian on 2021/6/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SwizzleMethod)

- (void)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector;

@end

NS_ASSUME_NONNULL_END
