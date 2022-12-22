//
//  ZJTestThreadSafeViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/12/19.
//

#import "ZJTestThreadSafeViewController.h"

@interface ZJTestThreadSafeViewController ()

//atomic：原子属性，为setter方法加自旋锁（即为单写多读）

//@property (nonatomic, strong) NSString *target;   // 此处用nonatomic会闪退，nonatomic是非线程安全的。
//@property (atomic, strong) NSString *target;
@property (nonatomic, weak) NSString *target;


@end

@implementation ZJTestThreadSafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self test0];
}

/**
 *  网易面试题
 */
- (void)test0 {
    NSLog(@"c1 = %@", [NSThread currentThread]);    // name = main
    dispatch_queue_t queue = dispatch_queue_create("parallel", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i < 1000 ; i++) {
//        NSLog(@"ci = %@", [NSThread currentThread]);

        dispatch_async(queue, ^{
            NSLog(@"cj = %@", [NSThread currentThread]);

            self.target = [NSString stringWithFormat:@"i->%d", i];
        });
    }
    NSLog(@"c2 = %@", [NSThread currentThread]);    // name = main,
    NSLog(@"self.target = %@", self.target);
    NSLog(@"结束");
}
/**
 噢，看来是对已释放的对象再次发送了release信息。
 
 我又留意到，这个对象是Strong修饰的。  // @property (atomic, strong) NSString *target;
 
 那么他的Setter方法在MRC上就相当于
 
 - (void)setTarget:(NSString *)target {
    [target retain];//先保留新值
    [_target release];//再释放旧值
    _target = target;//再进行赋值
 }
 那么什么时候会导致过多调用release呢，因为这是个并行队列+异步。
 
 那么假如队列A执行到步奏2，还没到步骤3时，队列B也执行到步骤2，那么这个对象就会被过度释放，导致向已释放内存对象发送消息而崩溃。
 
 后来我想怎么可以修改这段代码变为不崩溃的呢？
 
 1.使用串行队列
 
 将set方法改成在串行队列中执行就行，这样即使异步，但所有block操作追加在队列最后依次执行。
 
 2. 使用atomic
 
 atomic关键字相当于在setter方法加锁，这样每次执行setter都是线程安全的，但这只是单独针对setter方法而言的狭义的线程安全。
 
 3.使用weak关键字
 
 weak的setter没有保留新值或者保留旧值的操作，所以不会引发重复释放。当然这个时候要看具体情况能否使用weak，可能值并不是所需要的值。
 
 从而我们可以总结到，线程安全有以下几种方法：
 
 单线程串行访问
 访问加锁
 使用不进行额外操作的关键字（weak）
 使用值类型
 然而这只是保证了基本的线程安全（不崩溃），若是需要保证访问出符合预期的数据，则需要采用GCD的barrier或者自己在合适的时机加锁。
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
