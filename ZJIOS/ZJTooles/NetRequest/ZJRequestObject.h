//
//  ZJRequestObject.h
//  KeerZhineng
//
//  Created by ZJ on 2018/12/14.
//  Copyright © 2018 HY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZJParseObject.h"
#import "ZJRequestSource.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZJHTTPRequestType) {
    ZJHTTPRequestTypeOfGet,
    ZJHTTPRequestTypeOfPost,
    ZJHTTPRequestTypeOfDelete,
    ZJHTTPRequestTypeOfPut,
};

@interface ZJRequestObject : NSObject

+ (instancetype)objectWithParams:(id)params path:(NSString *)path;

@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property (nonatomic, assign) ZJHTTPRequestType type;
@property (nonatomic, strong) id params;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *absoluteUrlString;

// 是否自动隐藏loadingView, 默认为YES
@property (nonatomic, assign) BOOL autoHiddenSuccessLoading;
@property (nonatomic, assign) BOOL autoHiddenfailLoading;
@property (nonatomic, assign) BOOL autoHiddenNoRespondLoading;  // 网络出错无反馈情况
@property (nonatomic, assign) BOOL showLoding;

@property (nonatomic, assign) BOOL hasDomain;
@property (nonatomic, assign) BOOL needShareParams;
@property (nonatomic, assign) BOOL needShareJoinPath;
@property (nonatomic, assign) BOOL isJsonFormData;
@property (nonatomic, assign) BOOL errorBack;

// 请求结果处理
@property (nonatomic, assign) BOOL needDefaultMention;
@property (nonatomic, assign) BOOL needSuccessMsg;  // 默认为NO
@property (nonatomic, copy) NSString *mentionText;
@property (nonatomic, copy) NSString *successText;
@property (nonatomic, copy) NSString *failText;
@property (nonatomic, copy) NSString *defaultRequestMention;
@property (nonatomic, copy) NSString *defaultFailMention;
@property (nonatomic, copy) NSString *defaultFailNetworkMention;
@property (nonatomic, copy) NSString *responseKey;
@property (nonatomic, assign) NSInteger successCode;
@property (nonatomic, assign) NSInteger noLoginCode;
@property (nonatomic, assign) BOOL needCache;

#pragma mark - 需要解析数据

+ (instancetype)objectWithParams:(id)params sourceType:(NSInteger)type;

@property (nonatomic, strong) ZJParseObject *parseObject;

@end

NS_ASSUME_NONNULL_END
