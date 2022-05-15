//
//  ZJTestLayerBorderViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/5/15.
//

#import "ZJTestLayerBorderViewController.h"
#import "UIViewExt.h"
#import "CALayer+ZJLayer.h"

@interface ZJTestLayerBorderViewController ()

@property (nonatomic, strong) UIView *borderView;

@end

@implementation ZJTestLayerBorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
    [self test0];
}

- (void)initAry {
    self.titles = @[@"上", @"下", @"左", @"右", @"全部"];
}

- (void)test0 {
    CGFloat width = 200;
    self.borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, width, width)];
    self.borderView.center = self.view.center;
    self.borderView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.borderView];
    
    CGFloat btnWidth = 50, span = 11.6;
    for (int i = 0; i < self.titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(span*(i+1) + btnWidth*i, self.borderView.bottom + 16, btnWidth, 30);
        btn.backgroundColor = [UIColor greenColor];
        btn.tag = i;
        [btn setTitle:self.titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)btnEvent:(UIButton *)sender {
    UIBorderSideType type;
    if (sender.tag == 0) {
        type = UIBorderSideTypeTop;
    }else if (sender.tag == 1) {
        type = UIBorderSideTypeBottom;
    }else if (sender.tag == 2) {
        type = UIBorderSideTypeLeft;
    }else if (sender.tag == 3) {
        type = UIBorderSideTypeRight;
    }else {
        type = UIBorderSideTypeAll;
    }
    [self.borderView.layer addBorderForColor:[UIColor greenColor] borderWidth:2 borderType:type];
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
