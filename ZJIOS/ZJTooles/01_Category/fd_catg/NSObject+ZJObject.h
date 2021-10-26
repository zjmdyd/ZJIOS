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

/**
 *  根据控制器名字创建控制器
 */
- (UIViewController *)createVCWithName:(NSString *)name title:(NSString *)title;
- (UIViewController *)createVCWithName:(NSString *)name title:(NSString *)title isGroupTableVC:(BOOL)isGroup;

- (NSString *)unitMoneyText;
- (NSString *)unitMoneyTextHasPoint:(BOOL)hasPoint;
- (NSString *)unitMoneyTextDefaultText:(NSString *)text;
- (NSString *)unitMoneyTextDefaultText:(NSString *)text hasPoint:(BOOL)hasPoint;

- (NSString *)centMoneyText;    // 元--> 分
- (NSString *)tenThousandMoneyText; // 万->元

- (NSString *)numValidText;
- (NSString *)numValidTextWithDefault:(NSString *)defaultText;
@end

NS_ASSUME_NONNULL_END
