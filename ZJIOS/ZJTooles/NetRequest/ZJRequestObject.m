//
//  ZJRequestObject.m
//  KeerZhineng
//
//  Created by ZJ on 2018/12/14.
//  Copyright © 2018 HY. All rights reserved.
//

#import "ZJRequestObject.h"

static NSString *DefaultRequestMention = @"请稍候...";
static NSString *DefaultFailMention = @"数据连接超时";
static NSString *DefaultNetworkFailMention = @"网络未连接,请检查网络设置";
static NSString *ResponseKey = @"code";
static NSInteger SuccessCode = 0;
static NSInteger NoLoginCode = 401;

#define TimeoutInterval 15

@interface ZJRequestObject()

@end

@implementation ZJRequestObject

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isJsonFormData = YES;
        self.timeoutInterval = TimeoutInterval;
        //
        self.needShareJoinPath = YES;
        //
        self.showLoding = YES;
        self.autoHiddenSuccessLoading = YES;
        self.autoHiddenfailLoading = YES;
        self.autoHiddenNoRespondLoading = YES;
        
        //
        self.defaultRequestMention = DefaultRequestMention;
        self.defaultFailMention = DefaultFailMention;
        self.defaultFailNetworkMention = DefaultNetworkFailMention;
        self.responseKey = ResponseKey;
        self.successCode = SuccessCode;
        self.noLoginCode = NoLoginCode;
    }
    
    return self;
}

+ (instancetype)objectWithParams:(id)params path:(NSString *)path {
    ZJRequestObject *obj = [ZJRequestObject new];
    if ([params isKindOfClass:[NSDictionary class]]) {
        [obj handleEmptyParams:params];
    }else {
        obj.params = params;
    }
    obj.path = path;
    
    return obj;
}

- (void)handleEmptyParams:(NSDictionary *)params {
    NSMutableDictionary *dic = @{}.mutableCopy;
    for (NSString *key in params.allKeys) {
        if (params[key] != nil) {
            dic[key] = params[key];
        }else {
            NSLog(@"%@参数为空", key);
        }
    }
    self.params = dic;
}

#pragma mark - new version

+ (instancetype)objectWithParams:(id)params sourceType:(NSInteger)type {
    ZJRequestObject *obj = [ZJRequestObject new];
    if ([params isKindOfClass:[NSDictionary class]]) {
        [obj handleEmptyParams:params];
    }else {
        obj.params = params;
    }
    [obj setValueWithSourceType:type];
    
    return obj;
}

- (ZJRequestObject *)setValueWithSourceType:(NSInteger)type {
    NSDictionary *source = [ZJRequestSource shareSource].requestSources[type];
    
    NSString *path = source[RequestPathKey];
    BOOL isJoinPath = [source[RequestIsJoinPath] boolValue];
    if (isJoinPath) {
        self.path = [path pathWithParam:self.params[JoinPathParamsKey]];
        NSMutableDictionary *dic = ((NSDictionary *)self.params).mutableCopy;
        [dic removeObjectForKey:JoinPathParamsKey];
        self.params = dic;
    }else {
        self.path = path;
    }
    
    ZJParseObject *obj = [ZJParseObject new];
    obj.returnType = source[ReturnDataType];
    obj.parseDataFlag = source[ParseDataFlag];
    obj.parseObjectType = source[ParseObjectType];
    
    obj.isPageData = [source[RequestIsPageData] boolValue];
    if (obj.isPageData) {
        obj.parsePageDataFlag = source[ParsePageDataFlag];
        obj.pageDataCountFlag = source[PageDataCountFlag];
    }
    
    if ([source containsKey:ParseSubDataFlag]) {
        obj.parseSubDataFlag = source[ParseSubDataFlag];
        obj.parseSubObjectType = source[ParseSubObjectType];
    }
    
    if ([source containsKey:ParseAssistDataType]) {
        obj.assistDataType = [source[ParseAssistDataType] integerValue];
    }
    self.parseObject = obj;
    
    return self;
}

@end
