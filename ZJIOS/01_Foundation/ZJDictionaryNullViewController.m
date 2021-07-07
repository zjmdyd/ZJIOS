//
//  ZJDictionaryNullViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/17.
//

#import "ZJDictionaryNullViewController.h"

@interface ZJDictionaryNullViewController ()

@end

@implementation ZJDictionaryNullViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:[NSNull null] forKey:@"num"];
    NSLog(@"dic");
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
