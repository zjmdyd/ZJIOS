//
//  ZJOperation.m
//  ZJFoundation
//
//  Created by hanyou on 15/12/1.
//  Copyright © 2015年 YunTu. All rights reserved.
//

#import "ZJOperation.h"

#define DELEGATE_HAS_METHOD(delegate, method) delegate && [delegate respondsToSelector:@selector(method)]

typedef NS_ENUM(NSInteger, ZJRequestState) {
    ZJRequestStateReady     = 0,
    ZJRequestStateExecuting = 1,
    ZJRequestStateFinished  = 2,
};

static const NSTimeInterval kRequestTimeout = 20.f;

@interface ZJOperation ()

@property (nonatomic, strong) NSMutableData *fileData;
@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, strong) NSURLConnection *connection;

@property (nonatomic, assign) float expectedLength;
@property (nonatomic, assign) float receivedLength;
@property (nonatomic, assign) ZJRequestState state;
@property (nonatomic, assign) CFRunLoopRef operationRunLoop;

@property (nonatomic, copy) completion completion;
@property (nonatomic, copy) downloadProgress progress;

@end

@implementation ZJOperation

@synthesize state = _state;

- (instancetype)initWithRequestURL:(NSURL *)url
                          progress:(downloadProgress)progress
                        completion:(completion)completion {
    if (self = [super init]) {
        self.progress = progress;
        self.completion = completion;
        self.request = [NSMutableURLRequest requestWithURL:url
                                               cachePolicy:NSURLRequestReloadIgnoringCacheData
                                           timeoutInterval:kRequestTimeout];
    }
    
    return self;
}

#pragma mark - NSOperation Methods

- (void)start {
    if (self.isCancelled) {
        [self finish];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    self.state = ZJRequestStateExecuting;
    [self didChangeValueForKey:@"isExecuting"];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:self.request
                                                      delegate:self
                                              startImmediately:NO];
    
    NSOperationQueue *currentQueue = [NSOperationQueue currentQueue];
    BOOL backgroundQueue           = (currentQueue != nil && currentQueue != [NSOperationQueue mainQueue]);
    NSRunLoop *targetRunLoop       = (backgroundQueue)?[NSRunLoop currentRunLoop]:[NSRunLoop mainRunLoop];
    
    [self.connection scheduleInRunLoop:targetRunLoop forMode:NSRunLoopCommonModes];
    [self.connection start];
    
    // make NSRunLoop stick around until operation is finished
    if (backgroundQueue) {
        self.operationRunLoop = CFRunLoopGetCurrent(); CFRunLoopRun();
    }
}

- (void)cancel {
    if (![self isExecuting]) return;
    
    [super cancel];
    [self finish];
}

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isFinished {
    return self.state == ZJRequestStateFinished;
}

- (BOOL)isExecuting {
    return self.state == ZJRequestStateExecuting;
}

- (void)finish {
    [self.connection cancel];
    self.connection = nil;

    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];

    self.state = ZJRequestStateFinished;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.expectedLength = response.expectedContentLength;
    self.receivedLength = 0;
    self.fileData       = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.fileData appendData:data];
    self.receivedLength += data.length;
    
    float percent = self.receivedLength / self.expectedLength;
    
    if (self.progress) self.progress(percent);
    
    if (DELEGATE_HAS_METHOD(self.delegate, zjHTTPDownload:downloadProgress:)) {
        [self.delegate zjHTTPDownload:self downloadProgress:percent];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self downloadFinishedWithResponse:self.fileData error:nil];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self downloadFinishedWithResponse:nil error:error];
}

#pragma mark - Download Finished

- (void)downloadFinishedWithResponse:(id)response error:(NSError *)error {
    if (self.operationRunLoop) CFRunLoopStop(self.operationRunLoop);
    
    if (self.isCancelled) return;
    
    if (self.completion) self.completion(self.fileData, error);
    
    if (response && DELEGATE_HAS_METHOD(self.delegate, zjHTTPDownload:didDownloadWithData:)) {
        [self.delegate zjHTTPDownload:self didDownloadWithData:response];
    }else if (!response && DELEGATE_HAS_METHOD(self.delegate, zjHTTPDownload:didFailWithError:)) {
        [self.delegate zjHTTPDownload:self didFailWithError:error];
    }
    
    [self finish];
}


- (ZJRequestState)state {
    @synchronized(self) {
        return _state;
    }
}

- (void)setState:(ZJRequestState)newState {
    @synchronized(self) {
        [self willChangeValueForKey:@"state"];
        _state = newState;
        [self didChangeValueForKey:@"state"];
    }
}

- (void)dealloc {
    [self.connection cancel];
}

@end



















