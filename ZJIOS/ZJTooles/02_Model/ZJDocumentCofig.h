//
//  ZJDocumentCofig.h
//  ZJIOS
//
//  Created by issuser on 2022/5/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZJDocumentType) {
    ZJDocumentTypeData,
    ZJDocumentTypeJson,
    ZJDocumentTypeFragment,
};

@interface ZJDocumentCofig : NSObject

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, assign) ZJDocumentType documentType;
@property (nonatomic, assign) BOOL needEncodFileName;

@property (nonatomic, copy, readonly) NSString *encodeFileName;
@property (nonatomic, copy, readonly) NSString *filePath;

@property (nonatomic, copy) NSString *defaultBasePath;



- (ZJDocumentType)documentTypeWithSuffix:(NSString *)suffix;

@end

NS_ASSUME_NONNULL_END
