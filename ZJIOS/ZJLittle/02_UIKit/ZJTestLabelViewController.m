//
//  ZJTestLabelViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/2/14.
//

#import "ZJTestLabelViewController.h"
#import "UILabel+ZJLabel.h"
#import "UIViewExt.h"
//
//@interface UILabel (GGLabel)
//
//- (void)fitSizeWithWidth:(CGFloat)width font:(UIFont *)font;
//
//@end

@implementation UILabel (GGLabel)

// 宽度自适应
- (void)fitSizeWithHeight:(CGFloat)height font:(UIFont *)font {
    self.font = font;
    self.numberOfLines = 2;
    [self sizeToFit];
}

// 宽度自适应
+ (CGSize)fitSizeWithText:(NSString *)text font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAXFLOAT, 0)];
    label.text = text;
    label.font = font;
    [label sizeToFit];
    return label.frame.size;
}

// 高度自适应, 给定宽度
- (void)fitSizeWithFont:(UIFont *)font {
    self.font = font;
    self.numberOfLines = 0;
    [self sizeToFit];
}

// 高度自适应
+ (CGSize)fitSizeWithWidth:(CGFloat)width text:(NSString *)text font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = text;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    return label.frame.size;
}

// 高度自适应
+ (CGSize)fitSizeWithWidth:(CGFloat)width text:(id)text {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    if ([text isKindOfClass:[NSAttributedString class]]) {
        label.attributedText = text;
    }else {
        label.text = text;
    }
    label.numberOfLines = 0;
    [label sizeToFit];
    
    return label.frame.size;
}

@end

@interface ZJTestLabelViewController ()

@end

@implementation ZJTestLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test7];
}

// 宽度自适应
- (void)test7 {
    UILabel *labelOne = [[UILabel alloc] initWithFrame:CGRectMake(10, 64, 1000, 60)];
    labelOne.text = @"In a storyboard-based application, you will often want to do a little preparation before navigation.In a storyboard-based application";
    labelOne.backgroundColor = [UIColor grayColor];
    [labelOne fitSizeWithHeight:60 font:[UIFont systemFontOfSize:20]];
    
    [self.view addSubview:labelOne];
}

// 高度自适应
- (void)test6 {
    UILabel *labelOne = [[UILabel alloc] initWithFrame:CGRectMake(10, 64, 250, 0)];
    labelOne.text = @"In a storyboard-based application, you will often want to do a little preparation before navigation.In a storyboard-based application";
    labelOne.backgroundColor = [UIColor grayColor];
    labelOne.numberOfLines = 0;
    labelOne.font = [UIFont systemFontOfSize:20];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:labelOne.text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20],
                                                                                                    NSForegroundColorAttributeName : [UIColor redColor]
                                                                                                  }];
    CGSize size = [UILabel fitSizeWithWidth:250 text:str];
    NSLog(@"%@", NSStringFromCGSize(size));
    CGRect frame = labelOne.frame;
    frame.size = size;
    labelOne.frame = frame;
    
    [self.view addSubview:labelOne];
}

- (void)test5 {
    UILabel *labelOne = [[UILabel alloc] initWithFrame:CGRectMake(10, 64, 250, 0)];
    labelOne.text = @"In a storyboard-based application, you will often want to do a little preparation before navigation.In a storyboard-based application";
    labelOne.backgroundColor = [UIColor grayColor];
    labelOne.font = [UIFont systemFontOfSize:20];
    labelOne.numberOfLines = 0;
    CGSize size = [UILabel fitSizeWithWidth:250 text:labelOne.text font:labelOne.font];
    NSLog(@"%@", NSStringFromCGSize(size));
    CGRect frame = labelOne.frame;
    frame.size = size;
    labelOne.frame = frame;
    
    [self.view addSubview:labelOne];
}

- (void)test4 {
    UILabel *labelOne = [[UILabel alloc] initWithFrame:CGRectMake(10, 64, 250, 0)];
    labelOne.text = @"In a storyboard-based application, you will often want to do a little preparation before navigation.In a storyboard-based application";
    labelOne.backgroundColor = [UIColor grayColor];
    [labelOne fitSizeWithFont:[UIFont systemFontOfSize:20]];
    
    [self.view addSubview:labelOne];
}

/*
 ****************************
 */

- (void)test3 {
    UILabel *labelOne = [[UILabel alloc] initWithFrame:CGRectMake(10, 64, 0, 0)];
    labelOne.text = @"In a storyboard-based application, you will often want to do a little preparation before navigation.In a storyboard-based application";
    labelOne.backgroundColor = [UIColor grayColor];
    labelOne.numberOfLines = 0;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:labelOne.text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20],
                                                                                                    NSForegroundColorAttributeName : [UIColor redColor]
                                                                                                  }];
    CGSize size = [UILabel fitSizeWithHeight:60 text:str];  // 此处设置高度不起作用
    NSLog(@"%@", NSStringFromCGSize(size));
    CGRect frame = labelOne.frame;
    frame.size = size;
    labelOne.frame = frame;
    
    [self.view addSubview:labelOne];
}

- (void)test2 {
    UILabel *labelOne = [[UILabel alloc] initWithFrame:CGRectMake(10, 64, 250, 0)];
    labelOne.text = @"In a storyboard-based application, you will often want to do a little preparation before navigation.In a storyboard-based application";
    labelOne.backgroundColor = [UIColor grayColor];
    labelOne.numberOfLines = 0;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:labelOne.text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20],
                                                                                                    NSForegroundColorAttributeName : [UIColor redColor]
                                                                                                  }];
    labelOne.attributedText = str;
    [labelOne sizeToFit];
    NSLog(@"%@", NSStringFromCGSize(labelOne.frame.size));
    [self.view addSubview:labelOne];
}

- (void)test1 {
    UILabel *labelOne = [[UILabel alloc] initWithFrame:CGRectMake(10, 64, 250, 0)];
    labelOne.text = @"In a storyboard-based application, you will often want to do a little preparation before navigation.In a storyboard-based application";
    labelOne.backgroundColor = [UIColor grayColor];
    labelOne.font = [UIFont systemFontOfSize:20];
    CGSize size = [UILabel fitSizeWithText:labelOne.text font:labelOne.font];
    NSLog(@"%@", NSStringFromCGSize(size));
    CGRect frame = labelOne.frame;
    frame.size = size;
    labelOne.frame = frame;
    [self.view addSubview:labelOne];
}

- (void)test0 {
    UILabel *labelOne = [[UILabel alloc] initWithFrame:CGRectMake(10, 64, 250, 0)];
    labelOne.text = @"In a storyboard-based application, you will often want to do a little preparation before navigation.In a storyboard-based application";
    labelOne.backgroundColor = [UIColor grayColor];
    labelOne.font = [UIFont systemFontOfSize:20];
    labelOne.numberOfLines = 0;
    CGSize size = [UILabel fitSizeWithWidth:250 text:labelOne.text font:labelOne.font];
    NSLog(@"%@", NSStringFromCGSize(size));
    CGRect frame = labelOne.frame;
    frame.size = size;
    labelOne.frame = frame;
    
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
