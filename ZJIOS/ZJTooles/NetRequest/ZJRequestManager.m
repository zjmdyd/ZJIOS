//
//  ZJRequestManager.m
//  ButlerSugar
//
//  Created by ZJ on 3/4/16.
//  Copyright © 2016 csj. All rights reserved.
//

#import "ZJRequestManager.h"
#import "ZJParseManager.h"
#import "AppDelegate+HYAppDelegate.h"

@interface ZJRequestManager ()

@end

static ZJRequestManager *_manager = nil;

@implementation ZJRequestManager

+ (instancetype)shareManager {
    if (!_manager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _manager = [[self alloc] init];
        });
    }
    
    return _manager;
}

/***    不需要解析数据 ***/
- (void)requestNoParseWithRequestObject:(ZJRequestObject *)object completion:(RequestCompletionHandle)completion {
    [self requestNoParseWithRequestObject:object type:ZJHTTPRequestTypeOfPost completion:completion];
}

- (void)requestNoParseWithRequestObject:(ZJRequestObject *)object type:(ZJHTTPRequestType)type completion:(RequestCompletionHandle)completion {
    object.type = type;
    [[ZJHTTPRequest shareHTTPRequest] requestWithRequestObject:object completion:^(id obj, BOOL hasLogin) {
        if (hasLogin == NO) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [AppDelegate showRootVCWithType:RootViewControllerTypeOfLogin];
            });
        }else {
            completion([obj noNullDic]);
        }
    }];
}

/***    需要解析数据 ***/

- (void)requestParseDataWithRequest:(ZJRequestObject *)object completion:(RequestCompletionHandle)completion {
    [self requestParseDataWithRequest:object type:ZJHTTPRequestTypeOfGet completion:completion];
}

- (void)requestParseDataWithRequest:(ZJRequestObject *)object type:(ZJHTTPRequestType)type completion:(RequestCompletionHandle)completion {
    object.type = type;
    [[ZJHTTPRequest shareHTTPRequest] requestWithRequestObject:object completion:^(id obj, BOOL hasLogin) {
        if (hasLogin == NO) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [AppDelegate showRootVCWithType:RootViewControllerTypeOfLogin];
            });
        }else {
            if (obj) {
                completion([[ZJParseManager shareManager] parseDataWithParseObject:object.parseObject data:obj]);
            }else {
                completion(nil);
            }
        }
    }];
}

#pragma mark - 上传图片 

// －－－－－－－－－－－－－－－－－－－－－－－－－－－－ 上传图片 －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－


- (void)uploadImageWithParams:(NSDictionary *)params imgPaths:(NSArray *)paths completion:(RequestCompletionHandle)completion {
    [self uploadImageWithParams:params imgPaths:paths isImg:YES mentionText:nil completion:completion];
}

- (void)uploadImageWithParams:(NSDictionary *)params imgPaths:(NSArray *)paths mentionText:(NSString *)text completion:(RequestCompletionHandle)completion {
    [self uploadImageWithParams:params imgPaths:paths isImg:YES mentionText:text completion:completion];
}

- (void)uploadImageWithParams:(NSDictionary *)params imgPaths:(NSArray *)paths isImg:(BOOL)isImg completion:(RequestCompletionHandle)completion {
    [self uploadImageWithParams:params imgPaths:paths isImg:isImg mentionText:nil completion:completion];
}

- (void)uploadImageWithParams:(NSDictionary *)params imgPaths:(NSArray *)paths isImg:(BOOL)isImg mentionText:(NSString *)text completion:(RequestCompletionHandle)completion {
#ifdef HiddenProgress
    HiddenProgressView(NO, text.length?text:@"正在上传...", 0);
#endif
    
#ifdef ZJAFNetworking
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *shareHeaders = [ZJHTTPRequest shareHTTPRequest].shareHeaders;
    for (NSString *key in shareHeaders) {
        [manager.requestSerializer setValue:shareHeaders[key] forHTTPHeaderField:key];
    }
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    
    // 在parameters里存放照片以外的对象
    NSString *typePath;
    if (isImg) {
        typePath = @"/api/v2/user/upload";
    }else {
        typePath = @"/api/v2/user/upload";
    }
    NSString *path = [NSString stringWithFormat:@"%@%@", [ZJHTTPRequest shareHTTPRequest].kDomain, typePath];
    [manager POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        // 这里的_photoArr是你存放图片的数组
        for (int i = 0; i < paths.count; i++) {
            NSData *fileData;
            NSString *fileType;
            NSString *suffix;

            if (isImg) {
                fileType = @"image/jpeg";
                suffix = @"jpg";
                UIImage *image;
                if ([paths[i] isKindOfClass:[UIImage class]]) {
                    image = paths[i];
                }else {
                    image = [[UIImage alloc] initWithContentsOfFile:paths[i]];
                }
                fileData = UIImageJPEGRepresentation(image, 0.5);
            }else {
                fileType = @"video/mp4";
                suffix = @"mp4";
                if ([paths[i] isKindOfClass:[NSString class]]) {
                    fileData = [NSData dataWithContentsOfFile:paths[i]];
                }else {
                    fileData = [NSData dataWithContentsOfURL:paths[i]];
                }
            }
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统时间作为文件名
            NSString *timeStr = [NSString hy_stringFromDate:[NSDate date] withFormat:@"yyyyMMddHHmmss"];
            NSString *fileName = [NSString stringWithFormat:@"%@%d", timeStr, i];
            
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            
            [formData appendPartWithFileData:fileData name:@"file" fileName:[NSString stringWithFormat:@"%@.%@", fileName, suffix] mimeType:fileType]; //
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"---上传进度--- %@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"```上传成功``` %@", responseObject);
        
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
#ifdef DEBUG_LOG
            NSLog(@"dic = %@", dic);
            NSLog(@"string = %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
#endif
            
            NSInteger code = [dic[@"code"] integerValue];
            BOOL success = code == 0;
            
            if (success) {
#ifdef HiddenProgress
                HiddenProgressView(YES, @"上传成功", 1.0);
#endif
                completion(dic);
            }else if(code == 1001) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [AppDelegate showRootVCWithType:RootViewControllerTypeOfLogin];
                });
                completion(nil);
            }else {
#ifdef HiddenProgress
                HiddenProgressView(YES, dic[@"msg"]?:@"上传失败", 0);
#endif
                completion(nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"xxx上传失败xxx %@", error);
#ifdef HiddenProgress
        HiddenProgressView(YES, text.length?text:@"上传失败", 1.0);
#endif
    }];
#endif
}

@end
