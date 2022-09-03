//
//  ZJTestDataViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/7/20.
//

#import "ZJTestDataViewController.h"
#import "NSData+ZJData.h"
#include "ZJByteData.h"

@interface ZJTestDataViewController ()

@end

@implementation ZJTestDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test2];
}

// 10: 0x0000 1010
// 40: 0x0010 1000
/*
 16
 0x10
 -->0001 0000
 */
- (void)test2 {
    int i = 10;
    int j = i << 2;
    NSLog(@"i = %d, j = %d", i, j);
    Byte bytes[4];
    [NSData valueToBytes:bytes value:16];
    NSLog(@"%@", [NSData dataWithBytes:bytes length:4]);    // 0x00000010
    [NSData valueToBytes:bytes value:16 reverse:YES];
    NSLog(@"%@", [NSData dataWithBytes:bytes length:4]);    // 0x10000000
}

- (void)test1 {
    Byte bytes[] = {0x01, 0x02, 0x03, 0x04};
    NSLog(@"%lu", sizeof(bytes)/sizeof(Byte));
    NSData *data = [NSData dataWithBytes:bytes length:4];
    NSLog(@"data = %@", data);
    NSLog(@"dataToHexString = %@", [data dataToHexString]);
}

// 0x11223344----287454020
- (void)intToBytes:(int)value {
    Byte bytes[4];
    Byte a = (Byte) (value & 0xFF);         // 低字节数据-->低地址-->小端
    Byte b = (Byte) ((value>>8) & 0xFF);
    Byte c = (Byte) ((value>>16) & 0xFF);
    Byte d = (Byte) ((value>>24) & 0xFF);   // 取低地址-->低字节
    printf("%x, %x, %x, %x\n", a, b, c, d); // 小端模式将输出: 44, 33, 22, 11
    
    BOOL reverse = NO;
    for (int i = 0; i < 4; i++) {
        if (reverse) {
            bytes[3-i] = (value >> 8*(3-i)) & 0xff;
        }else {
            bytes[i] = (value >> 8*(3-i)) & 0xff;
        }
    }
    
//    if (isBigEndian()) {
//        Byte bts[] = {a, b, c, d};
//    }else {
//        Byte bts[] = {d, c, b, a};
//    }
    NSData *data = [NSData dataWithBytes:bytes length:4];
    NSLog(@"data = %@", data);
}

// 小端模式：是指数据的低字节保存在内存的低地址中，而数据的高字节保存在内存的高地址中。
- (BOOL)testBigEndian {
    int num = 0x11223344;           // 十进制为287454020
    char a = num & 0xff;            // 取(0~7位)一个子节  低字节-->低地址-->小端
    char b = num >> 8 & 0xff;       // 取(8~15位)一个子节
    char c = num >> 16 & 0xff;      // 取(16~23位)一个子节
    char d = num >> 24 & 0xff;      // 取(24~31位)一个子节
    printf("%x, %x, %x, %x\n", a, b, c, d);   // 小端模式将输出: 44, 33, 22, 11
    
    if (a == 0x44) {
        return false;
    }
    return true;
}

- (void)test0 {
    NSLog(@"testBig = %@", @([self testBigEndian]));
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
