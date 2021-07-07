//
//  ZJBLEDevice.h
//  ZJFramework
//
//  Created by ZJ on 1/26/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef NS_ENUM(NSInteger, ReadDataType) {
    ReadDataTypeOfGL,       // 血糖
    ReadDataTypeOfUA,       // 尿酸
    ReadDataTypeOfBF,       // 血脂
    ReadDataTypeOfBP,       // 血压
    ReadDataTypeOfTZ,       // 体脂
    ReadDataTypeOfBFCardio, // 卡迪克血脂
};

typedef void(^DeviceDiscoverServiceCompletionHandle)(CBCharacteristic *obj, NSError *error);
typedef void(^DeviceUpdateValueCompletionHandle)(BOOL success, id value, NSString *time, NSError *error);

@interface ZJBLEDevice : NSObject

- (instancetype)init NS_UNAVAILABLE;

/**
 *  每个BLEDevice对象对应一个peripheral
 */
- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral;
- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral RSSI:(NSNumber *)rssi;

/**
 *  Pointer to CoreBluetooth peripheral
 */
@property (nonatomic, strong, readonly) CBPeripheral *peripheral;

/**
 *  Pointer to CoreBluetooth manager that found this peripheral
 */
@property (nonatomic, strong) CBCentralManager *manager;

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *identify;
@property (nonatomic, strong, readonly) NSNumber *RSSI;
@property (nonatomic, strong, readonly) NSArray *services;
@property (nonatomic, strong) NSData *kCBAdvDataManufacturerData;
@property (nonatomic, assign) BOOL isSecreat;   // 是否是私有协议
@property (nonatomic, assign) BOOL isSecreat2;   // 是否是私有协议2
@property (nonatomic, assign) BOOL hasRegister;
@property (nonatomic, strong) NSData *manufacturerData;
@property (nonatomic, assign) Byte *deviceID;

- (void)discoverServices:(NSArray<CBUUID *> *)serviceUUIDs completion:(DeviceDiscoverServiceCompletionHandle)completion;

- (void)readValueWithType:(ReadDataType)type completion:(DeviceUpdateValueCompletionHandle)completion;

@end
