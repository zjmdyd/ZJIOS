//
//  ZJTestAryViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/11/22.
//

#import "ZJTestAryViewController.h"
#import "NSArray+ZJArray.h"

@interface ZJTestAryViewController ()

@end

@implementation ZJTestAryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test0];
}
/*
 2022-05-14 22:44:41.740172+0800 ZJIOS[6928:229514] (
     00,
     01,
     02,
     03,
     04,
     05,
     06,
     07,
     08,
     09,
     10,
     11
 )
 */
- (void)test0 {
    NSLog(@"%@", [NSArray timeStringWithType:TimeStringType12Hour]);
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
