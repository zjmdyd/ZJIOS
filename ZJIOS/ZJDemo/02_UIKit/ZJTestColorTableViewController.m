//
//  ZJTestColorTableViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/2/11.
//

#import "ZJTestColorTableViewController.h"
#import "UIColor+ZJColor.h"
#import "ZJLayoutDefines.h"

@interface ZJTestColorTableViewController ()

@property (nonatomic, strong) UIView *colorView;

@end

@implementation ZJTestColorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSetting];
    [self initAry];
}

- (void)initSetting {
    self.colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    self.colorView.hidden = YES;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 100, 50);
    btn.center = self.colorView.center;
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.colorView addSubview:btn];
    [KeyWindow addSubview:self.colorView];
}

- (void)btnEvent:(UIButton *)sender {
    self.colorView.hidden = YES;
}

- (void)initAry {
    self.cellTitles = @[@"maskViewColor", @"maskViewAlphaColor"];
    self.values = @[[UIColor maskViewColor], [UIColor maskViewAlphaColor]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.values.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZJBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SystemTableViewCell];
    if (!cell) {
        cell = [[ZJBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SystemTableViewCell];
    }
    cell.textLabel.text = self.cellTitles[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.colorView.backgroundColor = self.values[indexPath.row];
    [UIView animateWithDuration:0.25 animations:^{
        self.colorView.hidden = NO;
    }];
}

// 会执行
- (void)dealloc {
    NSLog(@"%s", __func__);
}

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
