//
//  ZJCategoryViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/19.
//

#import "ZJCategoryViewController.h"
#import "ZJFruit+ZJFruitCatgy.h"

@interface ZJCategoryViewController ()

//- (void)testExtention;    // // 扩展中能够的方法必须实现

@end

@implementation ZJCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZJFruit *ft = [ZJFruit new];
    NSLog(@"%@", ft.class);
    // Do any additional setup after loading the view.
}
/*
 Extension（扩展）中声明的方法只能在该类的@implementation中实现，这也就意味着，你无法对系统的类（例如NSArray类）使用Extension（扩展）
 因为Extension（扩展）是在编译阶段与该类同时编译的，就是类的一部分。既然作为类的一部分，且与类同时编译，那么就可以在编译阶段为类添加成员变量。
 Category的特性是：可以在运行时阶段动态的为已有类添加新行为。Category是在运行时阶段决定的。而成员变量的内存布局已经在编译阶段确定好了，如果在运行时阶段添加成员变量的话，就会破坏原有类的内存布局
 
 在category默认添加属性是没有效果的，因为分类的结构体指针中，没有成员变量的成员结构
 category只会声明setter，getter，而不会去实现。
 struct _category_t {
     const char *name; // 1
     struct _class_t *cls; // 2
     const struct _method_list_t *instance_methods; // 3
     const struct _method_list_t *class_methods; // 4
     const struct _protocol_list_t *protocols; // 5
     const struct _prop_list_t *properties; // 6
 
 // Fields below this point are not always present on disk. 下面的结构体成员可能会没有
    struct property_list_t *_classProperties;

    method_list_t *methodsForMeta(bool isMeta) {
        if (isMeta) return classMethods;
        else return instanceMethods;
    }

    property_list_t *propertiesForMeta(bool isMeta, struct header_info *hi);
    
    protocol_list_t *protocolsForMeta(bool isMeta) {
        if (isMeta) return nullptr;
        else return protocols;
    }
 };
 1.name 主类的名字
 2.cls 要扩展的类对象，编译期没有值，运行期根据 name 对应到类对象
 3.instance_methods 实例方法列表
 4.class_methods 类方法列表
 5.protocols 实现的协议列表，不常用但确实支持
 6.properties 属性列表，可以定义属性，不能合成实例变量，可通过关联对象进行绑定，与传统实例变量是两样东西。
 
 category特点:
 1.category只能给某个已有的类扩充方法，不能扩充成员变量。编译的时候，是可以通过的，但是会报警告。
 2.category中也可以添加属性，只不过@property只会生成setter和getter的声明，不会生成setter和getter的实现以及成员变量。这个是从设计上考虑保持类别特性的单纯
 3.如果category中的方法和类中原有方法同名，运行时会优先调用category中的方法。也就是，category中的方法会覆盖掉类中原有的方法。
 所以开发中尽量保证不要让分类中的方法和原有类中的方法名相同。避免出现这种情况的解决方案是给分类的方法名统一添加前缀。比如category_。
 如果多个category中存在同名的方法，运行时到底调用哪个方法由编译器决定，最后一个参与编译的方法会被调用。
 
 可以把类的实现分开在几个不同的文件里面。这样做有几个显而易见的好处。
 1.可以减少单个文件的体积
 2.可以把不同的功能组织到不同的category里
 3.可以由多个开发者共同完成一个类
 4.可以按需加载想要的category
 5.声明私有方法
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
/*安装clang命令
 xcode-select --install
 */
@end
