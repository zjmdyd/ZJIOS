//
//  NSObject+ZJObject.m
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import "NSObject+ZJObject.h"
#import "NSString+ZJString.h"

@implementation NSObject (ZJObject)

- (void)writeToFileWithPathComponent:(NSString *)name {
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    NSError *error;
    NSLog(@"writePath = %@", [documentsPath stringByAppendingPathComponent:name]);
    [data writeToFile:[documentsPath stringByAppendingPathComponent:name] options:NSDataWritingAtomic error:&error];
    
    if (error) {
        NSLog(@"写入失败error:%@", error);
    }else {
        NSLog(@"写入成功");
    }
}

- (id)readFileWithPathComponent:(NSString *)name {
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSData *data = [NSData dataWithContentsOfFile:[documentsPath stringByAppendingPathComponent:name]];
    NSLog(@"readPath = %@", [documentsPath stringByAppendingPathComponent:name]);
    
    id value;
    if (data) {
        NSError *error;
        value =  [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            NSLog(@"读取文件失败error:%@", error);
        }else {
            NSLog(@"读取文件成功");
        }
    }
    
    return value;
}

- (void)removeFileWithPathComponent:(NSString *)name {
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:[documentsPath stringByAppendingPathComponent:name] error:&error];
    if (error) {
        NSLog(@"移除失败");
    }else {
        NSLog(@"移除成功");
    }
}

- (void)saveToFileWithURL:(NSString *)requestURL {
    if (self && [NSJSONSerialization isValidJSONObject:self]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
        NSString *filePath = [requestURL jsonFilePath];
        NSError *writeError = nil;
        if ([jsonData writeToFile:filePath options:0 error:&writeError]) {
            NSLog(@"写入缓存文件成功：%@", filePath);
        }else {
            NSLog(@"写入缓存文件失败 %@", writeError.localizedDescription);
        }
    }else {
        NSLog(@"写入数据格式不对");
    }
}

- (NSString *)jsonString {
    if (self == nil) return nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return str;
}

- (UIViewController *)createVCWithName:(NSString *)name title:(NSString *)title {
    return [self createVCWithName:name title:title isGroupTableVC:NO];
}

- (UIViewController *)createVCWithName:(NSString *)name title:(NSString *)title isGroupTableVC:(BOOL)isGroup {
    UIViewController *vc = [NSClassFromString(name) alloc];
    if ([vc isKindOfClass:[UITableViewController class]]) {
        vc = [(UITableViewController *)vc initWithStyle:isGroup ? UITableViewStyleGrouped : UITableViewStylePlain];
    }else {
        vc = [vc init];
        vc.view.backgroundColor = [UIColor whiteColor];;
    }
    
    if ([vc isKindOfClass:[UIViewController class]]) {
        vc.title = title;
    }
    
    return vc;
}

- (NSString *)numValidText {
    return [self numValidTextWithDefault:@"--"];
}

- (NSString *)numValidTextWithDefault:(NSString *)defaultText {
    if ([self isKindOfClass:[NSNumber class]]) {
        return ((NSNumber *)self).stringValue;
    }
    
    return defaultText;
}

- (NSString *)unitMoneyText {
    return [self unitMoneyTextDefaultText:@"" hasPoint:NO];
}

- (NSString *)unitMoneyTextHasPoint:(BOOL)hasPoint {
    return [self unitMoneyTextDefaultText:@"" hasPoint:hasPoint];
}

- (NSString *)unitMoneyTextDefaultText:(NSString *)text {
    return [self unitMoneyTextDefaultText:text hasPoint:NO];
}

- (NSString *)unitMoneyTextDefaultText:(NSString *)text hasPoint:(BOOL)hasPoint {
    NSString *str = text;
    if ([self isKindOfClass:[NSNumber class]]) {
        if (hasPoint) {
            str = [NSString stringWithFormat:@"%.2f", ((NSNumber *)self).floatValue/100];
        }else {
            str = [NSString stringWithFormat:@"%.0f", ((NSNumber *)self).floatValue/100];
        }
    }
    
    return str;
}

- (NSString *)centMoneyText {
    if (([self isKindOfClass:[NSString class]] && [((NSString *)self) isNoEmptyString]) || [self isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%.0f", ((NSString *)self).floatValue*100];
    }
    
    return @"";
}

- (NSString *)tenThousandMoneyText {
    if (([self isKindOfClass:[NSString class]] && [((NSString *)self) isNoEmptyString]) || [self isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%.0f", ((NSString *)self).floatValue*10000];
    }
    return @"";
}
@end
