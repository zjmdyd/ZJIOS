//
//  ZJCategoryViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/19.
//

#import "ZJCategoryViewController.h"
#import "Person.h"
#import "ZJFruit.h"

@interface ZJCategoryViewController ()

@end

@implementation ZJCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self initAry];
}

- (void)initAry {
    self.vcType = ZJBaseTableViewTypeExecute;
    self.cellTitles = @[@"testAddPerporty", @"testAddMethod", @"testExtensionPerporty"];
    self.values = @[@"test0", @"test1", @"test2", @"test3", @"test4", @"test5"];
}

/*
 动态添加属性testAddPerporty
 */
- (void)test0 {
    Person *p = [Person new];
    p.personName = @"meimei";
    NSLog(@"p.name = %@", p.personName);
}

/*
 动态添加方法testAddMethod
 */
- (void)test1 {
    Person *p = [Person new];
    [p performSelector:@selector(ggg:) withObject:@20];
}

- (void)test2 {
    ZJFruit *ft = [ZJFruit new];
    ft.name = @"苹果";
    NSLog(@"name = %@", ft.name);
    
    // [ft testExtention]; // 分类方法不实现会闪退
}

/*
 Extension（扩展）中声明的方法只能在该类的@ implementation中实现，这也就意味着，你无法对系统的类（例如NSArray类）使用Extension（扩展）
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
 2.category中也可以添加属性，只不过@ property只会生成setter和getter的声明，不会生成setter和getter的实现以及成员变量。这个是从设计上考虑保持类别特性的单纯
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
 Objective-C分类的运行时特性解析
 ‌‌一、分类的本质‌
 ‌‌运行时动态合并‌

 分类（Category）在编译后生成_category_t结构体，包含方法列表、协议、属性等信息，‌在运行时‌通过runtime将这些内容合并到主类中612
 合并顺序：分类方法会插入主类方法列表的‌前部‌，因此后编译的分类方法优先级更高612
 ‌‌方法覆盖机制‌

 若分类重写主类方法，只要分类被加载到项目（即使未显式导入头文件），主类方法即被替换6
 此行为完全由运行时动态决定，与编译期无关
 
 ‌二、运行时关键行为‌
 特性    实现机制    动态性体现
 ‌‌方法扩展‌    运行时通过attachCategories函数将分类方法附加到主类的class_rw_t结构12    主类方法列表运行时可变
 ‌‌协议/属性扩展‌    分类中声明的协议和属性会在运行时合并到主类元数据中612    类结构动态扩展
 ‌‌继承链影响‌    分类方法会被子类继承，且子类调用时仍遵循消息转发机制
 
 三、与编译时对比‌
 ‌‌编译时限制‌

 分类‌无法添加实例变量‌（编译期检查报错）6
 方法声明仅依赖主类头文件可见性（无法直接访问主类私有成员）
 ‌‌运行时突破‌

 通过关联对象（objc_setAssociatedObject）间接实现“伪属性”存储
 利用method_exchangeImplementations动态交换方法实现（Method Swizzling）
 
 总结
 Objective-C分类的‌所有核心功能‌（方法合并、方法覆盖、协议扩展等）均依赖运行时机制实现，是OC动态特性的典型体现612。其设计本质是‌对类结构的运行时修改‌，而非编译期静态扩展
 
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
