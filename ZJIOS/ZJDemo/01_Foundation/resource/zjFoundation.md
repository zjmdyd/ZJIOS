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


