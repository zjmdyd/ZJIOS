//
//  ZJTestSizeViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/7/2.
//

#import "ZJTestSizeViewController.h"

@interface ZJTestSizeViewController ()

@end

@implementation ZJTestSizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
}

- (void)initAry {
    self.vcType = ZJBaseTableViewTypeExecute;
    self.cellTitles = @[@"sizeof_1", @"sizeof_2", @"sizeof&strlen"];
    self.values = @[@"test0", @"test1", @"test2"];
}

/*
 ‌仅适用于同作用域的静态数组‌
 若数组作为参数传递给函数，会退化为指针，此时 sizeof 计算的是指针大小而非数组大小：
 
 例如 int* arr = malloc(5 * sizeof(int));，此时 sizeof(arr) 仍返回指针大小
 
 四、正确使用场景
 ‌‌编译时确定长度的数组‌
 如全局数组或函数内局部数组的定义域内15。
 ‌‌避免传递数组到函数的场景‌
 若需跨函数使用数组长度，需额外传递长度参数
 
 */
- (void)test0 {
    NSInteger values[] =  {0, 4, 8, 13, 18, 22, 26};
    NSInteger count = sizeof(values) / sizeof(NSInteger);
    NSLog(@"count = %zd", count);   // count = 7
}

- (void)test1 {
    NSInteger targetIndexs[] =  {0, 3, 4};
    [self getTargetValuesWithIndexs:targetIndexs count:3];
}

- (void)getTargetValuesWithIndexs:(NSInteger *)indexs count:(NSInteger)len {
    NSInteger t_count = sizeof(*indexs) / sizeof(NSInteger);
    // 不能得到形参所指向数组的全部大小
    NSLog(@"t_count = %zd", t_count);   // t_count = 1

    NSInteger values[] =  {0, 4, 8, 13, 18, 22, 26, 32};
/*
 2025-05-13 10:39:56.978796+0800 ZJIOS[23237:4421192] t_count = 1
 2025-05-13 10:39:56.979057+0800 ZJIOS[23237:4421192] value = 0, idx = 0
 2025-05-13 10:39:56.979221+0800 ZJIOS[23237:4421192] value = 13, idx = 3
 2025-05-13 10:39:56.979437+0800 ZJIOS[23237:4421192] value = 18, idx = 4
 */
    
//    不能获取数组大小，但能正确获取到数组元素
    for (NSInteger i = 0; i < len; i++) {
        NSInteger idx = indexs[i];
        NSLog(@"value = %zd, idx = %zd", values[idx],idx );   //
    }
}

#define P(A) printf("%s = %zd\n", #A, A);

/*
 ‌字符数组的特殊情况‌
 若数组中存在 '\0' 终止符（如字符串），需结合 strlen 获取逻辑长度：
 */
- (void)test2 {
    char str[] = "Hello";
    size_t byte_size = sizeof(str);    // 6 字节（包含 '\0'）
    size_t char_count = strlen(str);   // 5 字符（不包含 '\0'）:ml-citation{ref="2" data="citationList"}
    P(byte_size);
    P(char_count);
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
