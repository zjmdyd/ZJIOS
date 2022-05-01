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
@property (nonatomic, assign) UIAlertControllerStyle alertCtrlStyle;
@property (nonatomic, assign) BOOL needTextField;
@property (nonatomic, assign) BOOL needCancelActStyle;
@property (nonatomic, assign) BOOL needDestructiveActStyle;
@property (nonatomic, assign) NSInteger cancelIndex;
@property (nonatomic, assign) NSInteger destructiveIndex;

@end

@implementation ZJTestAlertTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
    [self initSetting];
}

- (void)initAry {
    self.actTitles = @[@"item0", @"item1", @"item2"];
    self.sectionTitles = @[@"选择AlertControllerStyle", @"选择AlertActionStyleCancel", @"选择AlertActionStyleDestructive", @"选择TextField", @"Show"];
    self.cellTitles = @[
        @[@"AlertStyleActionSheet", @"AlertStyleAlert"],
        @[@"UIAlertActionStyleCancel", @"CancelIndex"],
        @[@"UIAlertActionStyleDestructive", @"DestructiveIndex"],
        @[@"TextField"],
        @[@"ShowAlert"],
    ];
}

- (void)initSetting {
    self.alertCtrlStyle = UIAlertControllerStyleActionSheet;
}

- (NSInteger)sectionOffset:(NSInteger)section {
    return (self.alertCtrlStyle == UIAlertControllerStyleActionSheet && section > 2) ? 1 : 0;   // 无选择textField
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger secCount = self.sectionTitles.count;
    return self.alertCtrlStyle == UIAlertControllerStyleAlert ? secCount : secCount - 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *ary = self.cellTitles[section];
    if (section == 1) {
        return self.needCancelActStyle ? ary.count : ary.count - 1;
    }else if (section == 2) {
        return self.needDestructiveActStyle ? ary.count : ary.count - 1;
    }
    
    return ary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SystemTableViewCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SystemTableViewCell];
    }
    NSInteger sectionOffset = [self sectionOffset:indexPath.section];

    cell.textLabel.text = self.cellTitles[indexPath.section + sectionOffset][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // 0 1 2 3 4
    if (indexPath.section == 0 || (indexPath.row == 0 && (indexPath.section < self.sectionTitles.count - 1 - sectionOffset))) {
        UISwitch *swh = [[UISwitch alloc] init];
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                swh.on = self.alertCtrlStyle == UIAlertControllerStyleActionSheet;
            }else {
                swh.on = self.alertCtrlStyle == UIAlertControllerStyleAlert;
            }
        }else if(indexPath.section == 1) {
            swh.on = self.needCancelActStyle;
        }else if(indexPath.section == 2) {
            swh.on = self.needDestructiveActStyle;
        }else {
            swh.on = self.needTextField;
        }

        NSInteger tagOffset = 0;
        if (indexPath.section > 0) {
            tagOffset = 1;
        }

        swh.tag = indexPath.row + (indexPath.section + tagOffset);    // tag:0, 1, 2, 3, 4
        NSLog(@"%ld, sec= %ld, row = %ld", (long)swh.tag, (long)indexPath.section, (long)indexPath.row);
        [swh addTarget:self action:@selector(swhEvent:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = swh;
    }else {
        cell.accessoryView = nil;
    }
    if(indexPath.row == 1 && (indexPath.section == 1 || indexPath.section == 2)) {
        if (indexPath.section == 1) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"cancelIndex = %ld", (long)self.cancelIndex];
        }else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"destructiveIndex = %ld", (long)self.destructiveIndex];
        }
    }else {
        cell.detailTextLabel.text = nil;
    }
    
    return cell;
}

- (void)swhEvent:(UISwitch *)sender {
    if (sender.tag < 2) {
        if (sender.isOn) {
            self.alertCtrlStyle = sender.tag == 0 ?  UIAlertControllerStyleActionSheet : UIAlertControllerStyleAlert;
        }else {
            self.alertCtrlStyle = sender.tag == 0 ?  UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet;
        }
    }else if(sender.tag == 4) { // textField
        self.needTextField = sender.isOn;
    }else{
        if (sender.tag == 2) {  // Cancel
            self.needCancelActStyle = sender.isOn;
            if ([self checkIndexConflict]) {
                self.destructiveIndex = (++self.destructiveIndex) % self.actTitles.count;
            }
        }else {                 // Destructive
            self.needDestructiveActStyle = sender.isOn;
            if ([self checkIndexConflict]) {
                self.cancelIndex = (++self.cancelIndex) % self.actTitles.count;
            }
        }
    }
    
    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSInteger sectionOffset = [self sectionOffset:section];
    return self.sectionTitles[section + sectionOffset];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger sectionOffset = [self sectionOffset:indexPath.section];
    
    if (indexPath.section == self.sectionTitles.count - 1 - sectionOffset) {
        [self showAlertCtrl];
    }else {
        if (indexPath.section > 0 && indexPath.row == 1) {
            if (indexPath.section == 1) {
                self.cancelIndex = (++self.cancelIndex) % self.actTitles.count;
                if ([self checkIndexConflict]) {
                    self.destructiveIndex = (++self.destructiveIndex) % self.actTitles.count;
                }
            }else {
                self.destructiveIndex = (++self.destructiveIndex) % self.actTitles.count;
                if ([self checkIndexConflict]) {
                    self.cancelIndex = (++self.cancelIndex) % self.actTitles.count;
                }
            }
            [self.tableView reloadData];
        }
    }
}

- (BOOL)checkIndexConflict {
    if (self.needCancelActStyle && self.needDestructiveActStyle && self.cancelIndex == self.destructiveIndex) {
        return YES;
    }
    
    return NO;
}

- (void)showAlertCtrl {
    ZJAlertObject *obj = [ZJAlertObject new];
    obj.title = @"标题";
    obj.msg = @"message";
    obj.actTitles = self.actTitles;
//    obj.actTitleColors = @[[UIColor blueColor], [UIColor greenColor], [UIColor yellowColor]];
    obj.alertCtrlStyle = self.alertCtrlStyle;
    obj.needCancel = self.needCancelActStyle;
    obj.needDestructive = self.needDestructiveActStyle;
    obj.cancelIndex = self.cancelIndex;
    obj.destructiveIndex = self.destructiveIndex;
    if (self.alertCtrlStyle == UIAlertControllerStyleAlert && self.needTextField) {
        ZJTextInputConfig *cfg = [[ZJTextInputConfig alloc] init];
        cfg.text = @"hello";
        cfg.textColor = [UIColor redColor];
        obj.textFieldConfigs = @[cfg];
    }
    NSLog(@"needCancelActStyle = %d, cancelIndex = %ld", self.needCancelActStyle, (long)self.cancelIndex);
    NSLog(@"needDestructiveActStyle = %d, destructiveIndex = %ld", self.needDestructiveActStyle, (long)self.destructiveIndex);
    
    [self alertFunc:obj alertCompl:^(ZJAlertAction *act, NSArray *textFields) {
        NSLog(@"title = %@, %@, tag = %ld", act.title, textFields, (long)act.tag);
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
