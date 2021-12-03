//
//  NSData+ZJData.m
//  ZJIOS
//
//  Created by Zengjian on 2021/7/5.
//

#import "NSData+ZJData.h"

@implementation NSData (ZJData)

#pragma mark - Byte数值操作

// NSData按位取反运算
- (NSData *)bitwiseNot {
    Byte *bytes = (Byte *)self.bytes;
    uint8_t len = self.length;
    Byte reBytes[len];
    for (int i = 0; i < len; i++) {
        Byte byte = bytes[i];
        reBytes[i] = ~byte;
    }
    
    NSData *reData = [NSData dataWithBytes:reBytes length:len];
    return reData;
}

// byte数组取反运算
+ (void)bitwiseNot:(Byte *)bytes desBytes:(Byte *)reBytes len:(uint8_t)len {
    for (int i = 0; i < len; i++) {
        Byte byte = bytes[i];
        reBytes[i] = ~byte;
    }
}

// 按位异或(校验和)
+ (Byte)xorCheckout:(Byte *)srcBytes len:(uint32_t)len {
    Byte checkout = 0x00;
    for (int i = 0; i < len; i++) {
        checkout ^= srcBytes[i];
    }
    return checkout;
}

+ (void)valueToBytes:(Byte *)desBytes value:(uint32_t)value {
    [self valueToBytes:desBytes value:value reverse:NO];
}

+ (void)valueToBytes:(Byte *)desBytes value:(uint32_t)value reverse:(BOOL)reverse {
    for (int i = 0; i < 4; i++) {
        if (reverse) {
            desBytes[3-i] = (value >> 8*(3-i)) & 0xff;
        }else {
            desBytes[i] = (value >> 8*(3-i)) & 0xff;
        }
    }
}

// Byte数组-->整形数组
+ (void)bytes2Ints:(Byte *)src ints:(int *)des len:(int)len {
    for (int i = 0; i < len; i++) {
        des[i] = src[i];
    }
}

// 整形数组-->Byte数组
+ (void)ints2Bytes:(int *)src bytes:(Byte *)des len:(int)len {
    for (int i = 0; i < len; i++) {
        Byte bytes[4];
        [NSData valueToBytes:bytes value:src[i] reverse:NO];
        des[i] = bytes[3];
    }
}

// 根据范围获取data的值
- (uint32_t)valueWithRange:(NSRange)range {
    return [self valueWithRange:range reverse:NO];
}

- (uint32_t)valueWithRange:(NSRange)range reverse:(BOOL)reverse {
    Byte *bytes = (Byte *)self.bytes;
    NSUInteger len = range.length;
    uint32_t value = 0;
    for (int i = 0; i < len; i++) {
        if (reverse) {
            NSUInteger offset = 8 * i;
            uint32_t v = (bytes[range.location+i] << offset) & (0xff << offset);
            value += v;
        }else {
            NSUInteger offset = 8 * (len-1-i);
            uint32_t v = (bytes[range.location+i] << offset) & (0xff << offset);
            value += v;
        }
    }
    
    return value;
}

/**
 *  NSData<Byte*> --> 十六进制字符串
 */
- (NSString *)dataToHexString {
    if (!self) return nil;
    
    Byte *bytes = (Byte *)[self bytes];
    NSMutableString *str = [NSMutableString stringWithCapacity:self.length * 2];
    for (int i = 0; i < self.length; i++) {
        [str appendFormat:@"%02x", bytes[i]];
    }
    return str;
}

/**
 *  十六进制字符串 --> NSData<Byte*>
 */
+ (NSData *)dataWithHexString:(NSString *)hexString {
    NSMutableData *data = [NSMutableData data];
    for (int idx = 0; idx < hexString.length; idx += 2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString *byteStr = [hexString substringWithRange:range];
        NSScanner *scanner = [NSScanner scannerWithString:byteStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    
    return data;
}

@end
