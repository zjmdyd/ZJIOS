//
//  ZJWebViewController.m
//  DiabetesGuard
//
//  Created by ZJ on 7/20/16.
//  Copyright © 2016 YCLZONE. All rights reserved.
//

#import "ZJWebViewController.h"
#import "ZJDefine.h"

@interface ZJWebViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ZJWebViewController

//@synthesize webView = _webView;

- (instancetype)initWithAddress:(NSString *)address title:(NSString *)title {
    if (self = [super init]) {
        self.title = title;
        self.address = address;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSetting];
}

- (void)initSetting {
    if (!self.title.length) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        self.title = infoDictionary[@"CFBundleName"] ?: @"";
    }
}

- (void)stopLoad {
    [self.webView stopLoading];
    [self webView:self.webView DidFailLoadWithError:nil];
}

- (void)requestData {
    if (self.address.length == 0) return;
    
    if ([self.address hasPrefix:@"http:"] || [self.address hasPrefix:@"https:"]) {
#ifdef HiddenProgress
        HiddenProgressView(NO, @"请稍候...", 0);
#endif
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeoutInterval target:self selector:@selector(stopLoad) userInfo:nil repeats:NO];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.address] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:self.timeoutInterval];
        [self.webView loadRequest:request];
    }else {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:self.address ofType:@"html"];
        NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
    }
}

#pragma mark - setter

- (void)setAddress:(NSString *)address {
    _address = address;
    
    [self requestData];
}

#pragma mark - UIWebViewDelegate

//当网页视图已经开始加载一个请求后，得到通知。
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"%s", __func__);
    if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:webView];
    }
}

//当网页视图结束加载一个请求之后，得到通知。
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"%s", __func__);
#ifdef HiddenProgress
    HiddenProgressView(YES, @"请稍候...", 0);
#endif
    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:webView];
    }
}

//当在请求加载中发生错误时，得到通知。会提供一个NSSError对象，以标识所发生错误类型。
- (void)webView:(UIWebView *)webView DidFailLoadWithError:(NSError*)error {
#ifdef HiddenProgress
    HiddenProgressView(YES, @"加载失败", 0);
#endif
    NSLog(@"%s, error = %@", __func__, error);
    if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:webView didFailLoadWithError:error];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [self.delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    NSString *requestString = [[request URL] absoluteString];                   // 获取请求的绝对路径.
    NSLog(@"requestString-->%@", requestString);
    
    return YES;
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _webView.delegate = self;
        [_webView scalesPageToFit];
        [self.view addSubview:_webView];
    }
    
    return _webView;
}

- (NSTimeInterval)timeoutInterval {
    if (_timeoutInterval < FLT_EPSILON) {
        _timeoutInterval = DefaultTimeoutInterval;
    }
    
    return _timeoutInterval;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
