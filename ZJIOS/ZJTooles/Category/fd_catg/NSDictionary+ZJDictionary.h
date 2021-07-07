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
- (void)jsonToModel:(id)obj withSpecifyKeys:(NSArray *)keys;
- (BOOL)containsKey:(NSString *)key;
- (BOOL)containsKeyCaseInsensitive:(NSString *)key;
- (NSString *)httpParamsString;

@end

NS_ASSUME_NONNULL_END
