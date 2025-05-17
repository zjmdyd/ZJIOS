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
    [self writeToFileWithPathComponent:name needEncodeFileName:need suffix:nil];
}

- (void)writeToFileWithPathComponent:(NSString *)name needEncodeFileName:(BOOL)need suffix:(nullable NSString *)suffix {
    ZJDocumentWriteCofig *config = [ZJDocumentWriteCofig new];
    config.fileName = name;;
    config.needEncodFileName = need;
    config.documentType = [config documentTypeWithSuffix:suffix];
    
    [self writeToFileWithDocumentConfig:config];
}

/*
 NSDataWritingOptions 是 Foundation 框架中用于控制 NSData 写入文件行为的选项枚举，其核心特性和用法如下：
 一、主要枚举值
 ‌‌选项‌    ‌作用‌    ‌可用性‌
 NSDataWritingAtomic    通过临时文件原子性写入，确保写入失败时原文件不受损    iOS 2.0+
 NSDataWritingWithoutOverwriting    禁止覆盖已存在文件（若目标文件存在则写入失败）    iOS 6.0+ / macOS 10.8+
 NSDataWritingFileProtectionNone    文件无加密保护（设备未锁定时可访问）    iOS 4.0+
 NSDataWritingFileProtectionComplete    文件全程加密（设备锁定后不可访问）
 
 三、关键特性解析
 ‌‌原子性写入‌
 .atomic 选项通过“临时文件替换”机制保证数据完整性，避免写入中断导致文件损坏。
 ‌‌文件保护‌
 文件保护选项（如 .fileProtectionComplete）依赖系统级加密，与设备锁屏状态联动。
 四、注意事项
 ‌‌默认行为‌：不指定选项时（空数组 []），直接覆盖目标文件且无原子性保护1。
 ‌‌组合使用‌：多个选项可通过按位或（|）组合，如 [.atomic, .fileProtectionComplete]。
 ‌‌错误处理‌：建议通过 try-catch 捕获 NSError，尤其是涉及文件保护选项时
 */
- (void)writeToFileWithDocumentConfig:(ZJDocumentWriteCofig *)config {
    [self writeToFileWithDocumentConfig:config atomicallyType:NO atomically:NO];
}

/*
 - (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile;
 一、方法参数说明
 path: 目标文件路径（需确保目录可写）
 useAuxiliaryFile: 控制写入方式
 • YES：原子性写入（通过临时文件保证数据完整性）
 • NO：直接覆盖目标文件
 二、原子性写入原理
 ‌‌YES 模式流程‌:    创建临时文件 → 数据写入临时文件 → 写入成功后替换原文件
 ‌‌优势‌：避免写入中断导致原文件损坏
 ‌‌代价‌：额外磁盘空间和性能开销
 ‌‌NO 模式风险‌:    直接修改目标文件，若写入过程中断可能导致文件内容部分丢失或损坏
 */
- (void)writeToFileWithDocumentConfig:(ZJDocumentWriteCofig *)config atomicallyType:(BOOL)type atomically:(BOOL)useAuxiliaryFile {
    config.originValue = self;
    
    if (!config.data) {
        return;
    }

    NSLog(@"writePath = %@", config.filePath);
    
    NSError *error;
    if (type) {
        [config.data writeToFile:config.filePath atomically:useAuxiliaryFile];
    }else {
        [config.data writeToFile:config.filePath options:NSDataWritingAtomic error:&error];
    }
    
    if (error) {
        NSLog(@"写入失败error:%@", error);
    }else {
        NSLog(@"写入成功");
    }
}

#pragma mark - 读取

+ (id)readFileWithPathComponent:(NSString *)name {
    return [self readFileWithPathComponent:name needEncodFileName:NO suffix:nil];
}

+ (id)readFileWithPathComponent:(NSString *)name suffix:(nullable NSString *)suffix {
    return [self readFileWithPathComponent:name needEncodFileName:NO suffix:suffix];
}

+ (id)readFileWithPathComponent:(NSString *)name needEncodFileName:(BOOL)need {
    return [self readFileWithPathComponent:name needEncodFileName:need suffix:nil];
}

+ (id)readFileWithPathComponent:(NSString *)name needEncodFileName:(BOOL)need suffix:(nullable NSString *)suffix {
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
    [self removeFileWithPathComponent:name needEncodFileName:NO suffix:nil];
}

+ (void)removeFileWithPathComponent:(NSString *)name suffix:(nullable NSString *)suffix {
    [self removeFileWithPathComponent:name needEncodFileName:NO suffix:suffix];
}

+ (void)removeFileWithPathComponent:(NSString *)name needEncodFileName:(BOOL)need {
    [self removeFileWithPathComponent:name needEncodFileName:need suffix:nil];
}

+ (void)removeFileWithPathComponent:(NSString *)name needEncodFileName:(BOOL)need suffix:(nullable NSString *)suffix {
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
