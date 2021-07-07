//
//  NSMutableArray+ZJMutableArray.h
//  ZJIOS
//
//  Created by Zengjian on 2021/7/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (ZJMutableArray)


/**
 用某个特定的对象初始化数组
 */
+ (NSMutableArray *)arrayWithObject:(id)obj count:(NSInteger)count;
+ (NSMutableArray *)arrayWithEmptyObjectWithCount:(NSInteger)count;

- (void)resetBoolValues;
- (void)changeBoolValueAtIndex:(NSInteger)index needReset:(BOOL)need;

@end

NS_ASSUME_NONNULL_END
