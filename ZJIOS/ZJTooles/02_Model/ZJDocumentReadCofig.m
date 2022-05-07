//
//  ZJDocumentReadCofig.m
//  ZJIOS
//
//  Created by issuser on 2022/5/6.
//

#import "ZJDocumentReadCofig.h"

@implementation ZJDocumentReadCofig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.jsonReadOptions = NSJSONReadingFragmentsAllowed;
    }
    
    return self;
}

- (id)readValue {
    if (!_readValue) {
        NSString *path = self.filePath;
        NSLog(@"readPath = %@", path);
        
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (data) {
            if (self.documentType == ZJDocumentTypeData) {
                _readValue = data;
            }else {
                NSError *error;
                _readValue = [NSJSONSerialization JSONObjectWithData:data options:self.jsonReadOptions error:&error];
                if (error) {
                    NSLog(@"读取序列化数据失败:error:%@", error);
                }else {
                    NSLog(@"读取序列化数据成功");
                }
            }
        }else {
            NSLog(@"读取文件数据失败");
        }
    }
    
    return _readValue;
}

@end
