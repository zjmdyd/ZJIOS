//
//  ZJPointerAryViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/21.
//

#import "ZJPointerAryViewController.h"

@interface ZJPointerAryViewController ()

@end

@implementation ZJPointerAryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int arr[][2] = {1, 2, 3, 4};
    int *p1 = arr[0];               // 指向元素
    printf("p1 = %d\nn", *p1);
    printf("p1 = %d\n", *(p1+1));
    printf("p1 = %d\n", *(p1+2));
    
    int *p2[2];                     //指针数组
    p2[0] = arr[0];
    p2[1] = arr[1];
    
    int (*p3)[2] = &arr[0];         // 数组指针，也称行指针，指向数组的指针
    printf("%d\n", (*p3)[0]);
    printf("%d\n", (*p3)[1]);
//    printf("%d\n", (*p3)[2]);
    p3++;
    printf("%d\n", (*p3)[0]);
    printf("%d\n", (*p3)[1]);
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
