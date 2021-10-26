//
//  NSData+ZJData.h
//  ZJIOS
//
//  Created by Zengjian on 2021/7/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (ZJData)

#pragma mark - Byte数值操作

/**
 NSData按位取反运算
 */
- (NSData *)bitwiseNot;

/**
 Byte数组取反运算

 @param bytes 源byte数组
 @param desBytes 取反结果byte数组
 @param len 数组长度
 */
+ (void)bitwiseNot:(Byte *)bytes desBytes:(Byte *)desBytes len:(uint8_t)len;

// 按位异或
+ (Byte)xorCheckout:(Byte *)srcBytes len:(uint32_t)len;

// 32位整形-->byte数组
+ (void)valueToBytes:(Byte *)desBytes value:(uint32_t)value;
+ (void)valueToBytes:(Byte *)desBytes value:(uint32_t)value reverse:(BOOL)reverse;

// Byte数组-->整形数组
+ (void)bytes2Ints:(Byte *)src ints:(int *)des len:(int)len;

// 整形数组-->Byte数组
+ (void)ints2Bytes:(int *)src bytes:(Byte *)des len:(int)len;

/**
 获取data某个区间的整数值   (32位整形)
 */
- (uint32_t)valueWithRange:(NSRange)range;
- (uint32_t)valueWithRange:(NSRange)range reverse:(BOOL)reverse;

/**
 *  NSData<Byte*> --> 十六进制字符串
 */
- (NSString *)dataToHexString;

/**
 *  十六进制字符串 --> NSData<Byte*>
 */
+ (NSData *)dataWithHexString:(NSString *)hexString;

@end

NS_ASSUME_NONNULL_END
