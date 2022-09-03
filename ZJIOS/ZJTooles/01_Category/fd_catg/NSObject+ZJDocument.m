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
    ZJDocumentWriteCofig *config = [ZJDocumentWriteCofig new];
    config.fileName = name;;
    config.needEncodFileName = need;
    config.documentType = [config documentTypeWithSuffix:suffix];
    
    [self writeToFileWithDocumentConfig:config];
}

- (void)writeToFileWithDocumentConfig:(ZJDocumentWriteCofig *)config {
    config.originValue = self;
    
    if (!config.data) {
        return;
    }

    NSLog(@"writePath = %@", config.filePath);
    
    NSError *error;
    [config.data writeToFile:config.filePath options:NSDataWritingAtomic error:&error];
    
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
    ZJDocumentReadCofig *config = [ZJDocumentReadCofig new];
    config.fileName = name;;
    config.needEncodFileName = need;
    config.documentType = [config documentTypeWithSuffix:suffix];
    
    return [self readFileWithDocumentConfig:config];
}

+ (id)readFileWithDocumentConfig:(ZJDocumentReadCofig *)config {
    return config.readValue;
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
