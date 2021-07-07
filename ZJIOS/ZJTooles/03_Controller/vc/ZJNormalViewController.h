//
//  ZJNormalViewController.h
//  WeiMing
//
//  Created by ZJ on 13/04/2018.
//  Copyright © 2018 HY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^SelectItemsCompletion)(NSInteger index);

@interface ZJNormalViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, assign) BOOL needRefresh;
@property (nonatomic, strong) NSArray *placeholds, *icons, *values, *titles, *vcNames, *cellTitles, *sectionTitles, *nibs, *units, *keys;
@property (nonatomic, strong) NSMutableArray *mutablePlaceholds, *mutableIcons, *mutableValues, *mutableTitles, *mutableVCNames, *mutableCellTitles, *mutableSectionTitles, *mutableNibs, *mutableUnits;

- (void)notiRefreshEvent:(NSNotification *)noti;   // 通知
- (void)setTranslucent:(BOOL)translucent;
- (void)resetValuesWithKVO:(id)obj;

- (void)selectItems:(NSArray *)items highlightIndex:(NSInteger)index completion:(SelectItemsCompletion)cmpt;

//#pragma mark - 扫描
//
//@property (nonatomic, weak) AVCaptureSession *session;
//@property (nonatomic, weak) AVCaptureVideoPreviewLayer *layer;
//
//- (void)beganScan;

@end
