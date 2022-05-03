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
#define DocumentSuffixs @[@".json", @".txt", @""]
#endif

@implementation ZJDocumentCofig

@synthesize filePath = _filePath;
@synthesize encodeFileName = _encodeFileName;

- (NSString *)filePath {
    if (!_filePath) {
        NSString *name = self.fileName;
        if (self.needEncodFileName) {
            name = self.encodeFileName;
        }
        NSString *path = [self.defaultBasePath stringByAppendingPathComponent:name];
        if (self.documentType == ZJDocumentTypeJson || self.documentType == ZJDocumentTypeString) {
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
            _encodeFileName = [_fileName encodeFileName];
        }else {
            _encodeFileName = _fileName;
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
            type = ZJDocumentTypeString;
        }
    }
    
    return type;
}

@end
