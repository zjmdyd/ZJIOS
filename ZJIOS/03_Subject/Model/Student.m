//
//  Student.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/20.
//

#import "Student.h"

@implementation Student

/*
 2021-06-20 18:40:31.083870+0800 ZJIOS[2417:115176] Student
 2021-06-20 18:40:31.084057+0800 ZJIOS[2417:115176] Student
 */
- (void)testSuperClass {
    NSLog(@"%@",NSStringFromClass([self class]));
    NSLog(@"%@",NSStringFromClass([super class]));
}

/*
 我们发现[super class]是通过objc_msgSendSuper2进行发送消息的，而不是通过objc_msgSend发送消息的，我们再到objc源码中去找一下objc_msgSendSuper2的实现
 我们最终在汇编地方找到了实现，并且发现_objc_msgSendSuper2的参数分别为objc_super、SEL等等，其中objc_super是消息接受者，并且它是一个结构体：
 * struct objc_super {
  *     id receiver;
  *     Class cls;   // SUBCLASS of the class to search
  * }
 我们知道receiver是self，cls是self的父类，_objc_msgSendSuper2其实就从self的父类开始查找方法，但是消息接受者还是self本身，也就类似是让self去调父类的class方法，所以返回的都是Student
 */

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end
