//
//  ZJTestMacroFuncTableViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/10/12.
//

#import "ZJTestMacroFuncTableViewController.h"
#import "ZJFuncDefine.h"

@interface ZJTestMacroFuncTableViewController ()

@end

@implementation ZJTestMacroFuncTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
}

- (void)initAry {
    self.cellTitles = @[@"宏变量名转换符:#", @"宏连接符_1:##", @"宏连接符_2:##", @"宏替换符:__VA_ARGS__", @"宏替换符:##__VA_ARGS__", @"ZJNSLog"];
}

// ‘#’运算符:用来把参数转换成字符串
#define P(A) printf("%s = %d\n", #A, A);

- (void)test0 {
    int a = 10;
    P(a);   // 输出:a = 10
    P(10);  // 输出:10 = 10
}

// '##'运算符:可以用于宏函数的替换部分。这个运算符把两个语言符号组合成单个语言符号，为宏扩展提供了一种连接实际变元的手段
// ## 是宏连接符，作变量链接
#define Func_Area(n) printf("the square of "#n" is %d.\n", area_##n)

- (void)test1 {
    int m = 30;
    int area_m = m*m;
    Func_Area(m);   // 输出: the square of m is 900.
}

/*
 ##：用于将带参数的宏定义中将两个子串(token)联接起来，
 从而形成一个新的子串；但它不可以是第一个或者最后一个子串。所谓的子串(token)就是指编译器能够识别的最小语法单元；
 */
#define LOG(x) log##x()

void logA(void) {
    printf("log func A.\n");
}

void logB(void) {
    printf("log func B.\n");
}

- (void)test2 {
    LOG(A); // 输出:log func A.
    getchar();
}

/*
 __VA_ARGS__:用于在宏替换部分中，表示可变参数列表；类似函数的可变参数中的省略号；
 ##__VA_ARGS__ 宏前面加上##的作用在于，当可变参数的个数为0时，这里的##起到把前面多余的","去掉的作用
 */

#define debug_log_func1(format, ...) printf(format, __VA_ARGS__)
#define debug_log_func2(format, ...) printf(format, ##__VA_ARGS__)
- (void)test3 {
    debug_log_func1("%s:%d\r\n", "debug", 100);
}

- (void)test4 {
    /*
     __VA_ARGS__会替换为与省略号匹配的所有参数，同时会将省略号前面的一个逗号带上，既debug_log_1("debug")，会拓展成printf("debug",)末尾多了个逗号
     debug_log_func1("debug");  // 会报错
     */
    debug_log_func2("debug");   //
}

- (void)test5 {
    NSString *str = @"hello world";
    ZJNSLog(@"str = %@", str);
    
    NSString *s =  [[NSString stringWithUTF8String:__FILE__] lastPathComponent];
    NSLog(@"s = %@", s);
    const char *ch = [s UTF8String];
    printf("ch = %s", ch);
}

// '##': 不可以是第一个或者最后一个子串,所以(_##NAME)加了下划线,去掉下划线会报错
#define RECORD_TIME(NAME) double _##NAME = [NSDate date].timeIntervalSince1970;

#define TTF_STRINGIZE(x) #x
//#define TTF_STRINGIZE2(x) TTF_STRINGIZE(x)
#define TTF_STRINGIZE2(x) #x
#define TTF_SHADER_STRING(text) @TTF_STRINGIZE2(text)

//static NSString *const CAMREA_RESIZE_VERTEX = TTF_SHADER_STRING
//(
//attribute vec4 position;
//attribute vec4 inputTextureCoordinate;
//varying vec2 textureCoordinate;
//void main(){
//    textureCoordinate = inputTextureCoordinate.xy;
//    gl_Position = position;
//}
//);

static NSString *const CAMREA_RESIZE_VERTEX = TTF_SHADER_STRING(abc);
/*
 去掉'@'的宏定义
#define TTF_SHADER_STRING(text) TTF_STRINGIZE2(text)
static NSString *const CAMREA_RESIZE_VERTEX = @TTF_SHADER_STRING(abc);
*/

- (void)test55 {
    RECORD_TIME(began);
    NSLog(@"_began = %f", _began);
    NSString *str = CAMREA_RESIZE_VERTEX;
    NSLog(@"str = %@", str);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SystemTableViewCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SystemTableViewCell];
    }
    cell.textLabel.text = self.cellTitles[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SEL s = NSSelectorFromString([NSString stringWithFormat:@"test%zd", indexPath.row]);
    [self performSelector:s];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
