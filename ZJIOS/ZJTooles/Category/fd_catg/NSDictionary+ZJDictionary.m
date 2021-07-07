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
        if ([dic[key] isKindOfClass:[NSNull class]]) {
            dic[key] = @"";
        }
    }
    
    return dic;
}

- (void)jsonToModel:(id)obj {
//    for (NSString *key in self.allKeys) {
//        NSString *key0 = [key checkSysConflictKey];
//        if ([[obj objectProperties] containsObject:key0]) {
//            [obj setValue:self[key] forKey:key0];
//        }
//    }
    [self jsonToModel:obj withSpecifyKeys:nil];

}
//
//- (void)noNullJsonToModel:(id)obj {
//    [self noNullJsonToModel:obj withSpecifyKeys:nil];
//}

- (void)jsonToModel:(id)obj withSpecifyKeys:(NSArray *)spKeys {
    NSDictionary *dic = [self noNullDic];
    
    for (NSString *key in dic.allKeys) {
        if (spKeys && ![spKeys containsObject:key]) {
            continue;
        }
        NSString *key0 = [key checkSysConflictKey];
        if ([[obj objectProperties] containsObject:key0]) {
            [obj setValue:dic[key] forKey:key0];
        }
    }
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
    
    return str.mutableCopy;
}

- (BOOL)containsKey:(NSString *)key {
    for (NSString *str in self.allKeys) {
        if ([str isEqualToString:key]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)containsKeyCaseInsensitive:(NSString *)key {
    for (NSString *str in self.allKeys) {
        if ([str caseInsensitiveCompare:key] == NSOrderedSame) {
            return YES;
        }
    }
    
    return NO;
}

@end
