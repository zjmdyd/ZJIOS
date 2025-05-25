//
//  ZJNSKeyedArchiverViewController.m
//  ZJFoundation
//
//  Created by YunTu on 15/7/3.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ZJNSKeyedArchiverViewController.h"
#import "AppDelegate.h"
#import "ZJLover.h"

@interface ZJNSKeyedArchiverViewController () {
    AppDelegate *_appDelegate;
}

@end

@implementation ZJNSKeyedArchiverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testSystemArchiver];
//    [self testCustomArchiver];
}

- (void)testSystemArchiver {
    NSArray *arr = @[@"张三", @"李四", @"王五"];
    
    /**
     *  归档解档: 方式一
     */
    
    /*/Users/zj/Desktop/ZJIOSProgramme
     归档:把对象--->data
     */
    //1.创建一个可变长度的data
    NSMutableData *md = [NSMutableData data];
    //2.创建归档对象
    NSKeyedArchiver *arch = [[NSKeyedArchiver alloc] initForWritingWithMutableData:md];
    //3.开始编码
    [arch encodeObject:arr forKey:@"names"];
    //4.完成编码
    [arch finishEncoding];
    
    NSError *error;
    BOOL isSuccess = [md writeToFile:@"/Users/zj/Desktop/names" atomically:YES];
    if (isSuccess) {
        NSLog(@"归档成功");
    }else {
        NSLog(@"归档失败 error = %@", error);
    }
    /*
     反归档:把Data-->对象
     */
    NSData *data = [NSData dataWithContentsOfFile:@"/Users/zj/Desktop/names"];
    //1.创建反归档对象
    NSKeyedUnarchiver *unArch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    //2.解码:把对象解出来
    NSArray *newNames = [unArch decodeObjectForKey:@"names"];
    for (NSString *name in newNames) {
        NSLog(@"%@", name);
    }
    
    NSLog(@"\n\n**************\n\n");
    
    /**
     *  归档解档: 方式二
     */
    NSData *d = [NSKeyedArchiver archivedDataWithRootObject:arr];
    NSArray *n = [NSKeyedUnarchiver unarchiveObjectWithData:d];
    for (NSString *name in n) {
        NSLog(@"%@", name);
    }
    
    NSLog(@"\n\n**************\n\n");
}

- (void)testCustomArchiver {
    ZJLover *lover = [[ZJLover alloc] init];
    lover.name = @"aa";
    lover.age = 12;
    
    /*
     归档:把对象---> data
     */
    //1.创建一个可变长度的data
    NSMutableData *md = [NSMutableData data];
    //2.创建归档对象
    NSKeyedArchiver *arch = [[NSKeyedArchiver alloc] initForWritingWithMutableData:md];
    //3.开始编码
    [arch encodeObject:lover forKey:@"lover"];
    //4.完成编码
    [arch finishEncoding];
    
    NSError *error;
    BOOL isSuccess = [md writeToFile:@"/Users/zj/Desktop/custom" options:NSDataWritingAtomic error:&error];
    if (isSuccess) {        // 在模拟器会成功, 真机写入不成功, why???
        NSLog(@"归档成功");
    }else {
        NSLog(@"归档失败 error = %@", error);
    }
    
    /*
     反归档:把Data-->对象
     */
    NSData *data = [NSData dataWithContentsOfFile:@"/Users/zj/Desktop/custom"];
    //1.创建反归档对象
    NSKeyedUnarchiver *unArch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    //2.解码:把对象解出来
    ZJLover *newLover = [unArch decodeObjectForKey:@"lover"];
    NSLog(@"name = %@, age = %ld", newLover.name, (long)newLover.age);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
