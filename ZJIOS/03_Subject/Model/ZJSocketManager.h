//
//  ZJSocketManager.h
//  ZJIOS
//
//  Created by Zengjian on 2021/7/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJSocketManager : NSObject

+ (instancetype)share;
- (void)connect;
- (void)disConnect;
- (void)sendMsg:(NSString *)msg;

@end

NS_ASSUME_NONNULL_END
