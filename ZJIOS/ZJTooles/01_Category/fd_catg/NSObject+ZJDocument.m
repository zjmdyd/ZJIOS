//
//  NSObject+ZJDocument.m
//  ZJIOS
//
//  Created by issuser on 2021/12/7.
//

#import "NSObject+ZJDocument.h"

@implementation NSObject (ZJDocument)

#pragma mark - 写入

- (void)writeToFileWithPathComponent:(NSString *)name {
    [self writeToFileWithPathComponent:name needEncodeFileName:NO suffix:nil];
}

- (void)writeToFileWithPathComponent:(NSString *)name suffix:(nullable NSString *)suffix {
    [self writeToFileWithPathComponent:name needEncodeFileName:NO suffix:suffix];
}

- (void)writeToFileWithPathComponent:(NSString *)name needEncodeFileName:(BOOL)need {
    [self writeToFileWithPathComponent:name needEncodeFileName:NO suffix:nil];
}

- (void)writeToFileWithPathComponent:(NSString *)name needEncodeFileName:(BOOL)need suffix:(nullable NSString *)suffix {
    ZJDocumentCofig *config = [ZJDocumentCofig new];
    config.fileName = name;;
    config.needEncodFileName = need;
    config.documentType = [config documentTypeWithSuffix:suffix];
    
    [self writeToFileWithDocumentConfig:config];
}

- (void)writeToFileWithDocumentConfig:(ZJDocumentCofig *)config {
    NSData *data;
    if (config.documentType == ZJDocumentTypeJson) {
        if ([NSJSONSerialization isValidJSONObject:self]) {
            data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
        }
    }else if (config.documentType == ZJDocumentTypeString) {
        if ([self isKindOfClass:[NSString class]]) {
            data = [((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding];
        }
    }else {
        if ([self isKindOfClass:[NSData class]]) {
            data = (NSData *)self;
        }
    }
    if (!data) {
        NSLog(@"数据类型与给定类型不匹配或不支持改数据类型"); return;
    }

    NSLog(@"writePath = %@", config.filePath);
    
    NSError *error;
    [data writeToFile:config.filePath options:NSDataWritingAtomic error:&error];
    
    if (error) {
        NSLog(@"写入失败error:%@", error);
    }else {
        NSLog(@"写入成功");
    }
}

#pragma mark - 读取

+ (id)readFileWithPathComponent:(NSString *)name {
    return [self readFileWithPathComponent:name needDeserialize:NO suffix:nil];
}

+ (id)readFileWithPathComponent:(NSString *)name suffix:(nullable NSString *)suffix {
    return [self readFileWithPathComponent:name needDeserialize:NO suffix:suffix];
}

+ (id)readFileWithPathComponent:(NSString *)name needDeserialize:(BOOL)need {
    return [self readFileWithPathComponent:name needDeserialize:need suffix:nil];
}

+ (id)readFileWithPathComponent:(NSString *)name needDeserialize:(BOOL)need suffix:(nullable NSString *)suffix {
    ZJDocumentCofig *config = [ZJDocumentCofig new];
    config.fileName = name;;
    config.needEncodFileName = need;
    config.documentType = [config documentTypeWithSuffix:suffix];
    
    return [self readFileWithDocumentConfig:config];
}

+ (id)readFileWithDocumentConfig:(ZJDocumentCofig *)config {
    NSString *path = config.filePath;
    NSLog(@"readPath = %@", path);
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    id value;
    if (data) {
        if (config.documentType == ZJDocumentTypeJson) {
            NSError *error;
            value = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (error) {
                NSLog(@"读取序列化数据失败error:%@", error);
            }else {
                NSLog(@"读取序列化数据成功");
            }
        }else if (config.documentType == ZJDocumentTypeString) {
            value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }else {
            value = data;
        }
    }else {
        NSLog(@"读取文件数据失败");
    }
    
    return value;
}

#pragma mark - 删除

+ (void)removeFileWithPathComponent:(NSString *)name {
    [self removeFileWithPathComponent:name needDeserialize:NO suffix:nil];
}

+ (void)removeFileWithPathComponent:(NSString *)name suffix:(nullable NSString *)suffix {
    [self removeFileWithPathComponent:name needDeserialize:NO suffix:suffix];
}

+ (void)removeFileWithPathComponent:(NSString *)name needDeserialize:(BOOL)need {
    [self removeFileWithPathComponent:name needDeserialize:need suffix:nil];
}

+ (void)removeFileWithPathComponent:(NSString *)name needDeserialize:(BOOL)need suffix:(nullable NSString *)suffix {
    ZJDocumentCofig *config = [ZJDocumentCofig new];
    config.fileName = name;;
    config.needEncodFileName = need;
    config.documentType = [config documentTypeWithSuffix:suffix];
    
    [self removeFileWithDocumentConfig:config];
}

+ (void)removeFileWithDocumentConfig:(ZJDocumentCofig *)config {
    NSString *path = config.filePath;
    NSLog(@"移除路径Path = %@", path);
    
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    if (error) {
        NSLog(@"移除失败");
    }else {
        NSLog(@"移除成功");
    }
}

@end
