//
//  ZJTestNSURLViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/5/19.
//

#import "ZJTestNSURLViewController.h"
#import "NSString+ZJTextEncode.h"

@interface ZJTestNSURLViewController ()

@end

@implementation ZJTestNSURLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *url = @"https://app.sycommercial.com/BM/ygapp/jsp/patrolPlan.jsp?isyg=1&f_patroltype=保洁ticket=6e56acc7-f249-4817-8efa-651bbdc1794e&userId=e5122b0dba2f4128bc4465df63dd2739&lan=zh";
    NSURL *endURL = [NSURL URLWithString:[url URLEncodedString]];
    NSLog(@"endURL = %@", endURL);

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
