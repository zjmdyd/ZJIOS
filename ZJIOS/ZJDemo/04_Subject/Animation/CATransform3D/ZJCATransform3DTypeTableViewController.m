//
//  ZJCATransform3DTypeTableViewController.m
//  ZJCoreAnimation
//
//  Created by YunTu on 10/8/15.
//  Copyright © 2015 YunTu. All rights reserved.
//

#import "ZJCATransform3DTypeTableViewController.h"
#import "ZJCATransform3DViewController.h"
#import "UIViewController+ZJViewController.h"

@interface ZJCATransform3DTypeTableViewController () {
    NSArray *_titles, *_vcNames;
}

@end

static NSString *CELLID = @"cellID";

@implementation ZJCATransform3DTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
    [self initSettiing];
}

- (void)initAry {
    _titles = @[@"平移", @"缩放", @"正交投影", @"旋转1", @"旋转2"];
    _vcNames = @[@"ZJCATransform3DViewController", @"ZJCATransform3DRotation2ViewController"];
}

- (void)initSettiing {
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELLID];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    
    cell.textLabel.text = _titles[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *vcName = _vcNames[indexPath.row/4];
    UIViewController *vc = [UIViewController createVCWithName:vcName title:_titles[indexPath.row]];
    if ([vc isKindOfClass:NSClassFromString(_vcNames[0])]) {
        ((ZJCATransform3DViewController *)vc).transformType = indexPath.row;
    }
    [self showViewController:vc sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"transform3D"]) {
        NSIndexPath *indexPath = sender;
        
        ZJCATransform3DViewController *vc = [segue destinationViewController];
        vc.transformType = indexPath.row;
        vc.title = _titles[indexPath.row];
    }
}
*/

@end
