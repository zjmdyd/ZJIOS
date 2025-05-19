//
//  Son.m
//  ZJIOS
//
//  Created by issuser on 2021/11/22.
//

#import "Son.h"
#import "NSObject+ZJMethodSwizzling.h"

@implementation Son
/*
 +load 方法是 Objective-C 运行时中用于类或分类初始化的特殊方法，其核心特性和行为如下：
 一、触发时机与调用规则
 ‌‌加载时机‌
 在类或分类被加载到运行时（非懒加载类）时立即执行，早于 main() 函数调用
 主工程代码优先于动态库加载
 父类的 +load 先于子类执行
 分类的 +load 在类本身之后执行
 ‌‌调用顺序‌
 A[父类load] --> B[子类load]
 B --> C[原类分类load]
 C --> D[其他分类load]
 二、方法特性
 ‌‌无显式调用‌
 由运行时通过 call_load_methods() 自动触发，开发者不可手动调用
 ‌‌执行次数‌
 每个类的 +load 在其生命周期内仅执行一次，即使多次加载也不会重复
 ‌‌线程安全‌
 运行在阻塞式线程环境中，无需额外加锁
 三、典型应用场景
 ‌‌方法交换（Method Swizzling）‌
 在 +load 中安全地进行运行时方法替换47：
 objectivec
 Copy Code
 + (void)load {
     Method original = class_getInstanceMethod(self, @selector(viewDidLoad));
     Method swizzled = class_getInstanceMethod(self, @selector(swizzled_viewDidLoad));
     method_exchangeImplementations(original, swizzled);
 }
 ‌‌全局注册与配置‌
 注册自定义类或初始化全局工具类
 四、注意事项
 ‌‌避免复杂逻辑‌
 此时其他类可能未完成加载，依赖其他类的操作可能导致异常67
 ‌‌与 +initialize 区别‌
 +load 不遵循继承规则，即使子类未实现也会调用父类实现
 +initialize 在类首次使用时触发，且会覆盖父类实现
 ‌‌性能影响‌
 过多的 +load 方法会延长应用启动时间
 */
+ (void)load {
    NSLog(@"%s", __func__);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self exchangeMethod:@selector(eat) swizzledSelector:@selector(eatAnother)];
    });
}

- (void)eatAnother {
    NSLog(@"son eatAnother, self = %@", self.class);
}

+ (void)testLoad {
    NSLog(@"%s", __func__);
}

+ (void)initialize
{
    if (self == [Son class]) {
        NSLog(@"%s", __func__);
    }
}

/*
 1. 执行时机
 +load 方法
 在类或分类被加载到内存时调用。
 执行时机非常早，发生在程序启动时（类和分类被加载到运行时环境时），通常在 main 函数执行前就会调用。
 不管类是否被用到，只要类或分类被加载，+load 方法就会被调用。

 +initialize 方法
 在类或其子类第一次收到消息时调用（即第一次使用类时，例如创建实例、发送类消息等）。
 执行时机较晚，通常在运行时调用，但只在真正需要时触发。

 2. 调用逻辑
 +load 方法
 每个类和分类的 +load 方法都会被调用，且调用顺序为：
 主类的 +load 方法
 主类的分类的 +load 方法
 按照编译顺序依次调用
 无法被继承，子类不会自动调用父类的 +load 方法。

 +initialize 方法
 默认情况下，+initialize 方法只在类第一次被使用时调用。
 如果子类未实现 +initialize 方法，则会继承父类的实现。
 如果类有多个线程同时访问，+initialize 是线程安全的，会确保只被调用一次。

 3. 主要用途
 +load 方法
 通常用于在类或分类加载时执行一些初始化操作，如方法交换（method swizzling）、设置全局状态等。
 适合执行必须在运行时系统加载类之前完成的任务。

 +initialize 方法
 通常用于在类首次被使用时完成某些按需初始化操作，如配置静态变量、初始化共享资源等。
 更适合与具体类使用相关的延迟初始化任务。

 4. 注意事项
 +load 的注意事项
 因为执行时机早，依赖的资源可能尚未完全初始化，使用不当可能导致问题。
 不建议在 +load 方法中执行耗时操作，以免拖慢应用启动时间。

 +initialize 的注意事项
 +initialize 是懒加载的，如果类从未被使用过，方法就不会被调用。
 避免显式调用 +initialize，以免破坏其线程安全性。
 
 规则说明
 +initialize 方法的触发条件：
 当一个类第一次接收到消息时，运行时会自动调用该类的 +initialize 方法。
 如果子类未实现 +initialize 方法，则会继承父类的 +initialize，但只有子类第一次被访问时才会调用。

 调用顺序：
 如果父类和子类都实现了 +initialize，父类的 +initialize 会先于子类的 +initialize 调用。
 这是因为子类的加载可能依赖父类的初始化。
 线程安全性：
 运行时保证 +initialize 是线程安全的，且在一个类或分类中最多调用一次。
 如果在多线程环境中并发访问一个类，运行时会同步执行，确保 +initialize 方法只被调用一次。
 */

@end
