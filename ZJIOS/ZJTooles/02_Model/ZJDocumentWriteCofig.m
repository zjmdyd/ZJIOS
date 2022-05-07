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
        self.jsonWriteOptions = NSJSONWritingFragmentsAllowed;
    }
    
    return self;
}

- (NSData *)data {
    if (!_data) {
        if ([self.originValue isKindOfClass:[NSData class]]) {
            _data = (NSData *)self.originValue;
        }else if (self.documentType == ZJDocumentTypeData || self.documentType == ZJDocumentTypeJson || self.documentType == ZJDocumentTypeFragment) {
            if (![NSJSONSerialization isValidJSONObject:self.originValue]) {
                self.jsonWriteOptions = NSJSONWritingFragmentsAllowed;
            }
            if (!self.originValue) {
                NSLog(@"数据源为空"); return nil;
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

- (BOOL)writeFile:(id)obj atomically:(BOOL)useAuxiliaryFile {
    if (!self.fileName) {
        NSLog(@"文件名为空");
    }
    return [self.data writeToFile:self.filePath atomically:useAuxiliaryFile];
}

@end
