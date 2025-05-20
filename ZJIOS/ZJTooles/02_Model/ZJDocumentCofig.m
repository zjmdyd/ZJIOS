//
//  ZJDocumentCofig.m
//  ZJIOS
//
//  Created by issuser on 2022/5/3.
//

#import "ZJDocumentCofig.h"
#import "NSString+ZJTextEncode.h"

#ifndef DocumentPath
#define DocumentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#endif

#ifndef DocumentSuffixs
#define DocumentSuffixs @[@"", @".json", @".txt"]
#endif

@implementation ZJDocumentCofig

@synthesize filePath = _filePath;
@synthesize encodeFileName = _encodeFileName;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.documentType = ZJDocumentTypeData;
    }
    
    return self;
}
/*
 OC中 readonly 属性重写 getter 的注意事项
 一、基础规则
 ‌‌readonly 的默认行为‌
 声明为 readonly 的属性默认只生成 getter 方法（无 setter），且自动合成的实例变量为 @protected 权限13。

 @property (readonly) NSString *identifier;
 // 等效于自动生成：
 - (NSString *)identifier { return _identifier; }
 ‌‌重写 getter 的合法性‌
 允许重写 readonly 属性的 getter 方法，但需注意：

 若未显式 @synthesize，需通过 _propertyName 访问自动合成的实例变量。
 若手动实现 getter 且未合成实例变量，需自行声明成员变量
 */
- (NSString *)filePath {
    if (!_filePath) {
        NSString *name = self.fileName;
        if (self.needEncodFileName) {
            name = self.encodeFileName;
        }
        NSString *path = [self.defaultBasePath stringByAppendingPathComponent:name];
        if (self.documentType == ZJDocumentTypeJson || self.documentType == ZJDocumentTypeFragment) {
            path = [path stringByAppendingString:DocumentSuffixs[self.documentType]];
        }
        _filePath = path;
    }
    
    return _filePath;
}

- (NSString *)defaultBasePath {
    if (!_defaultBasePath) {
        _defaultBasePath = DocumentPath;
    }
    
    return _defaultBasePath;
}

- (NSString *)encodeFileName {
    if (!_encodeFileName) {
        if (self.needEncodFileName) {
            _encodeFileName = [self.fileName encodeFileName];
        }else {
            _encodeFileName = self.fileName;
        }
    }
    
    return _encodeFileName;
}

- (ZJDocumentType)documentTypeWithSuffix:(NSString *)suffix {
    ZJDocumentType type = ZJDocumentTypeData;
    if (suffix) {
        if ([suffix isEqualToString:@".json"] || [suffix isEqualToString:@"json"]) {
            type = ZJDocumentTypeJson;
        }else if ([suffix isEqualToString:@".txt"] || [suffix isEqualToString:@"txt"]) {
            type = ZJDocumentTypeFragment;
        }
    }
    
    return type;
}

@end
