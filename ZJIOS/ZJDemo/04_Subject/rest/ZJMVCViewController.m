//
//  ZJMVCViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/16.
//

#import "ZJMVCViewController.h"

@interface ZJMVCViewController ()

@end

@implementation ZJMVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
/*
 
 MVVM与MVC的区别有：1、mvvm各部分的通信是双向的，而mvc各部分通信是单向的；2、mvvm是真正将页面与数据逻辑分离放到js里去实现，而mvc里面未分离。
 View 传送指令到 ControllerController 完成业务逻辑后，要求 Model 改变状态Model 将新的数据发送到 View，用户得到反馈
 MVVM包括view视图层、model数据层、viewmodel层。各部分通信都是双向的。采用双向数据绑定，View的变动，自动反映在 ViewModel，反之亦然。其中ViewModel层，就是View和Model层的粘合剂，他是一个放置用户输入验证逻辑，视图显示逻辑，发起网络请求和其他各种各样的代码的极好的地方。说白了，就是把原来ViewController层的业务逻辑和页面逻辑等剥离出来放到ViewModel层
 
 在MVC里，View是可以直接访问Model的，所以View里会包含Model信息以及一些业务逻辑。 MVC模型关注的是Model的不变，所以在MVC模型里，Model不依赖于View，但是 View是依赖于Model的。不仅如此，因为有一些业务逻辑在View里实现了，导致要更改View也是比较困难的，至少那些业务逻辑是无法重用的。

 MVVM在概念上是真正将页面与数据逻辑分离的模式，它把数据绑定工作放到一个JS里去实现，而这个JS文件的主要功能是完成数据的绑定，即把model绑定到UI的元素上。此外MVVM另一个重要特性双向绑定，它更方便你去同时维护页面上都依赖于某个字段的N个区域，而不用手动更新它们。
 
 
 1. 各部分之间的通信，都是双向的。

 2. View 与 Model 不发生联系，都通过 Presenter 传递。

 3. View 非常薄，不部署任何业务逻辑，称为"被动视图"（Passive View），即没有任何主动性，而 Presenter非常厚，所有逻辑都部署在那里。
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
