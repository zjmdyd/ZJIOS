//
//  NSObject+ZJDocument.h
//  ZJIOS
//
//  Created by issuser on 2021/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZJDocument)

/**
 *  写入 读取 删除文件
 */
- (void)writeToFileWithPathComponent:(NSString *)name;
- (void)writeToFileWithPathComponent:(NSString *)name needEncodeFileName:(BOOL)need;
+ (id)readFileWithPathComponent:(NSString *)name;
+ (void)removeFileWithPathComponent:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
