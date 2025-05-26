//
//  ZJCGContextViewController.m
//  ZJCoreGraphics
//
//  Created by YunTu on 10/7/15.
//  Copyright © 2015 YunTu. All rights reserved.
//

#import "ZJCGContextViewController.h"
#import "ZJContextView.h"
#import "UIViewExt.h"

@interface ZJCGContextViewController ()<UIScrollViewDelegate>

@end

static NSInteger count = 6;

@implementation ZJCGContextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self performSelector:@selector(test0) withObject:nil afterDelay:0.05];
}

- (void)test0 {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 120, self.view.width - 20, self.view.height - 140)];
//    scrollView.delegate = self;
//    scrollView.pagingEnabled = YES;
    scrollView.layer.borderWidth = 1.0;
    [self.view addSubview:scrollView];
    
    CGFloat offsetX = 20.0;
    
    for (int i = 0; i < count; i++) {
        ZJContextView *view = [ZJContextView new];
        view.tag = i;
        view.contentMode = UIViewContentModeScaleAspectFit;
        if (i == count - 1) {
            view.backgroundColor = [UIColor clearColor];
        }else {
        }
        view.backgroundColor = [UIColor redColor];
        view.frame = CGRectMake(i * (scrollView.width + offsetX), 0, scrollView.width, scrollView.height);

        [scrollView addSubview:view];
    }
    scrollView.contentSize = CGSizeMake(scrollView.width * count + offsetX * (count-1), 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSInteger index = scrollView.contentOffset.x / scrollView.width;
//    CGPoint point = scrollView.contentOffset;
//    point.x += 20 * (index % (count - 1));
//    [UIView animateWithDuration:.25 animations:^{
//        scrollView.contentOffset = point;
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation cmmb5788

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

