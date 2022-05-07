//
//  ZJDocumentWriteCofig.h
//  ZJIOS
//
//  Created by issuser on 2022/5/6.
//

#import "ZJDocumentCofig.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZJDocumentWriteCofig : ZJDocumentCofig

@property (nonatomic, strong) id originValue;    // 原始数据
@property (nonatomic, assign) NSJSONWritingOptions jsonWriteOptions;
@property (nonatomic, strong) NSData *data;

- (BOOL)writeFile:(id)obj atomically:(BOOL)useAuxiliaryFile;

@end

NS_ASSUME_NONNULL_END
