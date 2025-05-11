//
//  ZJTestNSURLViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/5/19.
//

#import "ZJTestNSURLViewController.h"
#import "NSString+ZJTextEncode.h"
#import <WebKit/WebKit.h>

@interface ZJTestNSURLViewController ()

@end

@implementation ZJTestNSURLViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initAry];
}

- (void)initAry {
    self.vcType = ZJBaseTableViewTypeExecute;
    self.cellTitles = @[@"test0"];
}

/*
 作为基础路径参与组合，可传入本地或远程 URL（如 [NSURL URLWithString:@"http://example.com"]）
 ‌‌关键特性‌：若 URLString 为绝对路径，则忽略 baseURL 直接解析；若 baseURL 为 nil，等价于调用 URLWithString:
 
 组合逻辑示例
 NSURL *base = [NSURL URLWithString:@"http://example.com/v2/"];
 NSURL *url = [NSURL URLWithString:@"data?page=1" relativeToURL:base];
 URLString 若以 / 开头（如 @"/data"），将从 baseURL 的根路径开始拼接；否则继承 baseURL 的当前路径层级
 
 兼容性注意事项
 ‌‌调试断言‌
 通过 Runtime 方法交换（Method Swizzling）可在调试阶段强制检查 URL 有效性，避免静默失败
 + (void)load {
     Method original = class_getClassMethod(self, @selector(URLWithString:relativeToURL:));
     Method swizzled = class_getClassMethod(self, @selector(zx_URLWithString:relativeToURL:));
     method_exchangeImplementations(original, swizzled);
 }

 + (instancetype)zx_URLWithString:(NSString *)URLString relativeToURL:(NSURL *)baseURL {
     NSURL *url = [self zx_URLWithString:URLString relativeToURL:baseURL];
     NSAssert(url != nil, @"URL拼接失败: base=%@, path=%@", baseURL, URLString);
     return url;
 }

 // 结果: http://example.com/v2/data?page=1

 */
- (void)test0 {
    NSString *url = @"https://app.sycommercial.com/BM/ygapp/jsp/patrolPlan.jsp?isyg=1&f_patroltype=保洁ticket=6e56acc7-f249-4817-8efa-651bbdc1794e&userId=e5122b0dba2f4128bc4465df63dd2739&lan=zh";
    NSURL *endURL = [NSURL URLWithString:[url URLEncodedString]];
    NSLog(@"endURL = %@", endURL);
    NSLog(@"absoluteString = %@", endURL.absoluteString);
    NSLog(@"scheme = %@", endURL.scheme);
    NSLog(@"resourceSpecifier = %@", endURL.resourceSpecifier);
    NSLog(@"host = %@", endURL.host);
    NSLog(@"port = %@", endURL.port);
    NSLog(@"user = %@", endURL.user);
    NSLog(@"password = %@", endURL.password);
    NSLog(@"path = %@", endURL.path);
    NSLog(@"fragment = %@", endURL.fragment);
    NSLog(@"query = %@", endURL.query);
    NSLog(@"relativePath = %@", endURL.relativePath);

    NSString *decodedString = [endURL.absoluteString URLDecodedString];
    NSLog(@"decodedString = %@", decodedString);
    NSURL *bdUrl = [NSURL URLWithString:@"https://www.baidu.com"];
    NSLog(@"bdUrl = %@", bdUrl);
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
