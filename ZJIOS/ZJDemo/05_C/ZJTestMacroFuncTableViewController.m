//
//  ZJTestMacroFuncTableViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/10/12.
//

#import "ZJTestMacroFuncTableViewController.h"

@interface ZJTestMacroFuncTableViewController ()

@end

#define RECORD_TIME(NAME) double _##NAME = [NSDate date].timeIntervalSince1970;

#define TTF_STRINGIZE(x) #x
#define TTF_STRINGIZE2(x) TTF_STRINGIZE(x)
#define TTF_SHADER_STRING(text) @ TTF_STRINGIZE2(text)

static NSString *const CAMREA_RESIZE_VERTEX = TTF_SHADER_STRING
(
attribute vec4 position;
attribute vec4 inputTextureCoordinate;
varying vec2 textureCoordinate;
void main(){
    textureCoordinate = inputTextureCoordinate.xy;
    gl_Position = position;
}
);

@implementation ZJTestMacroFuncTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
    [self initSetting];
}

- (void)initAry {
    self.cellTitles = @[@"宏变量名转换符:#", @"宏连接符:##"];
}

- (void)initSetting {
    
}

// ‘#’运算符:用来把参数转换成字符串
#define P(A) printf("%s = %d\n", #A, A);

- (void)test0 {
    int a = 10;
    P(a);   // 输出:a = 10
    P(10);  // 输出:10 = 10
}

// '##'运算符:可以用于宏函数的替换部分。这个运算符把两个语言符号组合成单个语言符号，为宏扩展提供了一种连接实际变元的手段
#define Func_Area(a) printf("the square of "#a" is %d.\n", area_##a)

- (void)test1 {
    int a = 30;
    int area_a = a*a;
    Func_Area(a);   // 输出: the square of a is 900.
}

/*
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

- (void)test2 {
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
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SEL s = NSSelectorFromString([NSString stringWithFormat:@"test%zd", indexPath.row]);
    [self performSelector:@selector(s)];
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
