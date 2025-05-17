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
