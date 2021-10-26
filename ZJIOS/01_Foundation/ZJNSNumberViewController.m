//
//  ZJNSNumberViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/9/29.
//

#import "ZJNSNumberViewController.h"
#import "NSNumber+ZJNumber.h"

@interface ZJNSNumberViewController ()

@end

@implementation ZJNSNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSNumber *num = @10;
    BOOL valid = [num validValueWithRange:NSMakeRange(6, 5)];
    NSLog(@"num = %d", valid);
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
