//
//  ZJNormalViewController.m
//  WeiMing
//
//  Created by ZJ on 13/04/2018.
//  Copyright © 2018 HY. All rights reserved.
//

#import "ZJNormalViewController.h"

#ifdef ZJMMPopupView
#import <MMPopupView/MMSheetView.h>
#endif

#ifdef ZJVPImageCropper
#import "VPImageCropperViewController.h"
#endif

#ifdef ZJMWPhotoBrowser
#import "MWPhotoBrowser.h"
#endif

@interface ZJNormalViewController ()

@end

@implementation ZJNormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)notiRefreshEvent:(NSNotification *)noti {
    self.needRefresh = YES;
}

- (void)setTranslucent:(BOOL)translucent {
#ifdef ZJNaviCtrl
    ((ZJNavigationController *)self.navigationController).needChangeExtendedLayout = !translucent;
    ((ZJNavigationController *)self.navigationController).navigationBarTranslucent = translucent;
#endif
}

- (void)resetValuesWithKVO:(id)obj {
    for (int i = 0; i < self.keys.count; i++) {
        id keys = self.keys[i];
        if ([keys isKindOfClass:[NSArray class]]) {
            for (int j = 0; j < ((NSArray *)keys).count; j++) {
                NSString *key = keys[j];
                [self.values[i] replaceObjectAtIndex:j withObject:[obj valueForKey:key]];
            }
        }else {
            [self.mutableValues replaceObjectAtIndex:i withObject:[obj valueForKey:keys]];
        }
    }
}

- (void)selectItems:(NSArray *)items highlightIndex:(NSInteger)index completion:(SelectItemsCompletion)cmpt {
#ifdef ZJMMPopupView
    MMPopupItemHandler block = ^(NSInteger index) {
        cmpt(index);
    };
    
    NSMutableArray *ary = @[].mutableCopy;
    for (int i = 0; i < items.count; i++) {
        MMPopupItem *item = MMItemMake(items[i], MMItemTypeNormal, block);
        if (i == index) {
            item.highlight = YES;
        }
        [ary addObject:item];
    }
    
    MMSheetViewConfig *config = [MMSheetViewConfig globalConfig];
    config.itemHighlightColor = [UIColor mainColor];
    [[[MMSheetView alloc] initWithTitle:nil items:ary] showWithBlock:nil];
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
#ifdef ZJNaviCtrl
    if (((ZJNavigationController *)self.navigationController).navigationBar.isTranslucent) {
        [self setTranslucent:NO];
    }
#endif
}

#pragma mark - 扫描
//
//- (void)beganScan {
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
//    CGFloat width = 300, y = 100;
//    output.rectOfInterest = CGRectMake((kScreenW-width)/2, y, width, width);
//
//    // 4.添加阅览图层
//    AVCaptureVideoPreviewLayer *layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
//
//    layer.frame = CGRectMake((kScreenW-width)/2, y, width, width);
//    layer.borderWidth = 1.0;
//    [self.view.layer addSublayer:layer];
//    self.layer = layer;
//
//    // 5.开始扫描
//    [session startRunning];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
