//
//  ZJTestDictionaryViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/17.
//

#import "ZJTestDictionaryViewController.h"

@interface ZJTestDictionaryViewController ()

@end

@implementation ZJTestDictionaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initAry];
}

- (void)initAry {
    self.vcType = ZJBaseTableViewTypeExecute;
    self.cellTitles = @[@"test0"];
}

/*
 {
     num = "<null>";
 }
 
 */
- (void)test0 {
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:[NSNull null] forKey:@"num"];// 可以为<null>
    //[dic setObject:nil forKey:@"num"];          // object cannot be nil
    NSLog(@"%@", dic);
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
