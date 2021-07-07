//
//  ZJBLEDeviceManager.m
//  ZJFramework
//
//  Created by ZJ on 1/26/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJBLEDeviceManager.h"
#import "ZJBLEDevice.h"

@interface CBPeripheral (ZJPeripheral)

- (BOOL)isEqual:(CBPeripheral *)peripheral;

@end

@implementation CBPeripheral (ZJPeripheral)

- (BOOL)isEqual:(CBPeripheral *)peripheral {
    return [self.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString];
}

@end

@interface ZJBLEDeviceManager ()<CBCentralManagerDelegate> {
    NSArray *_searchServiceUUIDs;
    NSString *_prefix;
}

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) BLERefreshStateCompletionHandle stateCompletion;
@property (nonatomic, strong) BLERefreshCompletionHandle scanCompletion;
@property (nonatomic, strong) BLEConnectCompletionHandle connectCompletion;
@property (nonatomic, strong) BLEConnectCompletionHandle disConnectCompletion;

@end

static ZJBLEDeviceManager *_manager = nil;

@implementation ZJBLEDeviceManager

@synthesize state = _state;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSetting];
    }
    
    return self;
}

- (void)initSetting {
    self.automScan = YES;

    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

+ (instancetype)shareManager {
    if (!_manager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _manager = [[ZJBLEDeviceManager alloc] init];
        });
    }
    
    return _manager;
}

+ (instancetype)shareManagerDidUpdateStateHandle:(BLERefreshStateCompletionHandle)completion {
    if (!_manager) {
        _manager = [ZJBLEDeviceManager shareManager];
        _manager.stateCompletion = completion;
    }else {         // 手动刷新状态
        _manager.stateCompletion = completion;
        [_manager centralManagerDidUpdateState:_manager.centralManager];
    }
    
    return _manager;
}

- (void)scanDeviceWithServiceUUIDs:(NSArray<CBUUID *> *)uuids completion:(BLERefreshCompletionHandle)completion {
    _searchServiceUUIDs = uuids;
    /**
     *  本类自动scan传过来的回调都是nil,当不为nil时(在外部类中调用scan方法),应该更新扫描的回调
     */
    if (completion) {
        self.scanCompletion = completion;
    }

    if (_discoveredBLEDevices.count) {
        _discoveredBLEDevices = @[];
        if (self.scanCompletion) {
            self.scanCompletion(nil);
        }
    }
    NSLog(@"%s", __func__);
    [self.centralManager scanForPeripheralsWithServices:uuids options:nil];
}

- (void)scanDeviceWithServiceUUIDs:(NSArray<CBUUID *> *)uuids prefix:(NSString *)prefix completion:(BLERefreshCompletionHandle)completion {
    _prefix = prefix;
    [self scanDeviceWithServiceUUIDs:uuids completion:completion];
}

- (void)connectBLEDevices:(NSArray<ZJBLEDevice *> *)devices completion:(BLEConnectCompletionHandle)completion {
    for (ZJBLEDevice *device in devices) {
        if (device.peripheral.state == CBPeripheralStateDisconnected) {
            [self.centralManager connectPeripheral:device.peripheral options:nil];
        }
    }
    
    self.connectCompletion = completion;
}

- (void)cancelBLEDevicesConnection:(NSArray<ZJBLEDevice *> *)devices completion:(BLEConnectCompletionHandle)completion {
    for (ZJBLEDevice *device in devices) {
        [self.centralManager cancelPeripheralConnection:device.peripheral];
    }
    
    self.disConnectCompletion = completion;
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (self.stateCompletion) {
        self.stateCompletion((ZJDeviceManagerState)central.state);
    }
    
    if (self.automScan) {
        NSLog(@"%s", __func__);
        [central scanForPeripheralsWithServices:_searchServiceUUIDs options:nil];
    }
}

/**
 *  发现设备
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    BOOL b1 = _prefix && [peripheral.name hasPrefix:_prefix] == NO;
    BOOL b2 = self.accessPrefix && [peripheral.name hasPrefix:self.accessPrefix] == NO;

    if (b1 == YES) {
        if (self.accessPrefix) {
            if (b2 == YES) {
                return;
            }
        }else {
            return;
        }
    }
    
    NSLog(@"发现设备--->%@, %@", advertisementData, peripheral.identifier.UUIDString);
    NSMutableArray *ary = [NSMutableArray arrayWithArray:self.discoveredBLEDevices];
    for (int i = 0; i < ary.count; i++) {
        ZJBLEDevice *device = ary[i];
        if ([device.peripheral isEqual:peripheral]) {
            [ary removeObject:device];
            break;
        }
    }

    ZJBLEDevice *device = [[ZJBLEDevice alloc] initWithPeripheral:peripheral RSSI:RSSI];
    device.isSecreat = ![peripheral.name hasPrefix:@"BeneCheck GL-"];
    NSData *data = advertisementData[@"kCBAdvDataManufacturerData"];
    device.manufacturerData = data;
    if (data.length) {
        Byte *bytes = (Byte *)data.bytes;
        device.hasRegister = bytes[4] == 0x01;        
    }
    
    [ary addObject:device];
    _discoveredBLEDevices = [ary copy];
    
    /**
     *  不管是用户手动扫描还是automScan,都用scanCompletion回调
     */
    if (self.scanCompletion) {
        self.scanCompletion(_discoveredBLEDevices);
    }
}

/**
 *  已连接
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"%s", __func__);
    NSMutableArray *discoverAry = [NSMutableArray arrayWithArray:self.discoveredBLEDevices];
    NSMutableArray *connAry = [NSMutableArray arrayWithArray:self.connectedBLEDevices];
    
    ZJBLEDevice *device;
    for (int i = 0; i < discoverAry.count; i++) {
        device = discoverAry[i];
        if ([device.peripheral isEqual:peripheral]) {
            [connAry addObject:device];
            [discoverAry removeObject:device];
            
            break;
        }
    }
    _discoveredBLEDevices = [discoverAry copy];
    _connectedBLEDevices = [connAry copy];

    if (device) {
        self.connectCompletion(device, YES, nil);
    }
}

/**
 *  断开连接
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"%s, error = %@", __func__, error);
    NSMutableArray *connAry = [NSMutableArray arrayWithArray:self.connectedBLEDevices];
    
    ZJBLEDevice *device;
    for (int i = 0; i < connAry.count; i++) {
        device = connAry[i];
        if ([device.peripheral isEqual:peripheral]) {
            [connAry removeObject:device];
            break;
        }
    }
    _connectedBLEDevices = [connAry copy];
    
    if (self.isAutomScan) {
        [self scanDeviceWithServiceUUIDs:_searchServiceUUIDs completion:nil];
    }
    
    /**
     *  当有disconnectCompletion就用disconnectCompletion回调, 否则用connectionCompletion回调
     */
    if (self.disConnectCompletion) {
        self.disConnectCompletion(device, NO, error);
    }else if (self.connectCompletion) {
        self.connectCompletion(device, NO, error);
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"%s, error = %@", __func__, error);
    ZJBLEDevice *device = [[ZJBLEDevice alloc] initWithPeripheral:peripheral];
    if (self.connectCompletion) {
        self.connectCompletion(device, NO, error);
    }
}

#pragma mark - public

- (void)rescan {
    self.automScan = YES;
    [self scanDeviceWithServiceUUIDs:_searchServiceUUIDs completion:nil];
}

- (void)stopScan {
    self.automScan = NO;
    [self.centralManager stopScan];
}

- (void)reset {
    self.accessPrefix = @"";
    _discoveredBLEDevices = @[];
    self.scanCompletion = nil;
    self.stateCompletion = nil;
    self.disConnectCompletion = nil;
    if (self.connectedBLEDevices.count == 0) {
        self.connectCompletion = nil;        
    }
}

#pragma mark - getter

- (ZJDeviceManagerState)state {
    _state = (ZJDeviceManagerState)self.centralManager.state;
    return _state;
}

@end
