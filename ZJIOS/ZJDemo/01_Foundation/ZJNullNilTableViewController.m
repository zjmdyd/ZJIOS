//
//  ZJNullNilTableViewController.m
//  ZJIOS
//
//  Created by issuser on 2023/4/11.
//

#import "ZJNullNilTableViewController.h"

@interface ZJNullNilTableViewController ()

@end

@implementation ZJNullNilTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cellTitles = @[@"test0", @"test1", @"test2", @"test3"];
}

/*
 一、nil
 我们给对象赋值时一般会使用object = nil，表示我想把这个对象释放掉；
 或者对象由于某种原因，经过多次release，于是对象引用计数器为0了，系统将这块内存释放掉，这个时候这个对象为nil，我称它为“空对象”。（注意：我这里强调的是“空对象”，下面我会拿它和“值为空的对象”作对比！！！）
 所以对于这种空对象，所有关于retain的操作都会引起程序崩溃，例如字典添加键值或数组添加新原素等
 
 在Objective-C中向nil发送消息是完全有效的——只是在运行时不会有任何作用
 */
- (void)test0 {
    id obj = nil;
    NSLog(@"obj = %@, %@", obj, [obj class]);  // obj = (null), (null)
    
    //    NSMutableArray *ary = @[].mutableCopy;
    //    [ary addObject:obj];  // crash
}

/*
 二、NSNull
 NSNull和nil的区别在于，nil是一个空对象，已经完全从内存中消失了，而如果我们想表达“我们需要有这样一个容器，但这个容器里什么也没有”的观念时，我们就用到NSNull，我称它为“值为空的对象”。如果你查阅开发文档你会发现NSNull这个类是继承NSObject，并且只有一个“+ (NSNull *) null；”类方法。这就说明NSNull对象拥有一个有效的内存地址，所以在程序中对它的任何引用都是不会导致程序崩溃的
 */

- (void)test1 {
    id obj = [NSNull null];
    NSLog(@"obj = %@, %@", obj, [obj class]);  // obj = <null>, NSNull
    
    NSMutableArray *ary = @[].mutableCopy;
    [ary addObject:obj];
    NSLog(@"%@", ary);
}

/*
 三、Nil
 nil和Nil在使用上是没有严格限定的，也就是说凡是使用nil的地方都可以用Nil来代替，反之亦然。
 只不过从编程人员的规约中我们约定俗成地将nil表示一个空对象，Nil表示一个空类。参考代码如下：
 */

- (void)test2 {
    id obj = nil;

    if (obj == nil) {
        NSLog(@"obj == nil");       // obj == nil
    }
    
    if (obj == Nil) {
        NSLog(@"obj == Nil");       // obj == Nil
    }
    
    Class classA = Nil;
    if (classA == Nil) {
        NSLog(@"classA == Nil");    // classA == Nil
    }
    
    if (classA == nil) {
        NSLog(@"classA == nil");    // classA == nil
    }
}

/*
 四、NULL
 我们知道Object-C来源于C、支持于C,当然也有别于C。而NULL就是典型C语言的语法，它表示一个空指针，参考代码如下：
 */
- (void)test3 {
    NSArray *obj = NULL;
    NSLog(@"obj = %@, %@", obj, [obj class]);  // obj = (null), (null)

    if (obj == NULL) {
        NSLog(@"obj == NULL");  // obj == NULL
    }
}

/*
 1、nil：一般赋值给空对象；
 
 2、NULL：一般赋值给nil之外的其他空值。如SEL等；
 　　举个栗子：
 　　　　[NSApp beginSheet:sheet
 　　 modalForWindow:mainWindow
 　　modalDelegate:nil //pointing to an object
 　　didEndSelector:NULL //pointing to a non object/class
 　　contextInfo:NULL]; //pointing to a non object/class
 3、NSNULL：NSNull只有一个方法：+ (NSNull *) null;
 　　[NSNull null]用来在NSArray和NSDictionary中加入非nil（表示列表结束）的空值.   [NSNull null]是一个对象，他用在不能使用nil的场合。
 4、当向nil发送消息时，返回NO，不会有异常，程序将继续执行下去；
 　　而向NSNull的对象发送消息时会收到异常。
 因为在NSArray和NSDictionary中nil中有特殊的含义（表示列表结束），所以不能在集合中放入nil值。如要确实需要存储一个表示“什么都没有”的值，可以使用NSNull类。NSNull只有一个方法：
 + (NSNull *) null;
 
 nil是一个对象指针为空，Nil是一个类指针为空，NULL是基本数据类型为空。这些可以理解为nil，Nil， NULL的区别吧。
 */

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
