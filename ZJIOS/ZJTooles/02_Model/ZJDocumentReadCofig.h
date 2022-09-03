//
//  ZJDocumentReadCofig.h
//  ZJIOS
//
//  Created by issuser on 2022/5/6.
//

#import "ZJDocumentCofig.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZJDocumentReadCofig : ZJDocumentCofig

@property (nonatomic, assign) NSJSONReadingOptions jsonReadOptions;
@property (nonatomic, strong) id readValue;

@end

NS_ASSUME_NONNULL_END
