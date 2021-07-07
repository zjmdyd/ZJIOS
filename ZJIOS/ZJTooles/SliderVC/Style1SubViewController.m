//
//  Style1SubViewController.m
//  Menu
//
//  Created by YunTu on 15/2/10.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "Style1SubViewController.h"
#import "HYSideMenuHeadView.h"

@interface Style1SubViewController ()<UITableViewDelegate, UITableViewDataSource, HYSideMenuHeadViewDelegate> {
    
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYSideMenuHeadView *menuHeadView;

@end

@implementation Style1SubViewController

@dynamic delegate;

#pragma mark - View lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
    [self initSettiing];
}

- (void)initAry {
    self.cellTitles = @[
                        @[@"消息中心"],
                        @[@"添加手动场景", @"添加自动场景"],
                        @[@"意见反馈", @"关于", @"设置"],
                        ];
    self.vcNames = @[
                     @[@"HYMessageTableViewController"],
                     @[@"HYAddManualSceneTableViewController", @"HYAddAutoSceneTableViewController"],
                     @[@"HYFeedbackTableViewController", @"HYAboutTableViewController", @"HYSettingTableViewController"]
                     ];
}

- (void)initSettiing {
    [self createTableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
}

- (void)createTableView {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.tableView];
    
    ZJWrapView *view = (ZJWrapView *)[ZJWrapView createNibViewWithNibName:@"HYSideMenuHeadView" frame:CGRectMake(0, 0, self.tableView.width, 220) needWrap:YES];
    self.menuHeadView = (HYSideMenuHeadView *)view.wrapView;
    self.menuHeadView.backgroundColor = [UIColor mainColor];
    self.menuHeadView.delegate = self;
    self.tableView.tableHeaderView = view;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cellTitles[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SystemTableViewCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SystemTableViewCell];
    }
    cell.textLabel.text = self.cellTitles[indexPath.section][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self showOrHideSideMenu];
    if (indexPath.section == 1 && !DefaultHouse) {
        ShowProgressView(@"请先选择默认家庭", 1.0, MBProgressHUDModeText); return;
    }
    
    NSString *vcName = self.vcNames[indexPath.section][indexPath.row];
    NSString *title = self.cellTitles[indexPath.section][indexPath.row];
    UIViewController *vc = [self createVCWithName:vcName title:title isGroupTableVC:YES];
    [self.rootVC showViewController:vc sender:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return FLT_EPSILON;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return DefaultSectionFooterHeight;
}

#pragma mark - HYSideMenuHeadViewDelegate

- (void)sideMenuHeadViewDidSelectHeadView:(HYSideMenuHeadView *)view {
    [self showOrHideSideMenu];
    
    UIViewController *vc = [self createVCWithName:@"HYMineProfileTableViewController" title:@"编辑个人资料" isGroupTableVC:YES];
    [self.rootVC showViewController:vc sender:nil];
}

#pragma mark - setter

- (void)setNickName:(NSString *)nickName {
    _nickName = nickName;
    
    self.menuHeadView.title = _nickName;
}

- (void)setIconPath:(NSString *)iconPath {
    _iconPath = iconPath;
    self.menuHeadView.imgName = _iconPath;
}

#pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.contentView addSubview:_tableView];
    }
    
    return _tableView;
}

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
