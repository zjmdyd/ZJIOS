//
//  SceneDelegate.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/12.
//

#import "SceneDelegate.h"
#import "AppDelegate.h"
#import "ZJMainTabBarViewController.h"
#import "NSTimer+ZJBlockTimer.h"

@interface SceneDelegate ()

@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SceneDelegate

/*
 调用顺序:
 1.启动:
 -[SceneDelegate sceneWillEnterForeground:]
 -[SceneDelegate sceneDidBecomeActive:]
 2.进入后台:
 -[SceneDelegate sceneWillResignActive:]
 -[SceneDelegate sceneDidEnterBackground:]
 3.进入前台:
 -[SceneDelegate sceneWillEnterForeground:]
 -[SceneDelegate sceneDidBecomeActive:]
 */

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    self.window.backgroundColor = [UIColor whiteColor];
    
    ZJMainTabBarViewController *tabBarCtrl = [[ZJMainTabBarViewController alloc] init];
    self.window.rootViewController = tabBarCtrl;
    [self.window makeKeyAndVisible];
    

    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    NSLog(@"%s", __func__);
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    NSLog(@"%s", __func__);
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    
    if (self.backgroundTaskIdentifier != UIBackgroundTaskInvalid){
        [self endBackgroundTask];
    }
}


- (void)sceneWillResignActive:(UIScene *)scene {
    NSLog(@"%s", __func__);
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    NSLog(@"%s", __func__);
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}

/*
 开启后台任务
 */
- (void)sceneDidEnterBackground:(UIScene *)scene {
    NSLog(@"%s", __func__);
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
    
    // Save changes in the application's managed object context when the application transitions to the background.
    NSTimeInterval backgroundTimeRemanging = [[UIApplication sharedApplication] backgroundTimeRemaining];
    NSLog(@"backgroundTimeRemanging = %.02f", backgroundTimeRemanging);
    
    if ([self isMutiltaskingSupported] == NO) {
        NSLog(@"--->不支持多任务");
        return;
    }
    
    UIApplication *app = [UIApplication sharedApplication];
    self.backgroundTaskIdentifier = [app beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"触发ExpirationHandler");
        [self endBackgroundTask];
    }];
//    [self test0];
    [(AppDelegate *)UIApplication.sharedApplication.delegate saveContext];
}

- (void)test0 {
    NSLog(@"%s", __func__);
    self.timer = [NSTimer zj_timerWithTimeInterval:1 repeats:YES addToRunLoopWithMode:NSDefaultRunLoopMode block:^(NSTimer * _Nonnull timer) {
        NSTimeInterval backgroundTimeRemanging = [[UIApplication sharedApplication] backgroundTimeRemaining];
        if (backgroundTimeRemanging == DBL_MAX) {
            NSLog(@"Background Time Remaining = Undeterminded");
        }
        //--显示后台任务还剩余的时间
        NSLog(@"Background Timer Remaining = %.02f Seconds", backgroundTimeRemanging);
    }];
}

// 任务完成，处理释放对象
- (void)endBackgroundTask {
    NSLog(@"%s", __func__);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    __weak SceneDelegate *weakSelf = self;
    dispatch_async(mainQueue, ^{
        if (weakSelf != nil) {
            [weakSelf.timer invalidate];
            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
            weakSelf.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        }
    });
}

- (BOOL)isMutiltaskingSupported {
    BOOL result = NO;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) {
        result = [[UIDevice currentDevice] isMultitaskingSupported];
    }
    
    return result;
}

@end
