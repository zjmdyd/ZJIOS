//
//  ZJTestFloatViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/7/14.
//

#import "ZJTestFloatViewController.h"
#import <objc/runtime.h>

@interface ZJTestFloatViewController ()

@end

@implementation ZJTestFloatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
}

- (void)initAry {
    self.vcType = ZJBaseTableViewTypeExecute;
    self.cellTitles = @[@"test0", @"test1", @"test2"];
}

/*
 数值上float的0不大于int的0，两者相等；但类型和存储机制不同可能导致比较行为的差异。
 */
- (void)test0 {
    float a = 0;
    if (a > 0) {
        NSLog(@"a大于0");
    }else if(a == 0) {      // a等于0
        NSLog(@"a等于0");
    }else {
        NSLog(@"a小于0");
    }
    
    //    FLT_EPSILON 浮点数所能识别的最小精度
    if (a > FLT_EPSILON) {
        NSLog(@"a大于 FLT_EPSILON");
    }else if(a == FLT_EPSILON){
        NSLog(@"a等于 FLT_EPSILON");
    }else {
        NSLog(@"a小于 FLT_EPSILON");  // a小于 FLT_EPSILON
    }
    NSLog(@"a = %f", a);
    NSLog(@"a = %lf", a);
    NSLog(@"FLT_EPSILON = %f", FLT_EPSILON);
    NSLog(@"FLT_EPSILON = %lf", DBL_EPSILON);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, self.view.frame.size.height)];
    label.numberOfLines = 0;
    label.text = @"数值上float的0不大于int的0，两者相等；但类型和存储机制不同可能导致比较行为的差异。";
    [self.view addSubview:label];
}

/*
 %e/%E: 输出类型为科学计数法表示的数，此处 "e" 的大小写代表在输出时用的 “e” 的大小写，默认浮点数精度为6
 
 1.002300e+02
 1.002300E+02
 1.004500e+02
 1.004500E+02
 1.230000e-03
 1.230000E-03
 */
- (void)test1 {
    float a = 100.23;
    printf("%e\n", a);
    printf("%E\n", a);
    
    double b = 100.45;
    printf("%le\n", b);
    printf("%lE\n", b);
    
    float c = 0.00123;
    printf("%e\n", c);
    printf("%E\n", c);
}

/*
 %m.n: m表示数据总宽度，n表示保留n位小数
 m为正数右对齐，负数为左对齐
 */
- (void)test2 {
    double a = 123.456, b = 21.34;
    printf("%.2f\n", a);
    printf("%.3f\n", b);
    printf("%4.2f\n", b);
    printf("%07.2f\n", b);
    printf("%020.15lf\n", 1/3.0); // 0000.333 3333 3333 3333
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
