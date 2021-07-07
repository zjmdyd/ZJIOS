//
//  ZJBLEDeviceManager.h
//  ZJFramework
//
//  Created by ZJ on 1/26/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

/**
 *  蓝牙的状态
 */
typedef NS_ENUM(NSUInteger, ZJDeviceManagerState) {
    ZJDeviceManagerStateUnknown = 0,
    ZJDeviceManagerStateResetting,
    ZJDeviceManagerStateUnsupported,
    ZJDeviceManagerStateUnauthorized,
    ZJDeviceManagerStatePoweredOff,
    ZJDeviceManagerStatePoweredOn,
};

@class ZJBLEDevice;

/**
 *  状态
 */
typedef void(^BLERefreshStateCompletionHandle)(ZJDeviceManagerState state);

/**
 *  回调方法里面主要执行刷新界面的代码
 */
typedef void(^BLERefreshCompletionHandle)(id obj);

/**
 *  连接操作回调
 */
typedef void(^BLEConnectCompletionHandle)(ZJBLEDevice *device, BOOL connected, NSError *error);

@interface ZJBLEDeviceManager : NSObject

/**
 *  已发现的BLE设备
 */
@property (nonatomic, strong, readonly) NSArray *discoveredBLEDevices;

/**
 *  已连接的BLE设备
 */
@property (nonatomic, strong, readonly) NSArray *connectedBLEDevices;

@property(nonatomic, readonly) ZJDeviceManagerState state;

/**
 *  设备断开之后是否自动执行搜索,默认为YES
 */
@property (nonatomic, getter=isAutomScan) BOOL automScan;
@property (nonatomic, copy) NSString *accessPrefix;

/**
 *  获取单例manager
 */
+ (instancetype)shareManager;

/**
 *  更新centralManager状态, 在回调方法里面对不同的状态进行处理
 */
+ (instancetype)shareManagerDidUpdateStateHandle:(BLERefreshStateCompletionHandle)completion;

/**
 *  **
 *  @param uuids      搜索包含服务特定服务uuid的设备
 *  @param completion 搜索结果的回调
 */
- (void)scanDeviceWithServiceUUIDs:(NSArray<CBUUID *> *)uuids completion:(BLERefreshCompletionHandle)completion;

- (void)scanDeviceWithServiceUUIDs:(NSArray<CBUUID *> *)uuids prefix:(NSString *)prefix completion:(BLERefreshCompletionHandle)completion;

/**
 *  连接设备
 *
 *  @param devices    需要连接的设备, 数组的元素是ZJBLEDevice对象类型
 *  @param completion 连接成功后的回调
 */
- (void)connectBLEDevices:(NSArray<ZJBLEDevice *> *)devices completion:(BLEConnectCompletionHandle)completion;

/**
 *  手动断开连接
 *
 *  @param devices    需要断开的设备, 数组的元素是ZJBLEDevice对象类型
 *  @param completion 断开连接后的回调
 */
- (void)cancelBLEDevicesConnection:(NSArray<ZJBLEDevice *> *)devices completion:(BLEConnectCompletionHandle)completion;

/**
 *  重新扫描
 */
- (void)rescan;

/**
 *  停止扫描
 */
- (void)stopScan;

/**
 *  重置,释放一些资源:因为本类的对象采用单例模式,所以当本类的功能完成时需要释放一些资源,防止内存泄漏
 */
- (void)reset;

@end
