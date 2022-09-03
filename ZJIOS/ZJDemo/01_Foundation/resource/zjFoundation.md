# zjFoundation

小知识点总结

## Overview

<!--@START_MENU_TOKEN@-->Text<!--@END_MENU_TOKEN@-->

## Topics

### 属性修饰符

- 1.assign
在MRC和ARC下都可以使用。
一般用来修饰OC基础数据类型（NSInteger，CGFloat等）和C的数据类型（int，float等）。
assign修饰的对象，在引用计数为0时不会将对象置为nil。
- 2.weak
weak 只可以修饰对象类型，表示对对象的弱引用，不会使传入对象的引用计数加1。引用计数器为0时对象会被置为nil。
之后再向该对象发消息也不会崩溃。 weak是安全的。引用类型会被放入堆中，需要我们自己手动管理内存或通过ARC管理。

**assign和weak的区别：当它们指向的对象释放后，assign指向的对象不会被置为nil。如果assign修饰对象类型则会造成野指针问题。
 基本数据类型会被分配到栈空间，而栈空间是由系统自动管理分配和释放的，用assign修饰就不会造成野指针的问题。**
 
 ## 属性和成员变量
 ### setter和getter方法
 @property声明一个属性，系统会自动生成一个名字为_属性的成员变量，即生成_name。并且系统会自动生该成员变量的setter和getter方法
 也即@property声明一个属性 = 声明一个成员变量 + 自动生成成员变量的存取方法（setter+getter）
 属性不是变量，对象类型的属性其实是声明了一个指针，这个指针的地址指向的是变量_name。@property声明的基础的属性是一个变量。
 我们在访问属性name的时候，实际上是访问的_name，只不过是通过指针name访问的
 如果同时重写了getter和setter方法，那么系统就不会帮你自动生成这个成员变量，所以系统会报错说不认识这个成员变量
 @synthesize 声明的属性=变量。意思是，将属性的setter,getter方法，作用于这个变量
 _name是系统生成的一个成员变量，成员变量在外部是不能直接被访问的，需要用getter和setter方法来访问，子类重写getter方法也不行，需要使用 @synthesize绑定成员变量到属性




