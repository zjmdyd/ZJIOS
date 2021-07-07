//
//  ZJPopBaseTableViewController.m
//  KeerZhineng
//
//  Created by ZJ on 2019/1/19.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJPopBaseTableViewController.h"

@interface ZJPopBaseTableViewController ()<UIPopoverPresentationControllerDelegate>

@property (nonatomic, strong) ZJPopRightTableViewController *rightUpVC;

@end

#define PopoverWidth 150
#define ItemHeight 44

@implementation ZJPopBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSuperAry];
    [self initSuperSettiing];
}

- (void)initSuperAry {
    
}

- (void)initSuperSettiing {
    
}

- (void)barItemAction:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        UIPopoverPresentationController *popover = [self.rightUpVC popoverPresentationController];
        popover.delegate = self;
        popover.permittedArrowDirections = UIPopoverArrowDirectionUp;//设置箭头位置
        popover.sourceView = sender;    // 设置目标视图
        popover.sourceRect = ((UIButton *)sender).bounds;
        popover.backgroundColor = [UIColor maskViewAlphaColor];
        [self presentViewController:self.rightUpVC animated:YES completion:nil];
    }
}

#pragma mark - UIPopoverPresentationControllerDelegate

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return YES;
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    
}

#pragma mark - setter/getter

- (void)setRightUpTitles:(NSArray *)rightUpTitles {
    _rightUpTitles = rightUpTitles;
    self.rightUpVC.cellTitles = _rightUpTitles;
    self.rightUpVC.preferredContentSize = CGSizeMake(PopoverWidth, self.rightUpVC.cellTitles.count*ItemHeight);
}

- (ZJPopRightTableViewController *)rightUpVC {
    if (!_rightUpVC) {
        _rightUpVC = (ZJPopRightTableViewController *)[self createVCWithName:@"ZJPopRightTableViewController" title:@"" isGroupTableVC:YES];
        _rightUpVC.modalPresentationStyle = UIModalPresentationPopover;
        _rightUpVC.delegate = self;
        _rightUpVC.rootVC = self;
    }
    
    return _rightUpVC;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
