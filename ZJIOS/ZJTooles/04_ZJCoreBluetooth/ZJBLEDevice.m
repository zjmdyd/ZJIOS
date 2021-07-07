//
//  ZJBLEDevice.m
//  ZJFramework
//
//  Created by ZJ on 1/26/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJBLEDevice.h"
#import <UIKit/UIKit.h>

@interface ZJBLEDevice () <CBPeripheralDelegate> {
    NSMutableData *_data;
    BOOL _hasACK1, _hasACK2, _hasSendACKBack1;
    BOOL _hasSendACKBack2, _loginACK;
    BOOL _hasSendSyn, _synACK;
}

@property (nonatomic, strong) DeviceDiscoverServiceCompletionHandle discoverServiceCompletion;
@property (nonatomic, strong) CBCharacteristic *normalCharacteristic;
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;    // 血压用

// 体脂称
@property (nonatomic, strong) CBCharacteristic *ackWriteCharacteristic;     // APP-->设备 消息确认
@property (nonatomic, strong) CBCharacteristic *ackReceiveCharacteristic;   // 设备-->APP 收到确认消息
@property (nonatomic, strong) CBCharacteristic *writeWRCharacteristic;      // APP-->设备 写有反馈
@property (nonatomic, strong) CBCharacteristic *writeWNCharacteristic;      // APP-->设备 写无反馈

@property (nonatomic, strong) CBCharacteristic *notifyReceiveCharacteristic;   // 设备-->APP 收到通知消息
@property (nonatomic, strong) CBCharacteristic *notifyReceiveCharacteristic2;   // APP-->设备 --> Indicate

@property (nonatomic, strong) DeviceUpdateValueCompletionHandle valueCompletion;
@property (nonatomic, assign) ReadDataType readDataType;

@end

static NSString *GLCTUUID = @"2A18";
static NSString *GLCTUUID2 = @"1002";

// 血压
static NSString *BPCTREADUUID = @"0000FFF1";
static NSString *BPCTWRITEUUID = @"0000FFF2";

// 卡迪克血脂
static NSString *CardioServiceUUID = @"FFE0";
static NSString *CardioCTUUID = @"FFE4";

// 体脂
static NSString *TZServiceUUID = @"A602";

static NSString *TZACKWriteCTUUID = @"A622";    // app-->设备 消息确认
static NSString *TZACKReceiveCTUUID = @"A625";  // 设备-->APP 收到确认消息
static NSString *TZWRCTUUID = @"A623";          // APP-->设备 写有反馈
static NSString *TZWNCTUUID = @"A624";          // APP-->设备 写无反馈
static NSString *TZNOTIFYReceiveCTUUID = @"A621";   // 设备-->APP 收到通知消息
static NSString *TZNOTIFYReceiveCTUUID2 = @"A620";   // APP-->设备 --> Indicate

@implementation ZJBLEDevice

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral {
    self = [super init];
    if (self) {
        [self initSettingWithPeriphera:peripheral];
    }
    
    return self;
}

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral RSSI:(NSNumber *)rssi {
    self = [super init];
    if (self) {
        [self initSettingWithPeriphera:peripheral];
        _RSSI = rssi;
    }
    
    return self;
}

- (void)initSettingWithPeriphera:(CBPeripheral *)peripheral {
    _peripheral = peripheral;
    _peripheral.delegate = self;
    _name = peripheral.name;
    _identify = peripheral.identifier.UUIDString;
}

- (void)discoverServices:(NSArray<CBUUID *> *)serviceUUIDs completion:(DeviceDiscoverServiceCompletionHandle)completion {
    self.discoverServiceCompletion = completion;
    [self.peripheral discoverServices:serviceUUIDs];
}

- (void)readValueWithType:(ReadDataType)type completion:(DeviceUpdateValueCompletionHandle)completion {
    self.readDataType = type;
    self.valueCompletion = completion;
    
//    if (type < ReadDataTypeOfBP) {    // 同步时间
//        Byte bytes[17] = {0x24, 0x50, 0x43, 0x4c, 0X11, 0x00, 0x00, 0x00, 0x06, 0x00, 0x12, 0x04, 0x02, 0x10, 0x0B, 0x00};
//        Byte check = 0x00;
//        for (int i = 0; i < 16; i++) {
//            check += bytes[i];
//        }
//        bytes[16] = check;
//
//        NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)/sizeof(Byte)];
//
//        [self.peripheral writeValue:data forCharacteristic:self.normalCharacteristic type:CBCharacteristicWriteWithResponse];
//    }else
    if (type == ReadDataTypeOfBP) {
        Byte bytes[] = {0xFD, 0xFD, 0xFA, 0x05, 0X0D, 0x0A};
        NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)/sizeof(Byte)];
        [self writeWithData:data type:CBCharacteristicWriteWithoutResponse];
    }else if (type == ReadDataTypeOfTZ) {
        Byte deviceID[] = {0x11, 0x02, 0X03, 0x04, 0x05, 0x06};
        self.deviceID = deviceID;
        
        if (!self.hasRegister) { // 注册设备
            Byte bytes[] = {0x10, 0x09, 0x00, 0x01, 0x11, 0x02, 0X03, 0x04, 0x05, 0x06, 0x01};
            NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)/sizeof(Byte)];
            [self.peripheral writeValue:data forCharacteristic:self.writeWNCharacteristic type:CBCharacteristicWriteWithoutResponse];
        }else {
            
        }
    }
}

- (void)writeWithData:(NSData *)data type:(CBCharacteristicWriteType)type {
    if (self.writeCharacteristic) {
        [self.peripheral writeValue:data forCharacteristic:self.writeCharacteristic type:type];
    }
}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    NSLog(@"-->services = %@", peripheral.services);
    _services = peripheral.services;
    
    for (CBService *sev in peripheral.services) {
//        if ([sev.UUID.UUIDString isEqualToString:@"1000"] || [self isTZDevice:sev]) {
            [peripheral discoverCharacteristics:nil forService:sev];
//        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    NSLog(@"-->characteristics = %@", service.characteristics);
    
    if ([self isTZDevice:service]) {  // 体脂设备
        for (CBCharacteristic *ct in service.characteristics) {
            if ([ct.UUID.UUIDString isEqualToString:TZACKWriteCTUUID]) {
                self.ackWriteCharacteristic = ct;
            }else if ([ct.UUID.UUIDString isEqualToString:TZACKReceiveCTUUID]) {    /// A625
                self.ackReceiveCharacteristic = ct;
                [self.peripheral setNotifyValue:YES forCharacteristic:ct];
            }else if ([ct.UUID.UUIDString isEqualToString:TZWRCTUUID]) {            /// A623
                self.writeWRCharacteristic = ct;
                [self.peripheral setNotifyValue:YES forCharacteristic:ct];
            }else if ([ct.UUID.UUIDString isEqualToString:TZWNCTUUID]) {
                self.writeWNCharacteristic = ct;
            }else if ([ct.UUID.UUIDString isEqualToString:TZNOTIFYReceiveCTUUID]) { /// A621
                self.notifyReceiveCharacteristic = ct;
                [self.peripheral setNotifyValue:YES forCharacteristic:ct];
            }else if ([ct.UUID.UUIDString isEqualToString:TZNOTIFYReceiveCTUUID2]) { /// A620
                self.notifyReceiveCharacteristic = ct;
                [self.peripheral setNotifyValue:YES forCharacteristic:ct];
            }
        }
    }else {
        for (CBCharacteristic *ct in service.characteristics) {
            if ([ct.UUID.UUIDString isEqualToString:GLCTUUID] || [ct.UUID.UUIDString isEqualToString:GLCTUUID2]) {  // 血糖、尿酸、血脂(胆固醇)
                self.normalCharacteristic = ct;
                [self.peripheral setNotifyValue:YES forCharacteristic:ct];
                break;
            }else if ([ct.UUID.UUIDString isEqualToString:CardioCTUUID]) {  // 血脂(卡迪克)
                self.normalCharacteristic = ct;
                [self.peripheral setNotifyValue:YES forCharacteristic:ct];
                break;
            }else if ([ct.UUID.UUIDString hasPrefix:BPCTREADUUID]) {  // 血压读
                self.normalCharacteristic = ct;
                [self.peripheral setNotifyValue:YES forCharacteristic:ct];
            }else if ([ct.UUID.UUIDString hasPrefix:BPCTWRITEUUID]) {  // 血压写
                self.writeCharacteristic = ct;
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"%s, %@", __func__, error);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    NSLog(@"%s", __func__);
    NSLog(@"%@", characteristic);
    NSLog(@"value = %@, len = %lu", characteristic.value, characteristic.value.length);
    NSData *data = characteristic.value;
    Byte *bytes = (Byte *)data.bytes;   // 0x69b1-->0xb1 69
    if (data.length) {
        if (self.readDataType <= ReadDataTypeOfBF && data.length > 2) {
            BOOL noMatch1 = (bytes[1] == 0x41 || bytes[4] == 0x41) && self.readDataType != ReadDataTypeOfGL;
            BOOL noMatch2 = (bytes[1] == 0x51 || bytes[4] == 0x51) && self.readDataType != ReadDataTypeOfUA;
            BOOL noMatch3 = (bytes[1] == 0x61 || bytes[4] == 0x61) && self.readDataType != ReadDataTypeOfBF;
            
            if (noMatch1 || noMatch2 || noMatch3) {
                if (self.valueCompletion) {
                    self.valueCompletion(NO, @(0), @"", error);
                }
                return;
            }
            
            BOOL isTwo = [characteristic.UUID.UUIDString isEqualToString:GLCTUUID]; // 包含两种协议的设备    2a18
            if (isTwo) {
                // 时间
                NSArray *units = @[@"-", @"-", @" ", @":", @":", @""];
                
                unsigned short times[units.count];
                for (int i = 0; i < units.count; i++) {
                    if (i == 0) {
                        times[i] = [data valueWithIdx1:3 idx2:4];
                    }else {
                        times[i] = bytes[4+i];
                    }
                }
                NSMutableString *str = @"".mutableCopy;
                for (int i = 0; i < units.count; i++) {
                    //[str appendString:[NSString stringWithFormat:@"%02d%@", times[i], units[i]]];
                }
                NSLog(@"time = %@", str);
                
                short value1 = [data valueWithIdx1:10 idx2:11];
                short value2 = value1 & 0x0fff; // 169
                Byte byte1 = bytes[11];         // b1
                Byte byte2 = byte1 & 0xf0;      // b0
                Byte byte3 = byte2 / 16;        // b
                NSLog(@"%d, %0x, %0x, %0x, %0x", value1, value2, byte1, byte2, byte3);
                CGFloat value = value2 * pow(10, byte3-16);
                NSLog(@"%lf", value);
                
                if (self.valueCompletion) {
                    self.valueCompletion(YES, @(value*1000), str, error);
                }
            }else { // 百捷私有协议
                // 时间
                Byte times[5];
                for (int i = 0; i < 5; i++) {
                    times[i] = bytes[12+i];
                }
                NSArray *units = @[@"-", @"-", @" ", @":", @""];
                NSMutableString *str = @"".mutableCopy;
                for (int i = 0; i < units.count; i++) {
                    [str appendString:[NSString stringWithFormat:@"%02d%@", times[i], units[i]]];
                }
                [str insertString:@"20" atIndex:0];
                [str appendString:@":00"];
                NSLog(@"time = %@", str);
                
                // 值
                float idxValues[3] = {18.0, 16.81, 38.66};
                short value1 = [data valueWithIdx1:17 idx2:18];
                CGFloat value = value1 / idxValues[self.readDataType];
                
                NSLog(@"%d, %f", value1, value);
                if (self.valueCompletion) {
                    if (self.readDataType == ReadDataTypeOfUA) {
                        value = value * 0.1;
                    }
                    self.valueCompletion(YES, @(value), str, error);
                }
            }
        }else if (self.readDataType == ReadDataTypeOfBFCardio) {
            if (!_data) {
                _data = [[NSMutableData alloc] initWithData:data];
            }else {
                [_data appendData:data];
                if (data.length == 6 && (bytes[0] == 0x0d && bytes[1] == 0x0a)) {
                    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                    NSString *string = [[NSString alloc] initWithData:_data encoding:gbkEncoding];
                    NSLog(@"string = %@", string);
                    NSArray *strs = [string componentsSeparatedByString:@"\n"];    // 所有行
                    NSArray *titles = @[@"CHOL", @"TRIG", @"HDLCHOL", @"CALCLDL"];
                    NSMutableArray *values = [NSMutableArray arrayWithObject:@"0" count:titles.count];
                    for (int i = 0; i < titles.count; i++) {
                        for (int j = 0; j < strs.count; j++) {
                            NSArray *lineStrings = [strs[j] componentsSeparatedByString:@":"];
                            NSString *v0 = lineStrings[0];   // 标题所在
                            NSString *v2 = lineStrings[1];   // 值所在
                            if ([v0 containsString:titles[i]]) {
                                NSArray *v2Strs = [v2 componentsSeparatedByString:@" "];    // 值用空格分割
                                for (NSString *v2s in v2Strs) {
                                    NSString *str = [v2s stringByReplacingOccurrencesOfString:@" " withString:@""];
                                    if ([str hasNumber]) {
                                        NSLog(@"matchValue = %@", str);
                                        [values replaceObjectAtIndex:i withObject:str];
                                        break;
                                    }
                                }
                                break;
                            }
                        }
                    }
                    if (self.valueCompletion) {
                        self.valueCompletion(YES, values, @"", error);
                    }
                }
            }
        }else if(self.readDataType == ReadDataTypeOfBP) {   // 血压
            if (data.length == 21 || data.length == 16) {
                NSLog(@"高压:%d", bytes[3]);
                NSLog(@"低压:%d", bytes[4]);
                NSLog(@"心率:%d", bytes[5]);
                NSInteger v1 = bytes[3], v2 = bytes[4], v3 = bytes[5];
                
                NSArray *values = @[@(v1).stringValue, @(v2).stringValue, @(v3).stringValue];
                if (self.valueCompletion) {
                    self.valueCompletion(YES, values, @"", error);
                }
            }else if(data.length == 8) {
                NSLog(@"高压:%d", bytes[3]);
                NSLog(@"低压:%d", bytes[4]);
                NSLog(@"心率:%d", bytes[5]);
            }
        }else if(self.readDataType == ReadDataTypeOfTZ) {
            if (!self.hasRegister) {
                if (!_hasSendACKBack1) {
                    if (data.length == 3 && bytes[1] == 0x01) { // 注册设备请求的数据确认包
                        if (!_hasACK1) {
                            _hasACK1 = YES;
                        }
                    }
                    if (data.length == 5 && bytes[1] == 0x03 && [characteristic.UUID.UUIDString isEqualToString:TZNOTIFYReceiveCTUUID]) { // 注册设备请求的数据确认包
                        if (!_hasACK2) {
                            _hasACK2 = YES;
                        }
                    }
                    if (_hasACK1 && _hasACK2 && _hasSendACKBack1 == NO) {
                        _hasSendACKBack1 = YES;
                        self.hasRegister = YES;
                        [self ackBack];
                    }
                }
            }else {
                if (data.length == 5 && bytes[1] == 0x03 && [characteristic.UUID.UUIDString isEqualToString:TZNOTIFYReceiveCTUUID]) { // 注册设备请求的数据确认包
                    if (!_hasACK2) {
                        _hasACK2 = YES;
                    }
                    [self ackBack];
                }else if (data.length == 12 && bytes[2] == 0x00 && bytes[3] == 0x07 && _hasSendACKBack2 == NO) { // 同步数据请求数据确认包
                    [self ackBack];
                    [self loginBack];
                }else if (data.length == 3 && _loginACK == NO) {   // 登录回复数据包确认
                    _loginACK = YES;
                    [self synData];
                }else if (data.length == 18) {// A621
                    NSLog(@"同步数据确认");
                    short valueIndex = [data valueWithIdx1:5 idx2:4];
                    if (valueIndex > 0) {
                        [self ackBack]; return;
                    }
                    
                    _synACK = YES;
                    
                    CGFloat value = [data valueWithIdx1:11 idx2:10] / 100.0;  // 体重
                    NSLog(@"value = %f", value);
                    
                    short flagValue0 = [data valueWithIdx1:9 idx2:8];
                    short flagValue1 = bitReverse(flagValue0);
                    NSLog(@"%d", flagValue1);
                    
                    Byte byte1 = (flagValue1 & 0xff00) >> 8;
                    Byte byte2 = (flagValue1 & 0xff);
                    NSLog(@"byte1 = %d, byte2 = %d", byte1, byte2);

                    short flagBits[13];     // 0x4008二进制倒序的2-14位: 标识每位是0还是1
                    short byteLens[13] = {1, 4, 1, 7, 2, 2, 2, 2, 2, 2, 2, 2, 2};   // 每位存在的话对应的数值的byte长度
                    int byteValues[13];     // 每位存在的话对应的数值

                    for (int i = 0; i < 14; i++) {
                        if (i < 6) {
                            flagBits[i] = byte1 & (0x20 >> i);
//                            NSLog(@"0x%02x, 0x%02x, i = %d", byte1, (0x20 >> i), i);
                        }else {
                            flagBits[i] = byte2 & (0x80 >> (i-6));
//                            NSLog(@"0x%02x, 0x%02x, i = %d", byte2, (0x80 >> (i-6)), i);
                        }
                    }
                    short byteLenOffset = 0;
                    
                    for (int i = 0; i < 14; i++) {
                        short flagBit = flagBits[i];
                        if (flagBit > 0) {
                            short byteLen = byteLens[i];
                            
                            int byteVal[4];
                            int byteValue = 0;
                            for (int j = 0; j < byteLen; j++) {
                                int a = (bytes[12 + byteLenOffset + j] & 0xff) << ((byteLen-1-j)*8);    // byteLen个字节int型数据每个字节的值
                                //NSLog(@"i = %d, j = %d, index = %d, 0x%02x, offset = %d", i, j, 12 + byteLenOffset + j, bytes[12 + byteLenOffset + j] & 0xff, (byteLen-1-j)*8);

                                byteVal[j] = a;
                            }
                            for (int j = 0; j < byteLen; j++) {
                                byteValue |= byteVal[j];
                            }
                            byteValues[i] = byteValue;
                            byteLenOffset += byteLen;
                        }
                    }
                    
                    if (byteValues[12] <= 0) {
                        [self ackBack];

                        if (self.valueCompletion) {
                            self.valueCompletion(YES, @[@(value), @(0)], nil, error);
                        }
                        return;
                    }
                    
                    CGFloat Height = [UserInfo[@"height"] floatValue]/100;
                    CGFloat Age = [NSDate hy_dateFromString:UserInfo[@"birth"] withFormat:@"yyyy-MM-dd"].age;
                    int Imp = byteValues[12];
                    CGFloat fatRatio =  60.3-486583*Height*Height/value/Imp+9.146*value/Height/Height/Imp-251.193*Height*Height/value/Age+1625303/Imp/ Imp-0.0139*Imp+0.05975*Age;
                    NSLog(@"fatRatio = %f", fatRatio);
                    
                    [self ackBack];

                    if (self.valueCompletion) {
                        self.valueCompletion(YES, @[@(value), @(fatRatio)], nil, error);
                    }
                }
            }
        }
    }
}

// 登录回复: APP-->设备
- (void)loginBack {
    Byte *mBytes = (Byte *)self.manufacturerData.bytes;
    
    Byte deviceID[] = {0x11, 0x02, 0X03, 0x04, 0x05, 0x06};

    Byte bytes[] = {0x10, 0x0B, 0x00, 0x08, 0x01,
        deviceID[0] ^ mBytes[5],
        deviceID[1] ^ mBytes[6],
        deviceID[2] ^ mBytes[7],
        deviceID[3] ^ mBytes[8],
        deviceID[4] ^ mBytes[9],
        deviceID[5] ^ mBytes[10],
        0x01, 0x01,
    };
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)/sizeof(Byte)];
    [self.peripheral writeValue:data forCharacteristic:self.writeWNCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

// 数据确认包: APP-->设备
- (void)ackBack {
    Byte bytes[] = {0x00, 0x01, 0x01};
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)/sizeof(Byte)];
    [self.peripheral writeValue:data forCharacteristic:self.ackWriteCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

// 同步数据
- (void)synData {
    if (!_hasSendSyn) {
        _hasSendSyn = YES;
        Byte bytes[] = {0x10, 0x04, 0x48, 0x01, 0x01, 0x01};
        NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)/sizeof(Byte)];
        [self.peripheral writeValue:data forCharacteristic:self.writeWNCharacteristic type:CBCharacteristicWriteWithoutResponse];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    NSLog(@"%s, %@", __func__, characteristic);
    
    if (self.discoverServiceCompletion) {
        if ([characteristic.UUID.UUIDString isEqualToString:GLCTUUID] ||
            [characteristic.UUID.UUIDString isEqualToString:GLCTUUID2]  ||
            [characteristic.UUID.UUIDString isEqualToString:CardioCTUUID]  ||
            [characteristic.UUID.UUIDString hasPrefix:BPCTREADUUID] ||
            [characteristic.UUID.UUIDString isEqualToString:TZWRCTUUID]) {
            self.discoverServiceCompletion(characteristic, error);
        }
    }
}

- (BOOL)isTZDevice:(CBService *)service {
    return ([service.UUID.UUIDString isEqualToString:TZServiceUUID] || [service.UUID.UUIDString isEqualToString:@""]);
}

@end
