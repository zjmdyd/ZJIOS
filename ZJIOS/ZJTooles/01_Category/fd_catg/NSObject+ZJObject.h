//
//  NSObject+ZJObject.h
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZJObject)
/**
 *  保存 读取 删除文件
 */
- (void)writeToFileWithPathComponent:(NSString *)name;
- (id)readFileWithPathComponent:(NSString *)name;
- (void)removeFileWithPathComponent:(NSString *)name;
- (void)saveToFileWithURL:(NSString *)requestURL;

- (NSString *)jsonString;



- (NSString *)numValidText;
- (NSString *)numValidTextWithDefault:(NSString *)defaultText;
@end

NS_ASSUME_NONNULL_END
