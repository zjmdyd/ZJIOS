//
//  NSObject+ZJDocument.h
//  ZJIOS
//
//  Created by issuser on 2021/12/7.
//

#import <Foundation/Foundation.h>
#import "ZJDocumentCofig.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZJDocument)

/**
 *  写入 读取 删除文件
 */
#pragma mark - 写入

- (void)writeToFileWithPathComponent:(NSString *)name;
- (void)writeToFileWithPathComponent:(NSString *)name suffix:(nullable NSString *)suffix;

- (void)writeToFileWithPathComponent:(NSString *)name needEncodeFileName:(BOOL)need;
- (void)writeToFileWithPathComponent:(NSString *)name needEncodeFileName:(BOOL)need suffix:(nullable NSString *)suffix;

- (void)writeToFileWithDocumentConfig:(ZJDocumentCofig *)config;

#pragma mark - 读取

+ (id)readFileWithPathComponent:(NSString *)name;
+ (id)readFileWithPathComponent:(NSString *)name suffix:(nullable NSString *)suffix;

+ (id)readFileWithPathComponent:(NSString *)name needDeserialize:(BOOL)need;
+ (id)readFileWithPathComponent:(NSString *)name needDeserialize:(BOOL)need suffix:(nullable NSString *)suffix;

+ (id)readFileWithDocumentConfig:(ZJDocumentCofig *)config;

#pragma mark - 删除

+ (void)removeFileWithPathComponent:(NSString *)name;
+ (void)removeFileWithPathComponent:(NSString *)name suffix:(nullable NSString *)suffix;

+ (void)removeFileWithPathComponent:(NSString *)name needDeserialize:(BOOL)need;
+ (void)removeFileWithPathComponent:(NSString *)name needDeserialize:(BOOL)need suffix:(nullable NSString *)suffix;

+ (void)removeFileWithDocumentConfig:(ZJDocumentCofig *)config;

@end

NS_ASSUME_NONNULL_END
