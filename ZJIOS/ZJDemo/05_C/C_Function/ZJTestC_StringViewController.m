//
//  ZJTestC_StringViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/10/17.
//

#import "ZJTestC_StringViewController.h"
#include <string.h>

@interface ZJTestC_StringViewController ()

@end

@implementation ZJTestC_StringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    test0();
}

void test0(void) {
    char *s = "You are beautiful";
    printf("len = %zd\n", strlen(s));   // len = 17
    for (int i = 0; i < strlen(s); i++) {
        printf("%c", s[i]);
    }
}

void test1(void) {
    char src[100] = {0};
    printf("请输入一个字符串:");
    gets(src);
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
