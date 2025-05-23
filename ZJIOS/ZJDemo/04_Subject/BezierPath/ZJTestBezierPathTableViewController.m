//
//  ZJTestBezierPathTableViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2025/5/19.
//

#import "ZJTestBezierPathTableViewController.h"
#import "ZJTestBezierPathView.h"

@interface ZJTestBezierPathTableViewController ()

@property (nonatomic, strong) ZJTestBezierPathView *pathView;

@end

@implementation ZJTestBezierPathTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
}

- (void)initAry {
    self.vcType = ZJBaseTableViewTypeExecute;
    self.cellTitles = @[@"test0", @"test1", @"test2", @"test3", @"test4"];
}

- (void)addPathView:(BOOL)need {
    if (self.pathView) {
        [self.pathView removeFromSuperview]; self.pathView = nil;
    }
    self.pathView = [[ZJTestBezierPathView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.pathView.center = self.view.center;
    self.pathView.needAnimation = need;
    [self.view addSubview:self.pathView];
    self.pathView.backgroundColor = [UIColor greenColor];
}

- (void)test0 {
    [self addPathView:NO];
}

- (void)test1 {
    [self addPathView:YES];
}

- (void)test2 {
    [self showVCWithName:@"ZJTestBezierPathViewController"];
}

- (void)test3 {
    [self showVCWithName:@"ZJBezierViewController"];
}

- (void)test4 {
    [self showVCWithNibName:@"ZJWriteViewController"];
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
