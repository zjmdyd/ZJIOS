//
//  ZJReachabilityManage.h
//  AoShiTong
//
//  Created by ZJ on 2018/8/24.
//  Copyright © 2018 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ReconnectNetwork @"ReconnectNetwork"

@interface ZJReachabilityManage : NSObject

+ (instancetype)shareManager;
- (void)startNotifier;
@property (nonatomic, assign, readonly) BOOL connectNet;  // 连接网络

@end
