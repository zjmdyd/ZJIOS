//
//  ZJTestPageCtrlViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/4/11.
//

#import "ZJTestPageCtrlViewController.h"
#import "XHPageControl.h"
#import "ZJFuncDefine.h"

@interface ZJTestPageCtrlViewController ()<UIScrollViewDelegate, XHPageControlDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) XHPageControl *pageControl;

@end

@implementation ZJTestPageCtrlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 140, [UIScreen mainScreen].bounds.size.width, 100)];
    _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*7, 100);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.tag = 1003;
    for (int i = 1; i <=7; i++) {
        [self.scrollView addSubview:[self createImgView:i]];
    }
    [self.view addSubview:_scrollView];
    
    _pageControl = [[XHPageControl alloc] initWithFrame:CGRectMake(0, 240,[UIScreen mainScreen].bounds.size.width, 30)];
    _pageControl.numberOfPages = 7;
    _pageControl.controlSize = 5;
    _pageControl.controlSpacing = 4;
    _pageControl.currentMultiple = 4.8;
    _pageControl.otherColor = UIColorFromHexA(0xDBDDE3, 0.3);
    _pageControl.currentColor = UIColorFromHex(0xDBDDE3);
    _pageControl.delegate = self;
    _pageControl.tag = 903;
    [self.view addSubview:_pageControl];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSInteger currentPage = targetContentOffset->x / [UIScreen mainScreen].bounds.size.width;
    if(scrollView.tag == 1003){
        self.pageControl.currentPage = currentPage;
    }
}

#pragma mark - XHPageControlDelegate

- (void)xh_PageControlClick:(XHPageControl*)pageControl index:(NSInteger)clickIndex{
    NSLog(@"%ld",clickIndex);
     if(pageControl.tag == 903){
        CGPoint position = CGPointMake([UIScreen mainScreen].bounds.size.width * clickIndex, 0);
        [_scrollView setContentOffset:position animated:YES];
    }
}

- (UIImageView *)createImgView:(int)index{
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"pic-%d",index]]];
    imgV.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * (index-1), 0, [UIScreen mainScreen].bounds.size.width, 100);
    imgV.layer.borderWidth = 1;
    return imgV;
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
