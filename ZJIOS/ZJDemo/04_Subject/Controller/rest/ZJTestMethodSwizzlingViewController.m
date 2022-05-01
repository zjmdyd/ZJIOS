//
//  ZJTestMethodSwizzlingViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/11/22.
//

#import "ZJTestMethodSwizzlingViewController.h"
#import "NSObject+ZJMethodSwizzling.h"
#import "Son.h"

@interface ZJTestMethodSwizzlingViewController ()

@end

@implementation ZJTestMethodSwizzlingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test1];
}

- (void)test1 {
    Son *son = [Son new];
    [son eat];
//    [son eatAnother];
    
//    Father *father = [Father new];
//    [father eat];
}

- (void)test0 {
    [ZJTestMethodSwizzlingViewController exchangeMethod:@selector(funA) swizzledSelector:@selector(funB)];
    [self funA];
    [self funB];
}

- (void)funA {
    NSLog(@"方法A");
}

- (void)funB {
    NSLog(@"方法B");
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
