//
//  ZJNormalTableViewController.h
//  BaoChengTong
//
//  Created by ZJ on 13/10/2017.
//  Copyright © 2017 csj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#ifndef RefreshEventType

#define RefreshEventType MJRefreshEvent
typedef NS_ENUM(NSInteger, RefreshEventType) {
    RefreshEventTypeOfHeader,
    RefreshEventTypeOfFooter,
};

#endif

@interface ZJNormalTableViewController : UITableViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, assign) BOOL needRefresh;         // 刷新数据
@property (nonatomic, assign) BOOL reconnectNetwork;    // 重新连接网络
@property (nonatomic, assign) BOOL needMJHeaderRefresh; // 是否需要下拉刷新
@property (nonatomic, assign) BOOL needMJFooterRefresh; // 是否需要上拉加载更多
@property (nonatomic, assign) BOOL needChangeContentInsetAdjust;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@property (nonatomic, strong) NSArray *placeholds, *inputMentions, *icons, *values, *titles, *vcNames, *cellTitles, *sectionTitles, *nibs, *units, *keys, *selectRows;
@property (nonatomic, strong) NSMutableArray *mutablePlaceholds, *mutableInputMentions, *mutableIcons, *mutableTitles, *mutableVCNames, *mutableCellTitles, *mutableSectionTitles, *mutableNibs, *mutableUnits, *mutableValues, *mutableKeys, *mutableSelectRows;
@property (nonatomic, copy) NSString *emptyMessage;
@property (nonatomic, copy) NSString *emptyImageName;
@property (nonatomic, assign) CGFloat emptyOffset;
@property (nonatomic, assign) NSInteger selectRow;

- (void)mjRefreshEventWithType:(RefreshEventType)type;
- (void)endMJRefresh;
- (void)notiRefreshEvent:(NSNotification *)noti;   // 通知刷新
- (void)netNotiRefreshEvent:(NSNotification *)noti;
- (void)setTranslucent:(BOOL)translucent;
- (void)resetValuesWithKVO:(id)obj;

//#pragma mark - 扫描
//
//@property (nonatomic, weak) AVCaptureSession *session;
//@property (nonatomic, weak) AVCaptureVideoPreviewLayer *layer;

//- (void)beganScan;

@end
