//
//  ZJNormalTableViewController.m
//  BaoChengTong
//
//  Created by ZJ on 13/10/2017.
//  Copyright © 2017 csj. All rights reserved.
//

#import "ZJNormalTableViewController.h"

@interface ZJNormalTableViewController ()
#ifdef ZJDZNEmpty
    <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
#endif

@end

// 方法弃用警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@implementation ZJNormalTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.needChangeContentInsetAdjust = YES;
    self.tableView.showsVerticalScrollIndicator = NO;    
#ifdef ZJDZNEmpty
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
#endif
}

- (void)setNeedChangeContentInsetAdjust:(BOOL)needChangeContentInsetAdjust {
    _needChangeContentInsetAdjust = needChangeContentInsetAdjust;
    
    if (@available(iOS 11.0, *)) {
        if (_needChangeContentInsetAdjust) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
    }else {
        self.automaticallyAdjustsScrollViewInsets = !_needChangeContentInsetAdjust;
    }
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
}

- (void)setNeedMJHeaderRefresh:(BOOL)needMJHeaderRefresh {
    _needMJHeaderRefresh = needMJHeaderRefresh;
    
#ifdef ZJMJRefresh
    if (_needMJHeaderRefresh) {
        __weak typeof(self) weekSelf = self;
        weekSelf.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weekSelf mjRefreshEventWithType:RefreshEventTypeOfHeader];
        }];
    }else {
        self.tableView.mj_header = nil;
    }
#endif
}

- (void)setNeedMJFooterRefresh:(BOOL)needMJFooterRefresh {
    _needMJFooterRefresh = needMJFooterRefresh;
    
#ifdef ZJMJRefresh
    if (_needMJFooterRefresh && !self.tableView.mj_footer) {
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self mjRefreshEventWithType:RefreshEventTypeOfFooter];
        }];
    }else {
        self.tableView.mj_footer = nil;
    }
#endif
}

- (void)endMJRefresh {
#ifdef ZJMJRefresh
    dispatch_async(dispatch_get_main_queue(), ^{
        self.needRefresh = NO;
        
        [self.tableView.mj_header endRefreshing];
        if (self.tableView.mj_footer) {
            [self.tableView.mj_footer endRefreshing];
        }
    });
#endif
}

- (void)mjRefreshEventWithType:(RefreshEventType)type {
    if (type == RefreshEventTypeOfHeader) {
        self.needRefresh = YES;        
    }
}

#pragma maek - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *str = self.emptyMessage ?: @"暂无数据";
    return [[NSAttributedString alloc] initWithString:str attributes:@{
                                                                       NSFontAttributeName : [UIFont systemFontOfSize:19]
                                                                       }];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:self.emptyImageName ?: @""];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return self.emptyOffset;
}

#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView *fView = ((UITableViewHeaderFooterView *)view);
        fView.textLabel.font = [UIFont systemFontOfSize:15];
    }
}

- (void)notiRefreshEvent:(NSNotification *)noti {
    self.needRefresh = YES;
}

- (void)netNotiRefreshEvent:(NSNotification *)noti {
    NSLog(@"%s, %@", __func__, noti.object);

    self.reconnectNetwork = [noti.object boolValue];
}

- (void)setTranslucent:(BOOL)translucent {
#ifdef ZJNaviCtrl
    ((ZJNavigationController *)self.navigationController).needChangeExtendedLayout = !translucent;  // NO
    ((ZJNavigationController *)self.navigationController).navigationBarTranslucent = translucent;   // YES
#endif

    self.needChangeContentInsetAdjust = !translucent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 #ifdef ZJNaviCtrl
    if (((ZJNavigationController *)self.navigationController).navigationBar.isTranslucent) {
        [self setTranslucent:NO];
    }
#endif
}

- (void)resetValuesWithKVO:(id)obj {
    for (int i = 0; i < self.keys.count; i++) {
        id key = self.keys[i];
        if ([key isKindOfClass:[NSArray class]]) {
            for (int j = 0; j < ((NSArray *)key).count; j++) {
                NSString *subKey = key[j];
                id value = [self value:obj forKey:subKey];
                [self.values[i] replaceObjectAtIndex:j withObject:value];
            }
        }else {
            id value = [self value:obj forKey:key];
            [self.mutableValues replaceObjectAtIndex:i withObject:value];
        }
    }
}

- (id)value:(id)obj forKey:(NSString *)key {
    id value;
    if ([obj isKindOfClass:[NSDictionary class]]) {
        value = obj[key];
    }else {
        value = [obj valueForKey:key];
    }
    return value;
}
//
//- (void)showViewController:(UIViewController *)vc sender:(id)sender {
//    self.hidesBottomBarWhenPushed = YES;
//    [super showViewController:vc sender:sender];
//}

//#pragma mark - 扫描
//
//- (void)beganScan {
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
//#ifdef ShowProgress
//        ShowProgressView(@"设备不支持该操作", 1.0, MBProgressHUDModeText); return;
//#endif
//    }
//    
//    // 1.创建捕捉会话
//    AVCaptureSession *session = [[AVCaptureSession alloc] init];
//    self.session = session;
//    
//    // 2.设置输入(摄像头)
//    //  AVMediaTypeVideo:摄像头 AVMediaTypeAudio:话筒 AVMediaTypeMuxed:弹幕
//    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
//    [session addInput:input];
//    
//    // 3.设置输出(数据) 需遵守AVCaptureMetadataOutputObjectsDelegate代理
//    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
//    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//    [session addOutput:output];
//    // 设置输入的类型,必须在output加入到会话之后来设置
//    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
//    
//    // 4.添加阅览图层
//    AVCaptureVideoPreviewLayer *layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
////    CGFloat width = kScreenW*2/3, height = kScreenH/2;
////    CGFloat width = 300, y = 100;
//
//    layer.frame = CGRectMake(0, 0, kScreenH/2, kScreenH/2);// CGRectMake((kScreenW-width)/2, y, width, width);
//    [self.view.layer addSublayer:layer];
//    self.layer = layer;
//    
//    // 5.开始扫描
//    [session startRunning];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
