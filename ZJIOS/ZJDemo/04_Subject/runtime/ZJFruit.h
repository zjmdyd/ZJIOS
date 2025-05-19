//
//  ZJFruit.h
//  ZJIOS
//
//  Created by Zengjian on 2021/6/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJFruit : NSObject

@end

@interface ZJFruit ()

- (void)testExtention;    // 扩展中能够的方法必须实现

@property (nonatomic, copy) NSString *name;

@end
NS_ASSUME_NONNULL_END
