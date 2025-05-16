//
//  ZJNetOperation.h
//  ZJFoundation
//
//  Created by hanyou on 15/12/1.
//  Copyright © 2015年 YunTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZJNetOperation;

@protocol ZJHTTPDownloadDelegate <NSObject>

@optional

- (void)zjHTTPDownload:(ZJNetOperation *)downloader downloadProgress:(double)progress;
- (void)zjHTTPDownload:(ZJNetOperation *)downloader didDownloadWithData:(NSData *)data;
- (void)zjHTTPDownload:(ZJNetOperation *)downloader didFailWithError:(NSError *)error;

@end

typedef void (^DownloadProgress)(float percent);
typedef void (^Completion)(id response, NSError *error);


@interface ZJNetOperation : NSOperation

- (instancetype)initWithRequestURL:(NSURL *)url
                          progress:(DownloadProgress)progress
                        completion:(Completion)completion;

@property (nonatomic, weak) id <ZJHTTPDownloadDelegate> delegate;

@end
