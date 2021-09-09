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
    [self jsonToModel:obj withSpecifyKeys:nil];
}

- (void)jsonToModel:(id)obj withSpecifyKeys:(nullable NSArray *)spKeys {
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

- (BOOL)containsKey:(NSString *)key {
    return [self containsKey:key caseInsensitive:NO];
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
    
    return str.mutableCopy;
}

- (void)base64Dic {
    // 1
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    NSLog(@"==%@",data);//转化成Data
    // 2转化成64字符串
    NSString *getStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    


}

@end
