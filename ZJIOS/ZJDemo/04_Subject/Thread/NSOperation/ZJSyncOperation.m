//
//  ZJSyncOperation.m
//  ZJIOS
//
//  Created by Zengjian on 2025/5/16.
//

#import "ZJSyncOperation.h"

@implementation ZJSyncOperation

#pragma mark - NSOperation Methods

- (void)main {
    NSLog(@"%s", __func__);
    
    for (int i = 0; i < 5; i++) {
        [NSThread sleepForTimeInterval:1];
        NSLog(@"main方法");
    }
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

/*
 在Objective-C中自定义NSOperation需要根据同步/异步需求采用不同实现方式，以下是关键要点和示例：

 一、同步Operation实现要点

 只需重写main方法作为执行入口
 必须添加自动释放池避免内存泄漏
 需定期检查isCancelled状态响应取消操作
 
 二、异步Operation实现要点

 需重写start方法而非main
 必须手动管理isExecuting和isFinished状态
 状态变更需触发KVO通知
 需要重写isConcurrent返回YES
 三、通用注意事项

 初始化方法应返回instancetype类型
 避免在非主线程修改UI控件
 使用@try@catch捕获异常
 注意completionBlock的循环引用问题
 
 */
@end
