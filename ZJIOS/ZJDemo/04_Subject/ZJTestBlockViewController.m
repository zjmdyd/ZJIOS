//
//  ZJTestBlockViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/17.
//

#import "ZJTestBlockViewController.h"
#import "ZJAnimal.h"
#import "Student.h"

typedef void(^Blk_t)(void);
typedef void (^MJBlock) (void);

struct __Block_byref_age_0 {
    void *__isa;
    struct __Block_byref_age_0 *__forwarding;   //age的地址
    int __flags;
    int __size;
    int age;    //
};

struct __main_block_desc_0 {
    size_t reserved;
    size_t Block_size;
    void (*copy)(void);
    void (*dispose)(void);
};

struct __block_impl {
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr;
};

struct __main_block_impl_0 {
    struct __block_impl impl;
    struct __main_block_desc_0* Desc;
    struct __Block_byref_age_0 *age;
};

@interface ZJTestBlockViewController ()

@property (nonatomic, copy) Blk_t blk;
@property (nonatomic, strong) ZJAnimal *animal;
@property (nonatomic, strong) ZJAnimal *animal2;
@property (nonatomic, assign) NSInteger idx;

@end

//Blk_t block;

@implementation ZJTestBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.idx = 100;
    [self initAry];
}

- (void)initAry {
    self.vcType = ZJBaseTableViewTypeExecute;
    
    self.cellTitles = @[@"test0", @"__NSMallocBlock__", @"__weak",  @"全局block", @"block作为函数返回值", @"block内部结构体", @"__NSMallocBlock__", @"retain cycle", @"cycleRetainMethod1", @"cycleRetainMethod2", @"cycleRetainMethod3", @"cycleRetainMethod4"];
    self.values = @[@"test0", @"test1", @"test2", @"test3", @"test4", @"test5", @"test6", @"test7", @"test8", @"test9", @"test10", @"test11"];
}

- (void)test0 {
    //这样是不会产生循环引用，因为这个block不被self持有，是被UIView的类对象持有，这个block和self没有任何关系，所以可以任意使用self。
    [UIView animateWithDuration:1.0 animations:^{
        [self doSomething];
    }];
}

//访问外部变量的block默认是存储在堆中的（实际是放在栈区，然后ARC情况下又自动拷贝到堆区），自动释放。
// 2021-06-22 00:06:50.334827+0800 ZJIOS[7191:648700] <__NSMallocBlock__: 0x600000eb0bd0>
- (void)test1 {
    int a = 10;
    void(^block)(void) = ^{
        NSLog(@"a = %d", a);
    };
    block();
    NSLog(@"%@", block);
    
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 10.0, *)) {
        [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSLog(@"block = %@", block);
            if (!weakSelf) {
                [timer invalidate];
            }
        }];
    } else {
        // Fallback on earlier versions
    }
}

/*
 ARC环境下，访问外部变量的block为什么要自动从栈区拷贝到堆区呢？
 因为：栈上的block，如果其所属的变量作用域结束，该block就会被废弃，如同一般的自动变量。当然，block中的__block变量也同时会被废弃。
 为了解决栈块在其变量作用域结束之后被废弃（释放）的问题，我们需要把block复制到堆中，延长其生命周期。开启ARC时，大多数情况下编译器会恰当的进行判断是否有必要将block从栈复制到堆，如果有，自动生成将block从栈复制到堆的代码。block的复制操作执行的是Copy实例方法。block只要调用了Copy方法，栈块就会变成堆块。
 */
//2021-06-22 00:09:06.606176+0800 ZJIOS[7252:652881] <__NSStackBlock__: 0x7ffeea58eb48>
- (void)test2 {
    int a = 10;
    void(^ __weak __block block)(void) = ^{
        NSLog(@"a = %d", a);    //weak修饰的会被释放掉
    };
    block();
    NSLog(@"%@", block);    // __NSStackBlock__
    
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 10.0, *)) {
        [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
            block = nil; // 置空就会崩溃,但前提是定义的时候添加__block关键字，不然无法在bblock内部修改变量的值
            if (block == nil) {    // 崩溃: Thread 1: EXC_BAD_ACCESS (code=1, address=0x20)
                NSLog(@"block = %@", block);
                [timer invalidate];
            }
            
            if (!weakSelf) {
                [timer invalidate];
            }
        }];
    } else {
        // Fallback on earlier versions
    }
}

- (void)test3 {
    if (YES) {
        block2 = ^{ NSLog(@"临时 Block"); }; // 栈 Block，作用域外可能被释放
    }
    block2(); // 可能调用已释放的 Block
    
    NSLog(@"block2 = %@", block2);    // __NSGlobalBlock__
    
    __weak typeof(self) weakSelf = self;
}
void (^block2)(void);

//函数返回的block如果是配置在栈上的，当block作为函数返回值再进行调用时，block变量作用域就结束了，block已经被释放废弃了
typedef int (^__weak Blk_rt)(int);
/*
 在ARC环境下，当block作为函数返回值时,编译器会自动将栈上的block复制到堆上,所以此时block不会被释放掉
 */
- (void)test4 {
    Blk_rt blk_rt = func(10);   // blk_rt已经被释放，再调用程序会crash
    int value = blk_rt(2);
    NSLog(@"value = %d", value);
    NSLog(@"blk_rt = %@", blk_rt);    // __NSMallocBlock__
    
    // for循环可以正常运行
//    for (int i = 0; i < 10000; i++) {
//        value = blk_rt(i);
//        NSLog(@"value = %d", value);
//        NSLog(@"blk_rt = %@", blk_rt);    // __NSMallocBlock__
//    }
//
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 10.0, *)) {
        [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSLog(@"blk_rtt = %@", blk_rt);  // blk_rtt = (null) ,被释放掉了
            
            if (!blk_rt) {
                // blk_rt(3);  // Thread 1: EXC_BAD_ACCESS (code=1, address=0x10)
                [timer invalidate];
            }
            if (!weakSelf ) {
                [timer invalidate];
            }
        }];
    } else {
        // Fallback on earlier versions
    }
}

Blk_rt func(int rate) {
    return ^(int count){
        return rate * count;
    };
}

/*
 block内部的[__Block_byref_age_0 *]
 */
- (void)test5 {
    __block int age = 10;
    NSLog(@"oc代码里直接通过a访问的内存空间是：%p", &age);  // 0x7ff7b20bd318
    
    MJBlock block = ^{
        age = 20;
        NSLog(@"age is %d", age);   // age is 20
    };
    block();
    // MJBlock执行完之后，age = 20, 0x7b0800021958
    NSLog(@"MJBlock执行完之后，age = %d, %p", age, &age); // age地址已经改变了,取到的是age结构体内的age变量地址
    
    struct __main_block_impl_0 *blockImpl = (__bridge struct __main_block_impl_0 *)block;
    
    NSLog(@"%@", [block class]);    // __NSMallocBlock__
    NSLog(@"blockImpl->age = %p", blockImpl->age); // age结构体, 0x7b0800021940与blockImpl->age-->__forwarding一样
    NSLog(@"blockImpl->age-->age = %p", &(blockImpl->age->age)); // age结构体内的age变量,0x7b0800021958
    NSLog(@"blockImpl->age-->__forwarding = %p", blockImpl->age->__forwarding); // age结构体内的__forwarding结构体0x7b0800021940
    NSLog(@"oc代码里直接通过a访问的内存空间是：%p", &age);   // 0x7b0800021958
}

/*
 struct __Block_byref_age_0 {
     void *__isa;  //8
     struct __Block_byref_age_0 *__forwarding; //8
     int __flags;//4
     int __size;//4
     int age;
 };
 也就是说我们在oc代码里面完成了block的初始化以及 __block变量的捕获之后，只能通过age访问到被封装在 __ Block_byref_age_0 * 内部的这个int age的内存空间。
 我们思考一下苹果为什么这样设计?因为苹果要隐藏它内部的实现,我们在修改__block修饰的age的值时,从表面看会以为真的是在直接修改age的值,如果不了解底层实现的话,根本就不知道被__block修饰的age已经被包装成了一个对象,而我们实际修改的是age结构体中的age成员的值.
 */

- (void)test6 {
    // 栈空间上的block，不会持有对象；堆空间的block，会持有对象
    Student *stu = [[Student alloc] init];
    stu.age = 10;
    Blk_t block = ^{
        NSLog(@"%ld", (long)stu.age);
    };
    NSLog(@"block = %@", block);    // __NSMallocBlock__
    block();
}
/*
 Q：为什么block对auto和static变量捕获有差异？
 auto自动变量可能会销毁的，内存可能会消失，不采用指针访问；static变量一直保存在内存中，指针访问即可
 
 Q：block对全局变量的捕获方式是？
 block不需要对全局变量捕获，都是直接采用取值的
 
 Q：为什么局部变量需要捕获？
 考虑作用域的问题，需要跨函数访问，就需要捕获
 Q：如何判断block是哪种类型？
 没有访问auto变量的block是__NSGlobalBlock __ ，放在数据段
 访问了auto变量的block是__NSStackBlock __
 [__NSStackBlock __ copy]操作就变成了__NSMallocBlock __
 
 Q：当block内部访问了对象类型的auto变量时，是否会强引用？
 答案：分情况讨论，分为栈block和堆block
 
 栈block
 a) 如果block是在栈上，将不会对auto变量产生强引用
 b) 栈上的block随时会被销毁，也没必要去强引用其他对象
 
 堆block
 1.如果block被拷贝到堆上：
 a) 会调用block内部的copy函数
 b) copy函数内部会调用_Block_object_assign函数
 c) _Block_object_assign函数会根据auto变量的修饰符（__strong、__weak、__unsafe_unretained）做出相应的操作，形成强引用（retain）或者弱引用
 
 2.如果block从堆上移除
 a) 会调用block内部的dispose函数
 b) dispose函数内部会调用_Block_object_dispose函数
 c) _Block_object_dispose函数会自动释放引用的auto变量（release）
 
 正确答案：
 如果block在栈空间，不管外部变量是强引用还是弱引用，block都会弱引用访问对象
 如果block在堆空间，如果外部强引用，block内部也是强引用；如果外部弱引用，block内部也是弱引用
 Q：在ARC环境下，编译器会根据情况自动将栈上的block复制到堆上的几种情况？
 1.block作为函数返回值时
 2.将block赋值给__strong指针时
 3.block作为Cocoa API中方法名含有usingBlock的方法参数时
 4.block作为GCD API的方法参数时
 
 Q：__block int age = 10，系统做了哪些？
 答案：编译器会将__block变量包装成一个对象
 struct __Block_byref_age_0 {
 void *__isa;
 __Block_byref_age_0 *__forwarding;//age的地址
 int __flags;
 int __size;
 int age;//age 的值
 };
 Q：__block 修饰符作用？
 __block可以用于解决block内部无法修改auto变量值的问题
 __block不能修饰全局变量、静态变量（static）
 编译器会将__block变量包装成一个对象
 __block修改变量：age->__forwarding->age
 __Block_byref_age_0结构体内部地址和外部变量age是同一地址
 */

/*
 captureValue
 */
- (void)test7 {
    auto int age = 10;
    static int num = 25;
    void (^Block)(void) = ^{
        NSLog(@"age:%d, num:%d", age, num);
        self.idx = 200; // 可以修改
        //age = 20;     // 不可以修改 Variable is not assignable (missing __block type specifier)
    };
    age = 20;
    num = 11;
    Block();
    // 输出结果为：age:10,num:11
    // 原因：auto变量block访问方式是值传递，static变量block访问方式是指针传递
}

/*
 cycleRetainMethod1
 
 self不会释放, 不执行dealloc
 */
- (void)test8 {
    self.blk = ^{
        [self doSomething];   // 循环引用
    };
    self.blk();
}

/*
 cycleRetainMethod2
 self会释放, 执行dealloc
 */
- (void)test9 {
    Blk_t block = ^ void(void){
        [self doSomething];
    };
    block();
}

/*
 cycleRetainMethod3
 */
- (void)test10 {
    //第一种写法
    __weak typeof(self) weakSelf = self;    // 不用weak修饰会造成循环引用，导致内存泄漏
    _animal = [[ZJAnimal alloc] initWithBlock:^(NSString *str) {
        NSLog(@"blk回调了 = %@", str);
        [weakSelf doSomething];
    }];
    [_animal execute];
}

/*
 cycleRetainMethod4
 */
- (void)test11 {
    //第二种写法
    _animal2 = [[ZJAnimal alloc] init];
    __weak typeof(self) weakSelf = self;    // 不用weak修饰会造成循环引用，导致内存泄漏
    [_animal2 Block:^(NSString *str) {
        NSLog(@"blk回调了 = %@", str);
        [weakSelf doSomething];
    }];
    [_animal2 execute];
}

/*
 第二种写法，UIViewController持有_animal2，_animal2持有block所以形成一个闭环；而第一种写法由于Person.m的- (instancetype)initWithBlock:(Block)block的方法实现，在返回self之前对变量_blk赋值了。即_blk变量已经赋值，但是此时_animal变量还没有产生，所以导致_animal变量没有持有block,
 此上为错误描述
 */
- (void)doSomething {
    NSLog(@"%s", __func__);
}

/*
struct Block_descriptor {
    unsigned long int reserved;
    unsigned long int size;
    void (*copy)(void *dst, void *src);
    void (*dispose)(void *);
};

struct Block_layout {
    void *isa;
    int flags;
    int reserved;
    void (*invoke)(void *, ...);
    struct Block_descriptor *descriptor;
    //   Imported variables.
};

通过该图，我们可以知道，一个 block 实例实际上由 6 部分构成：
isa 指针，所有对象都有该指针，用于实现对象相关的功能。
flags，用于按 bit 位表示一些 block 的附加信息，本文后面介绍 block copy 的实现代码可以看到对该变量的使用。
reserved，保留变量。
invoke，函数指针，指向具体的 block 实现的函数调用地址。
descriptor， 表示该 block 的附加描述信息，主要是 size 大小，以及 copy 和 dispose 函数的指针。
variables，capture 过来的变量，block 能够访问它外部的局部变量，就是因为将这些变量（或变量的地址）复制到了结构体中。

在 Objective-C 语言中，一共有 3 种类型的 block：
_NSConcreteGlobalBlock 全局的静态 block，不会访问任何外部变量。
_NSConcreteStackBlock 保存在栈中的 block，当函数返回时会被销毁。
_NSConcreteMallocBlock 保存在堆中的 block，当引用计数为 0 时会被销毁。
struct __block_impl {
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr;
};

struct __main_block_impl_0 {
    struct __block_impl impl;
    struct __main_block_desc_0* Desc;
    // 构造函数（类似于OC的init方法），返回结构体对象
    __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {
        impl.isa = &_NSConcreteStackBlock;
        impl.Flags = flags;
        impl.FuncPtr = fp;
        Desc = desc;
    }
};
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
    printf("Hello, World!\n");
}

static struct __main_block_desc_0 {
    size_t reserved;
    size_t Block_size;
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0) };

int main()
{
    (void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA) ();
    return 0;
}
下面我们就具体看一下是如何实现的。__main_block_impl_0 就是该 block 的实现，从中我们可以看出：
一个 block 实际是一个对象，它主要由一个 isa 和 一个 impl 和 一个 descriptor 组成。
在本例中，isa 指向 _NSConcreteGlobalBlock， 主要是为了实现对象的所有特性，在此我们就不展开讨论了。
由于 clang 改写的具体实现方式和 LLVM 不太一样，并且这里没有开启 ARC。所以这里我们看到 isa 指向的还是_NSConcreteStackBlock。但在 LLVM 的实现中，开启 ARC 时，block 应该是 _NSConcreteGlobalBlock 类型，具体可以看 《objective-c-blocks-quiz》 第二题的解释。
impl 是实际的函数指针，本例中，它指向 __main_block_func_0。这里的 impl 相当于之前提到的 invoke 变量，只是 clang 编译器对变量的命名不一样而已。
descriptor 是用于描述当前这个 block 的附加信息的，包括结构体的大小，需要 capture 和 dispose 的变量列表等。结构体大小需要保存是因为，每个 block 因为会 capture 一些变量，这些变量会加到 __main_block_impl_0 这个结构体中，使其体积变大。在该例子中我们还看不到相关 capture 的代码，后面将会看到。

#include <stdio.h>

int main() {
    int a = 100;
    void (^block2)(void) = ^{
        printf("%d\n", a);
    };
    block2();
    
    return 0;
}
// 转换后关键代码如下:
struct __main_block_impl_0 {
    struct __block_impl impl;
    struct __main_block_desc_0* Desc;
    int a;
    __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int _a, int flags=0) : a(_a) {
        impl.isa = &_NSConcreteStackBlock;
        impl.Flags = flags;
        impl.FuncPtr = fp;
        Desc = desc;
    }
};
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
    int a = __cself->a; // bound by copy
    printf("%d\n", a);
}

static struct __main_block_desc_0 {
    size_t reserved;
    size_t Block_size;
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};

int main()
{
    int a = 100;
    void (*block2)(void) = (void (*)()) & __main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, a);
    ( (void (*)(__block_impl *)) ((__block_impl *)block2) ->FuncPtr) ((__block_impl *)block2);
    
    return 0;
}

在本例中，我们可以看到：
本例中，isa 指向 _NSConcreteStackBlock，说明这是一个分配在栈上的实例。
__main_block_impl_0 中增加了一个变量 a，在 block 中引用的变量 a 实际是在申明 block 时，被复制到 __main_block_impl_0 结构体中的那个变量 a。因为这样，我们就能理解，在 block 内部修改变量 a 的内容，不会影响外部的实际变量 a。
__main_block_impl_0 中由于增加了一个变量 a，所以结构体的大小变大了，该结构体大小被写在了 __main_block_desc_0 中。
*/

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
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
