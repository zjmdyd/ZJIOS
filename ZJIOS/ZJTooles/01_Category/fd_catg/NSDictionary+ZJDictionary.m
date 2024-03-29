//
//  NSDictionary+ZJDictionary.m
//  ZJIOS
//
//  Created by Zengjian on 2021/7/2.
//

#import "NSDictionary+ZJDictionary.h"
#import "NSString+ZJString.h"
#import "NSObject+ZJRuntime.h"

@implementation NSDictionary (ZJDictionary)

- (NSDictionary *)noNullDic {
    NSMutableDictionary *dic = self.mutableCopy;
    for (NSString *key in dic.allKeys) {
        id value = dic[key];
        if ([value isKindOfClass:[NSNull class]] || value == nil) {
            dic[key] = @"";
        }
    }
    
    return dic;
}

- (void)jsonToModel:(id)obj {
    [self jsonToModel:obj withSpecifyKeys:nil];
}

- (void)jsonToModel:(id)obj withSpecifyKeys:(nullable NSArray *)specifyKeys {
    NSDictionary *dic = [self noNullDic];
    
    NSArray *properties = [obj objectProperties];
    for (NSString *key in dic.allKeys) {
        if (specifyKeys && ![specifyKeys containsObject:key]) {
            continue;   // 不在特定赋值key之内的key要淘汰
        }
        NSString *key0 = [key checkSysConflictKey];
        if ([properties containsObject:key0]) {
            [obj setValue:dic[key] forKey:key0];
        }
    }
}

- (BOOL)zj_containsKey:(NSString *)key {
    NSLog(@"%s", __func__);
    if ([key isKindOfClass:[NSString class]]) {
        return [self containsKey:key caseInsensitive:NO];
    }
    return NO;
}

- (BOOL)containsKey:(NSString *)key caseInsensitive:(BOOL)caseInsensitive {
    for (NSString *str in self.allKeys) {
        if (caseInsensitive) {
            if ([str caseInsensitiveCompare:key] == NSOrderedSame) {
                return YES;
            }
        }else {
            if ([str isEqualToString:key]) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (NSString *)httpParamsString {
    NSMutableString *str = [NSMutableString string];
    NSArray *keys = self.allKeys;
    for (int i = 0; i < keys.count; i++) {
        NSString *key = keys[i];
        if (i < keys.count-1) {
            [str appendString:[NSString stringWithFormat:@"%@=%@&", key, self[key]]];
        }else {
            [str appendString:[NSString stringWithFormat:@"%@=%@", key, self[key]]];
        }
    }
    
    return str.copy;
}

+ (NSDictionary *)generateParamsWithKeys:(NSArray *)keys values:(NSArray *)values {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (keys.count != values.count) {
        NSLog(@"key_value个数不匹配");
    }
    for (int i = 0; i < keys.count; i++) {
        dic[keys[i]] = values[i];
    }
    
    return dic.copy;
}


@end
