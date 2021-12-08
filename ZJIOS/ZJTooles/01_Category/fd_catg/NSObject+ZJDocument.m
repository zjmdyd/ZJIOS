//
//  NSObject+ZJDocument.m
//  ZJIOS
//
//  Created by issuser on 2021/12/7.
//

#import "NSObject+ZJDocument.h"
#import "NSString+ZJTextEncode.h"

@implementation NSObject (ZJDocument)

- (void)writeToFileWithPathComponent:(NSString *)name {
    [self writeToFileWithPathComponent:name needEncodeFileName:NO];
}

- (void)writeToFileWithPathComponent:(NSString *)name needEncodeFileName:(BOOL)need {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
        NSError *error;
        if (need) {
            name = [name encodeJsonFileName];
        }
        NSLog(@"writePath = %@", [documentsPath stringByAppendingPathComponent:name]);
        [data writeToFile:[documentsPath stringByAppendingPathComponent:name] options:NSDataWritingAtomic error:&error];
        
        if (error) {
            NSLog(@"写入失败error:%@", error);
        }else {
            NSLog(@"写入成功");
        }
    }else {
        NSLog(@"数据格式错误");
    }
}

+ (id)readFileWithPathComponent:(NSString *)name {
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSData *data = [NSData dataWithContentsOfFile:[documentsPath stringByAppendingPathComponent:name]];
    NSLog(@"readPath = %@", [documentsPath stringByAppendingPathComponent:name]);
    
    id value;
    if (data) {
        NSError *error;
        value = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            NSLog(@"读取文件失败error:%@", error);
        }else {
            NSLog(@"读取文件成功");
        }
    }
    
    return value;
}

+ (void)removeFileWithPathComponent:(NSString *)name {
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:[documentsPath stringByAppendingPathComponent:name] error:&error];
    if (error) {
        NSLog(@"移除失败");
    }else {
        NSLog(@"移除成功");
    }
}

@end
