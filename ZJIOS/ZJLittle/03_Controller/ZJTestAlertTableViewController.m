//
//  ZJTestAlertTableViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/11/18.
//

#import "ZJTestAlertTableViewController.h"
#import "UIViewController+ZJViewController.h"

@interface ZJTestAlertTableViewController ()

@property (nonatomic, strong) NSArray *actTitles;
@property (nonatomic, assign) BOOL needCancelActStyle;
@property (nonatomic, assign) NSInteger cancelIndex;
@end

@implementation ZJTestAlertTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
    [self initSetting];
}

- (void)initAry {
    self.actTitles = @[@"item0", @"item1", @"item2"];
    self.sectionTitles = @[@"UIAlertControllerStyleActionSheet", @"UIAlertControllerStyleAlert"];
    self.cellTitles = @[
        @[],
        @[@"UIAlertActionStyleCancel", @"cencelIndex"],
    ];
}

- (void)initSetting {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *ary = self.cellTitles[section];
    if (section == 1) {
        return self.needCancelActStyle ? ary.count : ary.count - 1;
    }
    return ary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SystemTableViewCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SystemTableViewCell];
    }
    cell.textLabel.text = self.cellTitles[indexPath.section][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 1) {
        
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UISwitch *swh = [[UISwitch alloc] init];
            swh.on = self.needCancelActStyle;
            [swh addTarget:self action:@selector(swhEvent:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = swh;
        }else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"cancelIndex = %ld", (long)self.cancelIndex];
        }
    }
    
    return cell;
}

- (void)swhEvent:(UISwitch *)sender {
    self.needCancelActStyle = sender.isOn;
    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionTitles[section];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIAlertControllerStyle style = indexPath.section == 0 ? UIAlertControllerStyleActionSheet : UIAlertControllerStyleAlert;
    if (indexPath.row == 0) {
        [self showAlertWithStyle:style];
    }else {
        self.cancelIndex = (++self.cancelIndex) % self.actTitles.count;
        [self.tableView reloadData];
    }
}

- (void)showAlertWithStyle:(UIAlertControllerStyle)style {
    ZJAlertObject *obj = [ZJAlertObject new];
    obj.title = @"标题";
    obj.msg = @"message";
    obj.actTitles = self.actTitles;
    obj.actTitleColors = @[[UIColor blueColor], [UIColor greenColor], [UIColor redColor]];
    obj.needCancel = self.needCancelActStyle;
    obj.cancelIndex = self.cancelIndex;
    obj.alertStyle = style;
    if (style == UIAlertControllerStyleAlert) {
//        ZJTextInputConfig *cfg = [[ZJTextInputConfig alloc] init];
//        cfg.text = @"hello";
//        cfg.textColor = [UIColor redColor];
//        obj.textFieldConfigs = @[cfg];
    }else {
        //        obj.needDestructive = NO;
                //    obj.destructiveIndex = 1;
    }
    
    [self alertFunc:obj alertCompl:^(ZJAlertAction *act, NSArray *textFields) {
        NSLog(@"%@, %@, %ld", act.title, textFields, (long)act.tag);
    }];
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
