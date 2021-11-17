//
//  ZJAssignnWeakViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/14.
//

#import "ZJAssignnWeakViewController.h"
#import <WebKit/WebKit.h>
#import <WebKit/WKWebView.h>

@interface ZJAssignnWeakViewController ()

@end
typedef void(^BlockA)(void);
@implementation ZJAssignnWeakViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
}
/*
 我们都知道，assign用来修饰基本数据类型，weak用来修饰OC对象。

 其实照理，assign也能修饰OC对象，但是assign修饰的对象在该对象释放后，其指针依然存在，不会被置为nil——这就造成了一个很严重的问题：出现了野指针。当访问这个野指针时，指向了原地址，而原地址有两种情况：
 第一种情况：原地址没有改变，代码运行通过，但很有可能有逻辑bug。
 第二种情况：原地址已经改变，结果不可预测，多数崩溃，也有可能出现其他莫名错误。
 但是用weak来修饰的话，对象释放的时候会把指针置为nil，从而避免了野指针的出现。

 那又有个疑问出现了，凭什么基本数据类型就可以使用assign。这就要扯到堆和栈的问题了，基本数据类型会被分配到栈空间，而栈空间是由系统自动管理分配和释放的，就不会造成野指针的问题。
 */
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
