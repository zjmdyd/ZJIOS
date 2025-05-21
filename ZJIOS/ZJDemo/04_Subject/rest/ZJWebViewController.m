//
//  ZJWebViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2021/7/2.
//

#import "ZJWebViewController.h"
#import <WebKit/WebKit.h>

@interface ZJWebViewController ()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;

@end

/*
 2.修改颜色和字体
 
 // WKNavigationDelegate 页面加载完成之后调用
 - (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
 //修改字体大小 300%
 [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '200%'"completionHandler:nil];
 
 //修改字体颜色  #9098b8
 [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#222222'"completionHandler:nil];
 }
 */
@implementation ZJWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建网页配置对象
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    // 创建设置对象
    WKPreferences *preference = [[WKPreferences alloc]init];
    //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
    preference.minimumFontSize = 0;
    //设置是否支持javaScript 默认是支持的
    preference.javaScriptEnabled = YES;
    
    // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
    preference.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = preference;
    
    // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
    config.allowsInlineMediaPlayback = YES;
    //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
    if (@available(iOS 10.0, *)) {
        config.mediaTypesRequiringUserActionForPlayback = YES;
    } else {
        // Fallback on earlier versions
    }
    //设置是否允许画中画技术 在特定设备上有效
    if (@available(iOS 9.0, *)) {
        config.allowsPictureInPictureMediaPlayback = YES;
    } else {
        // Fallback on earlier versions
    }
    //设置请求的User-Agent信息中应用程序名称 iOS9后可用
    if (@available(iOS 9.0, *)) {
        config.applicationNameForUserAgent = @"ChinaDailyForiPad";
    } else {
        // Fallback on earlier versions
    }
    //自定义的WKScriptMessageHandler 是为了解决内存不释放的问题
    //    WeakWebViewScriptMessageDelegate *weakScriptMessageDelegate = [[WeakWebViewScriptMessageDelegate alloc] initWithDelegate:self];
    //    //这个类主要用来做native与JavaScript的交互管理
    //    WKUserContentController * wkUController = [[WKUserContentController alloc] init];
    //    //注册一个name为jsToOcNoPrams的js方法
    //    [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"jsToOcNoPrams"];
    //    [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"jsToOcWithPrams"];
    //    config.userContentController = wkUController;
    
    //         WeakWebViewScriptMessageDelegate *weakScriptMessageDelegate = [[WeakWebViewScriptMessageDelegate alloc] initWithDelegate:self];
    //         //这个类主要用来做native与JavaScript的交互管理
    //         WKUserContentController * wkUController = [[WKUserContentController alloc] init];
    //         //注册一个name为jsToOcNoPrams的js方法
    //         [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"jsToOcNoPrams"];
    //         [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"jsToOcWithPrams"];
    //        config.userContentController = wkUController;
    
    self.webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:config];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    //        _webView.delegate = self;
    //        [_webView scalesPageToFit];
    [self.view addSubview:self.webView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"userHelp.html" ofType:nil];
    NSString *htmlString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //加载本地html文件
    [self.webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    //
    //这个类主要用来做native与JavaScript的交互管理
    WKUserContentController * wkUController = [[WKUserContentController alloc] init];
    //注册一个name为jsToOcNoPrams的js方法，设置处理接收JS方法的代理
    [wkUController addScriptMessageHandler:self  name:@"jsToOcNoPrams"];
    [wkUController addScriptMessageHandler:self  name:@"jsToOcWithPrams"];
    config.userContentController = wkUController;
    
    //OC调用JS  changeColor()是JS方法名，completionHandler是异步回调block
    //    NSString *jsString = [NSString stringWithFormat:@"changeColor('%@')", @"Js参数"];
    //    [_webView evaluateJavaScript:jsString completionHandler:^(id _Nullable data, NSError * _Nullable error) {
    //        NSLog(@"改变HTML的背景色");
    //    }];
    
    //改变字体大小 调用原生JS方法
    //    NSString *jsFont = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", arc4random()%99 + 100];
    //    [_webView evaluateJavaScript:jsFont completionHandler:nil];
    //    [self.webView evaluateJavaScript:@"document.getElementsByName('mytext').style.webkitTextSizeAdjust= '200%'"completionHandler:nil];
    //
    //以下代码适配文本大小，由UIWebView换为WKWebView后，会发现字体小了很多，这应该是WKWebView与html的兼容问题，解决办法是修改原网页，要么我们手动注入JS
//    NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    //用于进行JavaScript注入
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [config.userContentController addUserScript:wkUScript];
}

#pragma mark - WKScriptMessageHandler

//通过接收JS传出消息的name进行捕捉的回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"name:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n",message.name,message.body,message.frameInfo);
    //用message.body获得JS传出的参数体
    //    NSDictionary * parameter = message.body;
    //    //JS调用OC
    //    if([message.name isEqualToString:@"jsToOcNoPrams"]){
    //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"js调用到了oc" message:@"不带参数" preferredStyle:UIAlertControllerStyleAlert];
    //        [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        }])];
    //        [self presentViewController:alertController animated:YES completion:nil];
    //
    //    }else if([message.name isEqualToString:@"jsToOcWithPrams"]){
    //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"js调用到了oc" message:parameter[@"params"] preferredStyle:UIAlertControllerStyleAlert];
    //        [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        }])];
    //        [self presentViewController:alertController animated:YES completion:nil];
    //    }
}

#pragma mark - WKNavigationDelegate

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"%s", __func__);
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%s", __func__);
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"%s", __func__);
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"%s", __func__);
//    NSString *jsString = @"document.getElementById('p1').innerHTML = 'hello kitty!';document.getElementById('p1').style.color = 'blue';";
    NSString *jsString = @"document.getElementById('p1').style.fontSize = '50px';";
    NSString *jsString2 = @"document.getElementById('p1').style.margin = '16px';";

    [self.webView evaluateJavaScript:jsString completionHandler:nil];
}

//提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%s", __func__);
}

// 接收到服务器跳转请求即服务重定向时之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"%s", __func__);
}

// 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"%s", __func__);
    NSString * urlStr = navigationAction.request.URL.absoluteString;
    NSLog(@"发送跳转请求：%@",urlStr);
    //自己定义的协议头
    NSString *htmlHeadString = @"github://";
    if([urlStr hasPrefix:htmlHeadString]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"通过截取URL调用OC" message:@"你想前往我的Github主页?" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }])];
        [alertController addAction:([UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL * url = [NSURL URLWithString:[urlStr stringByReplacingOccurrencesOfString:@"github://callName_?" withString:@""]];
            [[UIApplication sharedApplication] openURL:url];
        }])];
        [self presentViewController:alertController animated:YES completion:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

// 根据客户端受到的服务器响应头以及response相关信息来决定是否可以跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@"%s", __func__);
    //   NSString * urlStr = navigationResponse.response.URL.absoluteString;
    //   NSLog(@"当前跳转地址：%@",urlStr);
    //   //允许跳转
    //   decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}

//需要响应身份验证时调用 同样在block中需要传入用户身份凭证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    //用户身份信息
    NSURLCredential * newCred = [[NSURLCredential alloc] initWithUser:@"user123" password:@"123" persistence:NSURLCredentialPersistenceNone];
    //为 challenge 的发送方提供 credential
    [challenge.sender useCredential:newCred forAuthenticationChallenge:challenge];
    completionHandler(NSURLSessionAuthChallengeUseCredential,newCred);
}

//进程被终止时调用
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    
}

#pragma mark - WKUIDelegate
/**
 *  web界面中有弹出警告框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param message           警告框中的内容
 *  @param completionHandler 警告框消失调用
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"HTML的弹出框" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 确认框
//JavaScript调用confirm方法后回调的方法 confirm是js中的确定框，需要在block中把用户选择的情况传递进去
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 输入框
//JavaScript调用prompt方法后回调的方法 prompt是js中的输入框 需要在block中把用户输入的信息传入
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 页面是弹出窗口 _blank 处理
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //用完记得移除
    //移除注册的js方法
    [[self.webView configuration].userContentController removeScriptMessageHandlerForName:@"jsToOcNoPrams"];
    [[self.webView configuration].userContentController removeScriptMessageHandlerForName:@"jsToOcWithPrams"];
    [self.webView stopLoading];
    self.webView = nil;
}

//- (NSString *)reSizeImageWithHTML:(NSString *)html {
//    return [NSString stringWithFormat:@"<meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'><meta name='apple-mobile-web-app-capable' content='yes'><meta name='apple-mobile-web-app-status-bar-style' content='black'><meta name='format-detection' content='telephone=no'><style type='text/css'>img{width:%fpx}</style>%@", [UIScreen mainScreen].bounds.size.width - 20, html];
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
