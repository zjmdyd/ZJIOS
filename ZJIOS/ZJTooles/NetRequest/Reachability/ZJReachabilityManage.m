//
//  ZJReachabilityManage.m
//  AoShiTong
//
//  Created by ZJ on 2018/8/24.
//  Copyright © 2018 HY. All rights reserved.
//

#import "ZJReachabilityManage.h"
#import "Reachability.h"

@interface ZJReachabilityManage()

@property (nonatomic, strong) Reachability *hostReachability;
@property (nonatomic, assign) BOOL noFirst;
@property (nonatomic, assign) NetworkStatus status;

@end

static ZJReachabilityManage *_manager = nil;

@implementation ZJReachabilityManage

+ (instancetype)shareManager {
    if (!_manager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _manager = [[ZJReachabilityManage alloc] init];
        });
    }
    
    return _manager;
}

- (void)startNotifier {
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chechStatus:) name:kReachabilityChangedNotification object:nil];
    if (!self.hostReachability) {
        self.hostReachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    }
    
    //启动监听
    [self.hostReachability startNotifier];
}

- (void)chechStatus:(NSNotification *)not {
    NetworkStatus status = self.hostReachability.currentReachabilityStatus;
    if (status == NotReachable) {
        _connectNet = NO;
        NSLog(@"无连接");
    }else {
        _connectNet = YES;
        if (status == ReachableViaWWAN) {
            NSLog(@"流量");
        }else {
            NSLog(@"WIFI");
        }
    }
    if (!self.noFirst) {
        self.status = status;
        self.noFirst = YES; return;
    }
    if (status != self.status) {
        self.status = status;
        [[NSNotificationCenter defaultCenter] postNotificationName:ReconnectNetwork object:@(status)];
    }
}

@end
