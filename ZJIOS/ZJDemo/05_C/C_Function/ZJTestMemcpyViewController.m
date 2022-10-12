//
//  ZJTestMemcpyViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/10/12.
//

#import "ZJTestMemcpyViewController.h"
#include <stdio.h>
#include <string.h>

@interface ZJTestMemcpyViewController ()

@end

struct {
    char name[40];
    int age;
}person, person_copy;

@implementation ZJTestMemcpyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test0];
}

- (void)test0 {
    char myname[] = "Pierre de Fermar";
    // using mencpy to copy string
    My_memcpy(person.name, myname, strlen(myname) + 1);
    person.age = 46;
    printf("person = %p, person.name = %s, person.age = %d\n", &person, person.name, person.age);
    
    // using mencpy to copy structure
    My_memcpy(&person_copy, &person, sizeof(person));
    printf("person_copy = %p, person_copy.name = %s, person_copy.age = %d\n", &person_copy, person_copy.name, person_copy.age);
    
    // 修改person的成员变量值
    char myname2[] = "abcd";
    My_memcpy(person.name, myname2, strlen(myname2) + 1);
    person.age = 88;
    
    printf("person = %p, person.name = %s, person.age = %d\n", &person, person.name, person.age);
    printf("person_copy = %p, person_copy.name = %s, person_copy.age = %d\n", &person_copy, person_copy.name, person_copy.age);
}
/*
 将 num 字节值从源指向的位置直接复制到目标内存块。
 源指针和目标指针所指向的对象的基础类型与此函数无关;结果是数据的二进制副本。
 该函数不检查源中是否有任何终止空字符 - 它始终精确地复制数字字节。
 为避免溢出，目标参数和源参数所指向的数组的大小应至少为 num 个字节，并且不应重叠（对于重叠的内存块，memmove 是一种更安全的方法）。

 函数memcpy从source的位置开始向后复制num个字节的数据到destinatation
 这个函数在遇到 '\0' 的时候并不会停下来。
 如果source和destination有任何的重叠，复制的结果都是未定义的。
 */
void * My_memcpy(void* dest, const void* src, size_t num) {
    assert(dest && src);
    void* ret = dest;
    while (num--) {
        *(char *)dest = *(char *)src;
        dest = dest + 1;
        src = src + 1;
    }
    
    return ret;
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
