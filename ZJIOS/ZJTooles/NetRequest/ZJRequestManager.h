//
//  ZJRequestManager.h
//  ButlerSugar
//
//  Created by ZJ on 3/4/16.
//  Copyright © 2016 csj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZJHTTPRequest.h"
#import "ZJRequestObject.h"

typedef void(^RequestCompletionHandle)(id obj);

#define AuthBaseUrl @"/api/v2/user/authcode"
#define LoginBaseUrl @"/api/v2/user/login"
#define BindPhoneBaseUrl @"/api/v2/user/bindmobile"

//
#define UserInfoBaseUrl @"/api/v2/user/info"

#define updatePasswordBaseUrl @"/api/app/updatePassword"

@interface ZJRequestManager : NSObject

+ (instancetype)shareManager;

#pragma mark - new version

/***    不需要解析数据 ***/
- (void)requestNoParseWithRequestObject:(ZJRequestObject *)object completion:(RequestCompletionHandle)completion;
- (void)requestNoParseWithRequestObject:(ZJRequestObject *)object type:(ZJHTTPRequestType)type completion:(RequestCompletionHandle)completion;

/***    需要解析数据 ***/
- (void)requestParseDataWithRequest:(ZJRequestObject *)object completion:(RequestCompletionHandle)completion;
- (void)requestParseDataWithRequest:(ZJRequestObject *)object type:(ZJHTTPRequestType)type completion:(RequestCompletionHandle)completion;

#pragma mark - 上传图片

- (void)uploadImageWithParams:(NSDictionary *)params imgPaths:(NSArray *)paths completion:(RequestCompletionHandle)completion;
- (void)uploadImageWithParams:(NSDictionary *)params imgPaths:(NSArray *)paths mentionText:(NSString *)text completion:(RequestCompletionHandle)completion;
- (void)uploadImageWithParams:(NSDictionary *)params imgPaths:(NSArray *)paths isImg:(BOOL)isImg completion:(RequestCompletionHandle)completion;
- (void)uploadImageWithParams:(NSDictionary *)params imgPaths:(NSArray *)paths isImg:(BOOL)isImg mentionText:(NSString *)text completion:(RequestCompletionHandle)completion;

@end
