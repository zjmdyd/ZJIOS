//
//  ZJNSDataViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/7/20.
//

#import "ZJNSDataViewController.h"
#import "NSData+ZJData.h"

@interface ZJNSDataViewController ()

@end

@implementation ZJNSDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self test0];
    [self test1];
}

- (void)test2 {
    
}

/// 0x0a
// 0000 1010
// 0010 1000
- (void)test1 {
    int i = 10;
    int j = i << 2;
    NSLog(@"i = %d, j = %d", i, j);
    Byte bytes[4];
    [NSData valueToBytes:bytes value:16];
    NSLog(@"%@", [NSData dataWithBytes:bytes length:4]);
    [NSData valueToBytes:bytes value:16 reverse:YES];
    NSLog(@"%@", [NSData dataWithBytes:bytes length:4]);
}

- (void)test0 {
    Byte bytes[] = {0x01, 0x02, 0x03, 0x04};
    NSLog(@"%lu", sizeof(bytes)/sizeof(Byte));
    NSData *data = [NSData dataWithBytes:bytes length:4];
    NSLog(@"data = %@", data);
    NSLog(@"dataToHexString = %@", [data dataToHexString]);
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
