//
//  ZJTabBarViewController.m
//  PhysicalDate
//
//  Created by ZJ on 4/26/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJTabBarViewController.h"
#import "ZJDefine.h"

@interface ZJTabBarViewController ()<UIScrollViewDelegate> {
    NSMutableArray *_titles, *_scrButtons;
    UIView *_lineView;
    CGFloat _height, _mainViewH;
    NSInteger _firstSelectIdx;
}

@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) BOOL hiddenNavigationBar;

@end

@implementation UILabel(FitSizeLabel)

+ (CGSize)fitSizeWithMargin:(CGFloat)margin text:(NSString *)text font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = text;
    if (font) label.font = font;
        label.numberOfLines = 0;
        
        if (margin < 0) {
            margin = DefaultMargin;
        }
    CGFloat width = kScreenW - 2*margin;
    CGSize size = [label sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    
    return size;
}

@end

@implementation UIView(FitFrameView)

- (CGFloat) left
{
    return self.frame.origin.x;
}

- (void) setLeft: (CGFloat) newleft {
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (void) setHeight: (CGFloat) newheight
{
    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

@end

@implementation ZJTabBarViewController

+ (instancetype)barViewControllerWithViewControllers:(NSArray *)viewControllers {
    ZJTabBarViewController *vc = [ZJTabBarViewController new];
    vc->_viewControllers = viewControllers;
    vc->_height = kScreenH;
    
    return vc;
}

+ (instancetype)barViewControllerWithViewControllers:(NSArray *)viewControllers height:(CGFloat)height {
    ZJTabBarViewController *vc = [ZJTabBarViewController barViewControllerWithViewControllers:viewControllers];
    vc->_height = height;
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
}

- (void)initAry {
    _titles = [NSMutableArray array];
    _scrButtons = [NSMutableArray array];
}

- (void)initSetting {
    self.view.backgroundColor = [UIColor whiteColor];
    _selectEnable = YES;
    
    if (self.offsetX > 0) {
        [self.view addSubview:self.statusView];
    }
    
    [self createScrollView];
    
    if (self.selectIndex != 0) {
        [self btnEvent:[self buttonWithIndex:self.selectIndex]];
    }
}

- (void)createScrollView {
    [self.view addSubview:self.topScrollView];
    [self.topScrollView addSubview:self.lineView];
    self.offsetX = 0;//kStatusBarH;

    _mainViewH = _height - self.offsetX - self.topScrollView.frame.size.height;
    if (self.hidesBottomBarWhenPushed == NO) {
        _mainViewH -= kTabBarHeight;
    }
    if (!self.hiddenNavigationBar) {
        _mainViewH -= (kNaviBarHeight + kStatusBarH);
    }
    [self.view addSubview:self.mainScrollView];
    
    CGFloat totalWidth = 0.0;
    for (int i = 0; i < _viewControllers.count; i++) {
        UIViewController *vc = _viewControllers[i];
        [_titles addObject:vc.title?:@""];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.tag = i;
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [_scrButtons addObject:btn];
        
        CGFloat width = [UILabel fitSizeWithMargin:0 text:vc.title font:[UIFont systemFontOfSize:14]].width+DefaultMargin*2;
        btn.frame = CGRectMake(totalWidth, 0, width, self.topScrollView.frame.size.height);
        totalWidth += width;
        
        if (i == 0) {
            _currentVC = vc;
            self.lineView.frame = CGRectMake(btn.frame.origin.x+DefaultMargin, self.topScrollView.frame.size.height - 3.0f, btn.frame.size.width  - DefaultMargin*2, 2);
            [btn setTitleColor:self.currentTitleColor forState:UIControlStateNormal];
        }else {
            [btn setTitleColor:self.titleColor forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.topScrollView addSubview:btn];
        
        vc.view.frame = CGRectMake(i*kScreenW, 0, kScreenW, self.mainScrollView.frame.size.height);
        [self.mainScrollView addSubview:vc.view];
    }
    if (totalWidth < kScreenW) {
        CGFloat offset = (kScreenW - totalWidth) / (_viewControllers.count+1);
        for (UIButton *btn in _scrButtons) {
            btn.left += offset*(btn.tag+1);
            if (btn.tag == 0) _lineView.left = btn.frame.origin.x+DefaultMargin;
        }
    }
    self.topScrollView.contentSize = CGSizeMake(totalWidth, 0);
    self.mainScrollView.contentSize = CGSizeMake(_viewControllers.count*kScreenW, 0);
    
    if (_firstSelectIdx != 0) {
        [self btnEvent:[self buttonWithIndex:_firstSelectIdx]];
    }
}

#pragma mark - buttonEvent

- (void)btnEvent:(UIButton *)sender {
    if (_selectIndex == sender.tag) return;
    
    _selectIndex = sender.tag;
    _currentVC = _viewControllers[_selectIndex];
    
    [self adjustTopScrollViewContentOffset:sender];
    
    [self selectButtonItem:sender];
    [self.mainScrollView setContentOffset:CGPointMake(kScreenW*sender.tag, 0) animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(tabBarViewController:didSelectedIndex:)]) {
        [self.delegate tabBarViewController:self didSelectedIndex:sender.tag];
    }
    
    if ([self.delegate respondsToSelector:@selector(tabBarViewController:didSelectedViewController:)]) {
        [self.delegate tabBarViewController:self didSelectedViewController:_viewControllers[sender.tag]];
    }
}

- (void)adjustTopScrollViewContentOffset:(UIButton *)sender {
    if (sender.frame.origin.x + sender.frame.size.width > self.topScrollView.frame.size.width) {
        CGFloat offsetX = sender.frame.origin.x + sender.frame.size.width - self.topScrollView.frame.size.width;
        if (sender.tag < _viewControllers.count - 1) offsetX += 40;
        [self.topScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }else {
        [self.topScrollView setContentOffset:CGPointZero animated:YES];
    }
}

- (void)selectButtonItem:(UIButton *)sender {
    [UIView animateWithDuration:.2 animations:^{
        self.lineView.frame = CGRectMake(sender.frame.origin.x + DefaultMargin, self.lineView.frame.origin.y, sender.frame.size.width - DefaultMargin*2, self.lineView.frame.size.height);
    } completion:^(BOOL finished) {
        [self changeButtonTitleColor:sender];
    }];
}

- (void)changeButtonTitleColor:(UIButton *)sender {
    for (UIButton *btn in _scrButtons) {
        if (btn.tag == _selectIndex) {
            [btn setTitleColor:self.currentTitleColor forState:UIControlStateNormal];
        }else {
            [btn setTitleColor:self.titleColor forState:UIControlStateNormal];
        }
    }
}

- (void)setSelectIndex:(NSUInteger)selectIndex {
    if (selectIndex >= _viewControllers.count) {
        selectIndex = _viewControllers.count-1;
    }
    
    if (_selectIndex != selectIndex) {
        UIButton *btn = [self buttonWithIndex:selectIndex];
        if (btn) {
            [self btnEvent:btn];
        }else {
            _firstSelectIdx = selectIndex;
        }
    }
}

- (UIButton *)buttonWithIndex:(NSUInteger)index {
    for (UIButton *btn in _scrButtons) {
        if (btn.tag == index) {
            return btn;
        }
    }
    
    return nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    UIButton *btn = [self buttonWithIndex:index];
    if (btn) {
        [self btnEvent:btn];
    }
}

#pragma mark - setter

- (void)setSelectEnable:(BOOL)selectEnable {
    _selectEnable = selectEnable;
    
    self.topScrollView.userInteractionEnabled = self.mainScrollView.scrollEnabled = _selectEnable;
}

#pragma mark - getter

- (UIView *)statusView {
    if (!_statusView) {
        _statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, self.offsetX)];
        _statusView.backgroundColor = self.statusBgViewColor;
    }
    
    return _statusView;
}

- (UIScrollView *)topScrollView {
    if (!_topScrollView) {
        
        _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.hiddenNavigationBar ? self.offsetX : 0, kScreenW, kNaviBarHeight)];
        _topScrollView.directionalLockEnabled = YES;
        _topScrollView.showsHorizontalScrollIndicator = NO;
        _topScrollView.backgroundColor = self.topViewBgColor;
    }
    
    return _topScrollView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = self.currentTitleColor;
    }
    
    return _lineView;
}

- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _topScrollView.frame.origin.y + _topScrollView.frame.size.height, kScreenW, _mainViewH)];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.delegate = self;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
    }
    
    return _mainScrollView;
}

- (UIColor *)topViewBgColor {
    if (!_topViewBgColor) {
        _topViewBgColor = [UIColor whiteColor];
    }
    
    return _topViewBgColor;
}

- (UIColor *)currentTitleColor {
    if (!_currentTitleColor) {
        _currentTitleColor = [UIColor redColor];
    }
    
    return _currentTitleColor;
}

- (UIColor *)titleColor {
    if (!_titleColor) {
        _titleColor = [UIColor blackColor];
    }
    
    return _titleColor;
}

- (BOOL)hiddenNavigationBar {
    return self.parentViewController.navigationController.isNavigationBarHidden || self.parentViewController.navigationController.navigationBar.isHidden;
}

- (CGFloat)offsetX {
    if (self.hiddenNavigationBar) {
        return kStatusBarH;
    }
    
    return 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (!_topScrollView) {
        self.view.height = _height;

        [self initSetting];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (instancetype)initWithViewControllers:(NSArray *)viewControllers {
    if (self = [super init]) {
        _viewControllers = viewControllers;
        _height = kScreenH;
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (instancetype)initWithViewControllers:(NSArray *)viewControllers height:(CGFloat)height {
    if (self = [super init]) {
        _viewControllers = viewControllers;
        _height = height;
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
