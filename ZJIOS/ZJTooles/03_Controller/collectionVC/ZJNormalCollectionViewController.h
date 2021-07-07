//
//  ZJNormalCollectionViewController.h
//  CanShengHealth
//
//  Created by ZJ on 2018/7/4.
//  Copyright © 2018 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef RefreshEventType

#define RefreshEventType MJRefreshEvent
typedef NS_ENUM(NSInteger, RefreshEventType) {
    RefreshEventTypeOfHeader,
    RefreshEventTypeOfFooter,
};

#endif

@interface ZJNormalCollectionViewController : UICollectionViewController

@property (nonatomic, assign) BOOL needRefresh;
@property (nonatomic, assign) BOOL needMJHeaderRefresh; // 是否需要下拉刷新
@property (nonatomic, assign) BOOL needMJFooterRefresh; // 是否需要上拉加载更多
@property (nonatomic, assign) BOOL needChangeExtendedLayout;

@property (nonatomic, strong) NSArray *placeholds, *icons, *values, *titles, *vcNames, *cellTitles, *sectionTitles, *nibs, *units;
@property (nonatomic, strong) NSMutableArray *mutablePlaceholds, *mutableIcons, *mutableTitles, *mutableVCNames, *mutableCellTitles, *mutableSectionTitles, *mutableNibs, *mutableUnits, *mutableValues;
@property (nonatomic, copy) NSString *emptyMessage;
@property (nonatomic, copy) NSString *emptyImageName;
@property (nonatomic, assign) CGFloat emptyOffset;

- (void)mjRefreshEventWithType:(RefreshEventType)type;
- (void)endMJRefresh;
- (void)notiRefreshEvent:(NSNotification *)noti;   // 通知刷新

@end
