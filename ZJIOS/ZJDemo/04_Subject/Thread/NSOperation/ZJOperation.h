//
//  ZJOperation.h
//  ZJFoundation
//
//  Created by hanyou on 15/12/1.
//  Copyright © 2015年 YunTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZJOperation;

@protocol ZJHTTPDownloadDelegate <NSObject>

@optional

- (void)zjHTTPDownload:(ZJOperation *)downloader downloadProgress:(double)progress;
- (void)zjHTTPDownload:(ZJOperation *)downloader didDownloadWithData:(NSData *)data;
- (void)zjHTTPDownload:(ZJOperation *)downloader didFailWithError:(NSError *)error;

@end

typedef void (^downloadProgress)(float percent);
typedef void (^completion)(id response, NSError *error);


@interface ZJOperation : NSOperation

- (instancetype)initWithRequestURL:(NSURL *)url
                          progress:(downloadProgress)progress
                        completion:(completion)completion;

@property (nonatomic, weak) id <ZJHTTPDownloadDelegate> delegate;

@end
