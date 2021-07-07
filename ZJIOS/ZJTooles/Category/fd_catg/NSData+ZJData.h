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

 @param bytes 元byte数组
 @param desBytes 取反结果byte数组
 @param len 数组长度
 */
+ (void)bitwiseNot:(Byte *)bytes desBytes:(Byte *)desBytes len:(uint8_t)len;

/**
 根据范围获取data的值   (4字节32位)
 */
- (uint32_t)valueWithRange:(NSRange)range;
- (uint32_t)valueWithRange:(NSRange)range reverse:(BOOL)reverse;

+ (void)valueToBytes:(Byte *)srcBytes value:(uint32_t)value;
+ (void)valueToBytes:(Byte *)srcBytes value:(uint32_t)value reverse:(BOOL)reverse;

+ (void)bytes2Ints:(Byte *)src ints:(int *)des len:(int)len;
+ (void)ints2Bytes:(int *)src bytes:(Byte *)des len:(int)len;
+ (Byte)xorCheckout:(Byte *)srcBytes len:(uint32_t)len;

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
