//
//  ZJDocumentWriteCofig.m
//  ZJIOS
//
//  Created by issuser on 2022/5/6.
//

#import "ZJDocumentWriteCofig.h"

@implementation ZJDocumentWriteCofig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.jsonWriteOptions = NSJSONWritingPrettyPrinted;
    }
    
    return self;
}

/*
 NSJSONWritingOptions枚举值说明
 ‌‌选项‌    ‌作用‌
 NSJSONWritingPrettyPrinted    生成带缩进和换行的格式化 JSON，便于阅读（但数据体积增大）
 NSJSONWritingSortedKeys    按字母序排序字典的键（iOS 11+ 支持）
 NSJSONWritingFragmentsAllowed    允许序列化非数组/字典的顶层 JSON 片段（如单独字符串、数字）
 NSJSONWritingWithoutEscapingSlashes 是 NSJSONWritingOptions 中的一个选项，用于控制 JSON 序列化时是否对斜杠字符（/）进行转义14。
 以下是详细解析：
 一、核心作用
 ‌‌默认行为‌：
 未启用此选项时，NSJSONSerialization 会将斜杠转义为 \/（符合严格 JSON 规范）。
 ‌‌启用效果‌：
 添加该选项后，斜杠将保持原样输出（/），适用于需要保留原始 URL 或路径的场景
 */
- (NSData *)data {
    if (!_data) {
        if (!self.originValue) {
            NSLog(@"数据源为空"); return nil;
        }
        if ([self.originValue isKindOfClass:[NSData class]]) {
            _data = (NSData *)self.originValue;
        }else if (self.documentType == ZJDocumentTypeData || self.documentType == ZJDocumentTypeJson || self.documentType == ZJDocumentTypeFragment) {
            if (![NSJSONSerialization isValidJSONObject:self.originValue]) {
                self.jsonWriteOptions = NSJSONWritingFragmentsAllowed;
            }
            
            NSError *error;
            _data = [NSJSONSerialization dataWithJSONObject:self.originValue options:self.jsonWriteOptions error:&error];
            if (error) {
                NSLog(@"data_error = %@", error);
            }
        }else {
            NSLog(@"不支持该数据类型");
        }
        if (!_data) {
            NSLog(@"不支持该数据类型或数据类型与给定解析类型不匹配");
        }
    }

    return _data;
}

@end
