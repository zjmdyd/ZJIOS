// 定义block
typedef void (^YZBlock)(void);
 int age = 10;

int main(int argc, const char * argv[]) {
 @autoreleasepool {

 YZBlock block = ^{
 age = 20;
 NSLog(@"block内部修改之后age = %d", age);
 };

 block();
 NSLog(@"block调用完 age = %d", age);
 }
 return 0;
}

//这个很简单，输出结果为
//
//block内部修改之后age = 20
//block调用完 age = 20
//对于输出就结果也没什么问题，因为全局变量，是所有地方都可访问的，在block内部可以直接操作age的内存地址的。调用完block之后，全局变量age指向的地址的值已经被更改为20，所以是上面的打印结果
//
//static修改局部变量
// 定义block
typedef void (^YZBlock)(void);

int main(int argc, const char * argv[]) {
 @autoreleasepool {
 static int age = 10;
 YZBlock block = ^{
 age = 20;
 NSLog(@"block内部修改之后age = %d", age);
 };

 block();
 NSLog(@"block调用完 age = %d", age);
 }
 return 0;
}
上面的代码输出结果为

block内部修改之后age = 20
block调用完 age = 20
// 看源码
struct __main_block_impl_0 {
 struct __block_impl impl;
 struct __main_block_desc_0* Desc;
 int *age;
 __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int *_age, int flags=0) : age(_age) {
 impl.isa = &_NSConcreteStackBlock;
 impl.Flags = flags;
 impl.FuncPtr = fp;
 Desc = desc;
 }
};

static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
 int *age = __cself->age; // bound by copy

 (*age) = 20;
 NSLog((NSString *)&__NSConstantStringImpl__var_folders_x4_920c4yq936b63mvtj4wmb32m0000gn_T_main_5dbaa1_mi_0, (*age));
}

//可以看出，当局部变量用static修饰之后，这个block内部会有个成员是int *age，也就是说把age的地址捕获了。这样的话，当然在block内部可以修改局部变量age了。
//
//以上两种方法，虽然可以达到在block内部修改局部变量的目的，但是，这样做，会导致内存无法释放。无论是全局变量，还是用static修饰，都无法及时销毁，会一直存在内存中。很多时候，我们只是需要临时用一下，当不用的时候，能销毁掉，就是第三种__block
//
//__block来修饰
//代码如下

// 定义block
typedef void (^YZBlock)(void);

int main(int argc, const char * argv[]) {
 @autoreleasepool {
 __block int age = 10;
 YZBlock block = ^{
 age = 20;
 NSLog(@"block内部修改之后age = %d",age);
 };

 block();
 NSLog(@"block调用完 age = %d",age);
 }
 return 0;
}
输出结果和上面两种一样
block内部修改之后age = 20
block调用完 age = 20

__block分析:clang
// 首先能发现 多了__Block_byref_age_0结构体
struct __main_block_impl_0 {
 struct __block_impl impl;
 struct __main_block_desc_0* Desc;
 // 这里多了__Block_byref_age_0类型的结构体
 __Block_byref_age_0 *age; // by ref
 // fp是函数地址  desc是描述信息  __Block_byref_age_0 类型的结构体  *_age  flags标记
 __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, __Block_byref_age_0 *_age, int flags=0) : age(_age->__forwarding) {
 impl.isa = &_NSConcreteStackBlock;
 impl.Flags = flags;
 impl.FuncPtr = fp; //fp是函数地址
 Desc = desc;
 }
};
// 再仔细看结构体__Block_byref_age_0，可以发现第一个成员变量是isa指针，第二个是指向自身的指针__forwarding
// 结构体 __Block_byref_age_0
struct __Block_byref_age_0 {
 void *__isa; //isa指针 说明是一个ocobject对象
 __Block_byref_age_0 *__forwarding; // 指向自身的指针
 int __flags;
 int __size;
 int age; //使用值
};

// 这是原始的代码 __Block_byref_age_0
__attribute__((__blocks__(byref))) __Block_byref_age_0 age = {(void*)0,(__Block_byref_age_0 *)&age, 0, sizeof(__Block_byref_age_0), 10};

//这是简化之后的代码 __Block_byref_age_0
__Block_byref_age_0 age = {
 0, //赋值给 __isa
 (__Block_byref_age_0 *)&age,//赋值给 __forwarding,也就是自身的指针
 0, // 赋值给__flags
 sizeof(__Block_byref_age_0),//赋值给 __size
 10 // age 使用值
 };

// 这是原始的 block代码
YZBlock block = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, (__Block_byref_age_0 *)&age, 570425344));

// 这是简化之后的 block代码
YZBlock block = (&__main_block_impl_0(
 __main_block_func_0,
 &__main_block_desc_0_DATA,
 &age,
 570425344));

 ((void (*)(__block_impl *))((__block_impl *)block)->FuncPtr)((__block_impl *)block);
 //简化为
block->FuncPtr(block);
//
//为什么苹果要设计forwarding这种多此一举的方式呢?
//
//因为当block从栈上拷贝到堆上后,__block变量也会拷贝到堆上.这时就有两份__block变量,一份栈上的,一份堆上的.如果__block修饰的变量是存放在栈上,这是forwarding指向的是它自己,这样没有问题.但是如果__block修饰的变量复制到堆上,它就会把栈上的forwarding指向堆上的变量,这样就能保证即使访问栈上的__block变量也能获取到堆上的变量值,
