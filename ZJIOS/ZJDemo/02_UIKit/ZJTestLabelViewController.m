//
//  ZJTestLabelViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/2/14.
//

#import "ZJTestLabelViewController.h"
#import "UILabel+ZJLabel.h"
#import "UIViewExt.h"

@interface ZJTestLabelViewController ()

@end

@implementation ZJTestLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test2];
}

#pragma mark 高度自适应

// 给定宽度
- (void)test0 {
    UILabel *labelOne = [[UILabel alloc] initWithFrame:CGRectMake(10, 64, 250, 0)];
    labelOne.text = @"In a storyboard-based application, you will often want to do a little preparation before navigation.In a storyboard-based application";
    labelOne.backgroundColor = [UIColor grayColor];
    labelOne.font = [UIFont systemFontOfSize:20];
    labelOne.numberOfLines = 0;
    CGSize size = [UILabel fitSizeWithWidth:250 text:labelOne.text font:labelOne.font];
    NSLog(@"%@", NSStringFromCGSize(size)); // {235, 143.5}
    CGRect frame = labelOne.frame;
    frame.size = size;
    labelOne.frame = frame;
    
    [self.view addSubview:labelOne];
}

// 给定宽度
- (void)test1 {
    UILabel *labelOne = [[UILabel alloc] initWithFrame:CGRectMake(10, 64, 250, 0)];
    labelOne.text = @"In a storyboard-based application, you will often want to do a little preparation before navigation.In a storyboard-based application";
    labelOne.backgroundColor = [UIColor grayColor];
    labelOne.numberOfLines = 0;
    labelOne.font = [UIFont systemFontOfSize:20];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:labelOne.text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20],
                                                                                                    NSForegroundColorAttributeName : [UIColor redColor]
                                                                                                  }];
    labelOne.attributedText = str;
    CGSize size = [UILabel fitSizeWithWidth:250 text:str];
    NSLog(@"%@", NSStringFromCGSize(size));     // {235, 143.5}
    CGRect frame = labelOne.frame;
    frame.size = size;
    labelOne.frame = frame;
    
    [self.view addSubview:labelOne];
}

#pragma mark 宽度自适应

// 匹配文字最大宽度，高度设置不起作用
- (void)test2 {
    UILabel *labelOne = [[UILabel alloc] initWithFrame:CGRectMake(10, 64, 0, 0)];
    labelOne.text = @"In a storyboard-based application, you will often want to do a little preparation before navigation.In a storyboard-based application";
    labelOne.backgroundColor = [UIColor grayColor];
    labelOne.font = [UIFont systemFontOfSize:20];
    labelOne.numberOfLines = 0;
    CGSize size = [UILabel fitSizeWithText:labelOne.text font:labelOne.font];
    NSLog(@"%@", NSStringFromCGSize(size)); // {1132.5, 24}
    CGRect frame = labelOne.frame;
    frame.size = size;
    labelOne.frame = frame;
    [self.view addSubview:labelOne];
}

- (void)test3 {
    UILabel *labelOne = [[UILabel alloc] initWithFrame:CGRectMake(10, 64, 0, 0)];
    labelOne.text = @"In a storyboard-based application, you will often want to do a little preparation before navigation.In a storyboard-based application";
    labelOne.backgroundColor = [UIColor grayColor];
    labelOne.numberOfLines = 0;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:labelOne.text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20],
                                                                                                    NSForegroundColorAttributeName : [UIColor redColor]
                                                                                                  }];
    CGSize size = [UILabel fitSizeWithText:str];
    NSLog(@"%@", NSStringFromCGSize(size)); // {1132.5, 24}
    CGRect frame = labelOne.frame;
    frame.size = size;
    labelOne.frame = frame;
    
    [self.view addSubview:labelOne];
}

// 根据设置的宽高匹配最适合的size, 优先匹配宽度
- (void)test4 {
    UILabel *labelOne = [[UILabel alloc] initWithFrame:CGRectMake(10, 64, 250, 250)];
    labelOne.text = @"In a storyboard-based application, you will often want to do a little preparation before navigation.In a storyboard-based application";
    labelOne.backgroundColor = [UIColor grayColor];
    [labelOne fitSizeWithFont:[UIFont systemFontOfSize:20]];
    NSLog(@"%@", NSStringFromCGRect(labelOne.frame));   // {{10, 64}, {235, 143.5}}

    [self.view addSubview:labelOne];
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
