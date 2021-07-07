//
//  ZJHTTPRequest.m
//  CanShengHealth
//
//  Created by ZJ on 03/02/2018.
//  Copyright © 2018 HY. All rights reserved.
//

#import "ZJHTTPRequest.h"
#import "ZJFondationCategory.h"
#import "ZJNSObjectCategory.h"

#define RequestTypes @[@"GET", @"POST", @"DELETE", @"PUT"]

@interface ZJHTTPRequest()

@property (nonatomic, strong) NSDictionary *shareParams;
@property (nonatomic, strong) NSDictionary *shareJoinPath;

@end

static ZJHTTPRequest *_requestManage = nil;

@implementation ZJHTTPRequest
@synthesize kDomain = _kDomain;

+ (instancetype)shareHTTPRequest {
    if (!_requestManage) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _requestManage = [[self alloc] init];
        });
    }
    
    return _requestManage;
}

- (NSURLCache *)defaultURLCache {
    return [[NSURLCache alloc] initWithMemoryCapacity:20 * 1024 * 1024
                                         diskCapacity:150 * 1024 * 1024
                                             diskPath:@"com.zj.imagedownloader"];
}

- (NSURLSessionConfiguration *)defaultURLSessionConfigurationL:(NSTimeInterval)timeout {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //TODO set the default HTTP headers
    
    configuration.HTTPShouldSetCookies = YES;
    configuration.HTTPShouldUsePipelining = NO;
    
    configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    configuration.allowsCellularAccess = YES;
    configuration.timeoutIntervalForRequest = timeout;
    configuration.URLCache = [self defaultURLCache];
    
    return configuration;
}

#pragma mark - new version

- (void)requestWithRequestObject:(ZJRequestObject *)object completion:(HTTPRequestCompletionHandle)completion {
    NSString *mention = @"";
    if (object.mentionText) {
        mention = object.mentionText;
    }else if (object.needDefaultMention) {
        mention = object.defaultRequestMention;
    }
    if (object.showLoding) {
        HiddenProgressView(NO, mention, 0);
    }

    NSString *urlString = object.path;
    NSString *domain = self.kDomain;
    id mParams;
    if ([object.params isKindOfClass:[NSDictionary class]]) {
        mParams = ((NSDictionary *)object.params).mutableCopy;
    }else {
        mParams = object.params;
    }
    if (object.needShareParams && [mParams isKindOfClass:[NSDictionary class]]) [((NSMutableDictionary *)mParams) addEntriesFromDictionary:self.shareParams];
    if ([self.kDomain hasSuffix:@"/"]) domain = [domain substringToIndex:domain.length - 1];
    
    if (!object.hasDomain) {
        if (![urlString hasPrefix:@"/"]) urlString = [@"/" stringByAppendingString:urlString];
    }

    if (!object.hasDomain) urlString = [NSString stringWithFormat:@"%@%@", domain, urlString];

    NSURL *url = [NSURL URLWithString:urlString];
    ZJHTTPRequestType type = object.type;
    if (type == ZJHTTPRequestTypeOfGet) {
        if (object.needShareJoinPath && [mParams isKindOfClass:[NSDictionary class]]) [((NSMutableDictionary *)mParams) addEntriesFromDictionary:self.shareJoinPath];
        NSString *paramsString = [mParams httpParamsString];
        
        NSString *paramUrlString;
        if (paramsString.length) {
            paramUrlString = [NSString stringWithFormat:@"%@?%@", urlString, paramsString];
        }else {
            paramUrlString = urlString.copy;
        }
        url = [NSURL URLWithString:[paramUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }else {
        NSString *paramsString;
        if (object.needShareJoinPath) {
            paramsString = [self.shareJoinPath httpParamsString];
        }
        NSString *paramUrlString;
        if (paramsString.length) {
            paramUrlString = [NSString stringWithFormat:@"%@?%@", urlString, paramsString];
        }else {
            paramUrlString = urlString.copy;
        }
        url = [NSURL URLWithString:[paramUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    object.absoluteUrlString = url.absoluteString;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:object.timeoutInterval];
    if (type != ZJHTTPRequestTypeOfGet) {
        [request setHTTPMethod:RequestTypes[type]];
        [request setHTTPShouldHandleCookies:YES];

        NSData *data; NSString *contentValue;
        if (object.isJsonFormData) {
            contentValue = @"application/json;charset=utf-8";
            data = [NSJSONSerialization dataWithJSONObject:mParams options:0 error:nil];
        }else {
            contentValue = @"application/x-www-form-urlencoded;charset=utf-8";
            NSError *error;
            data = [NSJSONSerialization dataWithJSONObject:mParams options:0 error:&error];
            NSLog(@"数据error = %@", error);  //data = [[mParams httpParamsString] dataUsingEncoding:NSUTF8StringEncoding];
        }
        [request setValue:contentValue forHTTPHeaderField:@"Content-Type"]; // 泄露
        request.HTTPBody = data;    // 泄露
    }
    
    if (self.shareHeaders.allKeys.count) {
        for (NSString *key in self.shareHeaders) {
            NSString *value = self.shareHeaders[key];
            [request addValue:value forHTTPHeaderField:key];
        }
    }
    
    NSURLSessionDataTask *dataTask;
    NSURLSessionConfiguration *configuration = [self defaultURLSessionConfigurationL:object.timeoutInterval];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    __weak typeof(self) weekSelf = self;
    dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [weekSelf handleRequestBack:data response:response requestObject:object error:error completion:completion];
    }];

    [dataTask resume];
}

- (void)handleRequestBack:(NSData *)data response:(NSURLResponse *)response requestObject:(ZJRequestObject *)object error:(NSError *)error completion:(HTTPRequestCompletionHandle)completion {
#ifdef DEBUG_LOG
    NSLog(@"response.URL = %@", response.URL.absoluteString);
#endif
    if (data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
#ifdef DEBUG_PARSE_LOG
        NSLog(@"response = %@, response.URL = %@", response, response.URL.absoluteString);
        NSLog(@"allHeaderFields = %@", ((NSHTTPURLResponse *)response).allHeaderFields);
        NSLog(@"error = %@", error);
        NSLog(@"dic = %@", dic);
        NSLog(@"stringDic = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
#endif
        NSInteger code = 500;
        BOOL success = NO;
        if ([dic containsKey:object.responseKey]) {
            code = [dic[object.responseKey] integerValue];
            success = code == object.successCode;
        }
        
        id backInfo = nil;
        BOOL hasLogin = YES;
        
        if (success) {
            backInfo = dic;
            if (object.needCache) {
                [dic saveToFileWithURL:object.absoluteUrlString];
            }
        }else if(code == object.noLoginCode) {
            hasLogin = NO;
        }else {
            if (object.needCache) {
                id cachedResponseObject = [self loadCatch:object];
                if (cachedResponseObject) {
                    success = YES;
                    backInfo = cachedResponseObject;
                }
            }else if (object.errorBack) {
                backInfo = dic;
            }
        }
        
        NSString *text = @"";
        id msg = dic[@"msg"];
        if (msg && [msg isKindOfClass:[NSString class]]) {
            text = msg;
        }
        
        if (success) {
            if(object.successText) {
                text = object.successText;
            }else if (object.needSuccessMsg == NO) {
                text = @"";
            }
        }else {
            if (object.failText) {
                text = object.failText;
            }
        }
        
        if (success) {
            if (object.autoHiddenSuccessLoading) {
                HiddenProgressView(YES, text, text.length ? 1.0 : 0);
            }
        }else {
            if (object.autoHiddenfailLoading) {
                HiddenProgressView(YES, text, 1.0);
            }
        }
        completion(backInfo, hasLogin);
    }else {
        NSString *text = object.defaultFailMention;
        if (object.failText) {
            text = object.failText;
        }
        if ([ZJReachabilityManage shareManager].connectNet == NO) {
            text = object.defaultFailNetworkMention;
        }

        if (object.needCache) {
            id cachedResponseObject = [self loadCatch:object];
            if (cachedResponseObject) {
                text = @"";
            }
            completion(cachedResponseObject, YES);
        }else {
            completion(nil, YES);
        }
        if (object.autoHiddenNoRespondLoading) {
            HiddenProgressView(YES, text, 1.0);
        }
    }
}

- (id)loadCatch:(ZJRequestObject *)object {
    NSString *filePath = [object.absoluteUrlString jsonFilePath];
    NSError *readError = nil;
    NSData *data = [NSData dataWithContentsOfFile:filePath options:0 error:&readError];
    if (readError == nil && data != nil) {
        id cachedResponseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&readError];
        return cachedResponseObject;
    }else {
        return nil;
    }
}

- (NSDictionary *)shareHeaders {
    if (_shareHeaders == nil || _shareHeaders.allKeys.count < 2) {
        NSMutableDictionary *dic = @{
                                     @"appKey" : @"27f436654b6e",
                                     }.mutableCopy;
        if (kUserToken) {
            dic[@"token"] = kUserToken;
            NSLog(@"请求token = %@", kUserToken);
        }
        _shareHeaders = [dic mutableCopy];
    }
    
    return _shareHeaders;
}

- (NSDictionary *)shareParams {
    if (!_shareParams) {
        _shareParams = @{
                         @"mobileModel" : [UIDevice iPhoneType],   // 手机型号
                         @"mobileType" : @"2",  // 手机类型：1安卓，2iOS
                         @"mobileVersion" : [UIDevice systemVersion],    // 系统版本
                         @"versionCode" : @([UIApplication appInfoWithType:AppInfoTypeOfBundleVersion].integerValue),
                         @"versionName" : [UIApplication appInfoWithType:AppInfoTypeOfVersion],
                         };
    }
    
    return _shareParams;
}

- (NSDictionary *)shareJoinPath {
    if (!_shareJoinPath) {
        _shareJoinPath = @{
                           @"mobileModel" : [UIDevice iPhoneType],   // 手机型号
                           @"mobileType" : @"2",  // 手机类型：1安卓，2iOS
                           @"mobileVersion" : [UIDevice systemVersion],    // 系统版本
                           @"versionCode" : @([UIApplication appInfoWithType:AppInfoTypeOfBundleVersion].integerValue),
                           @"versionName" : [UIApplication appInfoWithType:AppInfoTypeOfVersion],
                         };
    }
    
    return _shareJoinPath;
}

- (NSString *)kEnv {
    if ([UIApplication isComVersion]) {
        return @"dev";
    }else {
        return @"prod";
    }
}

- (NSString *)kDomain {
    if (!_kDomain) {
        if ([UIApplication isComVersion]) {
            _kDomain = kComDomain;
        }else {
            _kDomain = kNetDomain;
        }
    }
    
    return _kDomain;
    
}
//
//+ (void)setCookie:(NSURL *)url {
//    NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    NSArray<NSHTTPCookie *> *cookies = [cookieStorage cookiesForURL:url];
//    [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull cookie, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSMutableDictionary *properties = [[cookie properties] mutableCopy];
//        //将cookie过期时间设置为一年后
//        NSDate *expiresDate = [NSDate dateWithTimeIntervalSinceNow:3600*24*30*12];
//        properties[NSHTTPCookieExpires] = expiresDate;
//        //下面一行是关键,删除Cookies的discard字段，应用退出，会话结束的时候继续保留Cookies
//        [properties removeObjectForKey:NSHTTPCookieDiscard];
//        //重新设置改动后的Cookies
//        [cookieStorage setCookie:[NSHTTPCookie cookieWithProperties:properties]];
//    }];
//}

@end
