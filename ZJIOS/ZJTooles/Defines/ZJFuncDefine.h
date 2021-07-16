//
//  ZJFuncDefine.h
//  ZJIOS
//
//  Created by issuser on 2021/7/14.
//

#ifndef ZJFuncDefine_h
#define ZJFuncDefine_h

#define kRGBA(r, g, b, a)       [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]
#define UIColorFromHex(s)  [UIColor colorWithRed:(((s&0xFF0000) >> 16))/255.0 green:(((s&0x00FF00) >> 8))/255.0 blue:(s&0x0000FF)/255.0 alpha:1.0]
#define UIColorFromHexA(s, a)  [UIColor colorWithRed:(((s&0xFF0000) >> 16))/255.0 green:(((s&0x00FF00) >> 8))/255.0 blue:(s&0x0000FF)/255.0 alpha:a]

#ifdef DEBUG //调试

#define ZJNSLog(FORMAT, ...) fprintf(stderr, "%s:%zd\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);

#else // 发布

#define ZJNSLog(FORMAT, ...) nil

// #用来把参数转换成字符串
#define P(A) printf("%s:%d\n",#A,A);

//##运算符可以用于宏函数的替换部分。这个运算符把两个语言符号组合成单个语言符号，为宏扩展提供了一种连接实际变元的手段
/*
 #define Func3(a) printf("the square of " #a " is %d.\n",b##a)
 int main(void)
 {
     int m=30;
     int bm=900;
     Func3(m);         //展开后相当于 printf("the square of m is %d.\n",bm);
     system("pause");
     return 0;
 }
  输出：

 the square of m is 900.
 分析》：## 是宏连接符，作变量链接，Func(a)里面有b##a，也就是说直接连接成b‘a’，Func3(m)对应bm，由于bm在main里面有定义，所以可以打印出来。
 ##__VA_ARGS__这里的‘##’有特殊作用，
   __VA_ARGS__是可变参数宏，用法如下：

  #define Debug(...) printf(__VA_ARGS__)
   使用的时候只需要：
  Debug("Y = %d\n", y);

 此时编译器会自动替换成printf("Y = %d\n", y");
 对于##__VA_ARGS__的‘##’符号的用法，
 例如：#define debug(format, ...) fprintf (stderr, format, ## __VA_ARGS__)
 假如可变参数宏为空的时候，”“##”的作用就是让编译器忽略前面一个逗号，不然编译器会报错。
 */
#endif /* ZJFuncDefine_h */
