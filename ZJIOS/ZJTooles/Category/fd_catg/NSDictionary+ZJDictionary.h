//
//  NSDictionary+ZJDictionary.h
//  ZJIOS
//
//  Created by Zengjian on 2021/7/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (ZJDictionary)

- (NSDictionary *)noNullDic;
- (void)jsonToModel:(id)obj;

/// dic->model
/// @param obj 目标model
/// @param keys 需特殊赋值的key
- (void)jsonToModel:(id)obj withSpecifyKeys:(nullable NSArray *)keys;
- (BOOL)containsKey:(NSString *)key;
- (BOOL)containsKeyCaseInsensitive:(NSString *)key;
- (NSString *)httpParamsString;

@end

NS_ASSUME_NONNULL_END
