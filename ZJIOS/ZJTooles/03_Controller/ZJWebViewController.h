//
//  ZJWebViewController.h
//  DiabetesGuard
//
//  Created by ZJ on 7/20/16.
//  Copyright © 2016 YCLZONE. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZJWebViewControllerDelegate <NSObject>

@optional

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

@end

@interface ZJWebViewController : UIViewController

/**
 @param address 本地html文件或者url
 */
- (instancetype)initWithAddress:(NSString *)address title:(NSString *)title;

@property (nonatomic, copy) NSString *address;
@property (strong, nonatomic, readonly) UIWebView *webView;
@property (nonatomic, weak) id <ZJWebViewControllerDelegate>delegate;

/**
 * 请求超时时长,默认为10s
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@end
