//
//  UIViewController+ZJViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/7/6.
//

#import "UIViewController+ZJViewController.h"
#import <LinkPresentation/LinkPresentation.h>

@implementation UIViewController (ZJViewController)

- (UIViewController *)preControllerWithIndex:(NSUInteger)index {
    NSArray *ary = self.navigationController.viewControllers;
    if (index > ary.count - 1) {
        index = ary.count - 1;
    }
    return ary[ary.count - 1 - index];
}

- (void)popToVCWithIndex:(NSUInteger)index {
    NSArray *arys = self.navigationController.viewControllers;
    if (index > arys.count - 1) {
        index = arys.count - 1;
    }
    [self.navigationController popToViewController:arys[index] animated:YES];
}

- (void)popToVCWithName:(NSString *)name {
    [self popToVCWithName:name isNib:NO];
}

- (void)popToVCWithName:(NSString *)name isNib:(BOOL)isNib {
    if ([self isKindOfClass:NSClassFromString(name)]) {
        return;
    }
    
    BOOL hasMatch = NO;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(name)]) {
            [self.navigationController popToViewController:vc animated:YES];
            hasMatch = YES;
            return;
        }
    }
    if (!hasMatch) {
        if (isNib) {
            [self showVCWithNibName:name];
        }else {
            [self showVCWithName:name];
        }
    }
}

#pragma mark - show-nib
- (void)showVCWithNibName:(NSString *)name {
    [self showVCWithNibName:name title:@""];
}

- (void)showVCWithNibName:(NSString *)name title:(NSString *)title {
    UIViewController *vc = [UIViewController createVCWithNibName:name title:title];
    [self showViewController:vc sender:nil];
}

- (void)showDetailVCWithNibName:(NSString *)name {
    [self showDetailVCWithNibName:name title:@""];
}

- (void)showDetailVCWithNibName:(NSString *)name title:(NSString *)title {
    UIViewController *vc = [UIViewController createVCWithNibName:name title:title];
    [self showDetailViewController:vc sender:nil];
}

- (void)presentVCWithNibName:(NSString *)name {
    [self presentVCWithNibName:name title:@""];
}

- (void)presentVCWithNibName:(NSString *)name title:(NSString *)title {
    UIViewController *vc = [UIViewController createVCWithNibName:name title:title];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

+ (UIViewController *)createVCWithNibName:(NSString *)name {
    return [self createVCWithNibName:name title:@""];
}

+ (UIViewController *)createVCWithNibName:(NSString *)name title:(NSString *)title {
    UIViewController *vc = [((UIViewController *)[NSClassFromString(name) alloc]) initWithNibName:name bundle:nil];
    vc.title = title;
    return vc;
}

- (void)showVCWithName:(NSString *)name {
    [self showVCWithName:name title:@"" style:UITableViewStyleGrouped hidesBottom:YES];
}

- (void)showVCWithName:(NSString *)name title:(NSString *)title {
    [self showVCWithName:name title:title style:UITableViewStyleGrouped hidesBottom:YES];
}

- (void)showVCWithName:(NSString *)name title:(NSString *)title style:(UITableViewStyle)style hidesBottom:(BOOL)hidden {
    ZJCtrlConfig *config = [ZJCtrlConfig new];
    config.vcName = name;
    config.style = style;
    config.hiddenBottom = hidden;
    config.title = title;
    [self showVCWithConfig:config];
}

- (void)showVCWithConfig:(ZJCtrlConfig *)ctrlConfig {
    UIViewController *vc = [UIViewController createVCWithConfig:ctrlConfig];
    if (vc) {
        [self showViewController:vc sender:nil];
    }else {
        NSLog(@"创建控制器%@失败", ctrlConfig.vcName);
    }
}

+ (UIViewController *)createVCWithConfig:(ZJCtrlConfig *)ctrlConfig {
    NSString *vcName = ctrlConfig.vcName;
    if ([vcName isKindOfClass:[NSString class]] && vcName.length) {
        UIViewController *vc = [NSClassFromString(vcName) alloc];
        if ([vc isKindOfClass:[UITableViewController class]]) {
            vc = [(UITableViewController *)vc initWithStyle:ctrlConfig.style];
        }else {
            vc = [vc init];
        }
        if(!vc) return nil;
        
        NSString *title = ctrlConfig.title;
        if ([title isKindOfClass:[NSString class]] && title.length) {
            vc.title = title;
        }
        
        UIColor *color = ctrlConfig.vcBackgroundColor;
        if ([color isKindOfClass:[UIColor class]]) {
            vc.view.backgroundColor = color;
        }
        vc.hidesBottomBarWhenPushed = ctrlConfig.hiddenBottom;
        
        return vc;
    }
    
    return nil;
}

#pragma mark - 根据控制器名字创建控制器

+ (UIViewController *)createVCWithName:(NSString *)name {
    return [self createVCWithName:name title:@"" style:UITableViewStyleGrouped hidesBottom:NO];
}

+ (UIViewController *)createVCWithName:(NSString *)name title:(NSString *)title {
    return [self createVCWithName:name title:title style:UITableViewStyleGrouped hidesBottom:NO];
}

+ (UIViewController *)createVCWithName:(NSString *)name title:(NSString *)title style:(UITableViewStyle)style {
    return [self createVCWithName:name title:title style:UITableViewStyleGrouped hidesBottom:NO];
}

+ (UIViewController *)createVCWithName:(NSString *)name title:(NSString *)title style:(UITableViewStyle)style hidesBottom:(BOOL)hidden {
    ZJCtrlConfig *config = [ZJCtrlConfig new];
    config.vcName = name;
    config.style = style;
    config.hiddenBottom = hidden;
    config.title = title;
    return [self createVCWithConfig:config];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - UIBarButtonItem

#define kBarItemEvent @"barItemAction:"
#define kBarItemAction NSSelectorFromString(kBarItemEvent)

- (void)barItemAction:(UIBarButtonItem *)sender {
    
}

- (UIBarButtonItem *)barbuttonWithSystemType:(UIBarButtonSystemItem)type {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:type target:self action:kBarItemAction];
    
    return item;
}

- (UIBarButtonItem *)barbuttonWithTitle:(NSString *)title {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:kBarItemAction];
    
    return item;
}

- (UIBarButtonItem *)barButtonWithImageName:(NSString *)imgName {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:kBarItemAction];
    
    return item;
}

- (NSArray<UIBarButtonItem *> *)barButtonWithImageNames:(NSArray *)imgNames {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < imgNames.count; i++) {
        UIBarButtonItem *item = [self barButtonWithImageName:imgNames[i]];
        item.tag = i;
        [array addObject:item];
    }
    
    return [array copy];
}

/*
 系统rightBarButtonItems
 <_UIButtonBarStackView: 0x7b5000003600; frame = (285 0; 97 44); layer = <CALayer: 0x7b0800062c80>> buttonBar=0x7b3c00046050
 Printing description of $40:
 <_UIButtonBarButton: 0x7b5400026980; frame = (0 0; 46 44); tintColor = <UIDynamicCatalogSystemColor: 0x7b1000055f00; name = systemBlueColor>; gestureRecognizers = <NSArray: 0x7b0c0011fa30>; layer = <CALayer: 0x7b08002561c0>>
 Printing description of $41:
 <_UIModernBarButton: 0x7b5c00047500; frame = (11 9.66667; 24 24); opaque = NO; userInteractionEnabled = NO; layer = <CALayer: 0x7b0800020fa0>>
 Printing description of $42:
 <_UIButtonBarButton: 0x7b5400026e80; frame = (54 0; 43 44); tintColor = <UIDynamicCatalogSystemColor: 0x7b1000055f00; name = systemBlueColor>; gestureRecognizers = <NSArray: 0x7b0c00102300>; layer = <CALayer: 0x7b08002c0900>>
 Printing description of $43:
 <_UIModernBarButton: 0x7b5c00047880; frame = (11 9.66667; 24 24); opaque = NO; userInteractionEnabled = NO; layer = <CALayer: 0x7b0800024120>>
 
 // 减少自定义view的宽度来适配x轴的偏移量
 <_UIButtonBarStackView: 0x7b500006b000; frame = (277 0; 97 44); layer = <CALayer: 0x7b0800060bc0>> buttonBar=0x7b3c0003d860
 // 和系统的origin.x一样，但宽度不一样
 <_UIButtonBarStackView: 0x7b5000061800; frame = (285 0; 89 44); layer = <CALayer: 0x7b0800060bc0>> buttonBar=0x7b3c0004d850
 
 
 自定义UIBarButtonItem和使用系统的UIBarButtonItem会出现与x方向上的偏移
 */
- (UIBarButtonItem *)barButtonItemWithCustomViewWithImageNames:(NSArray *)images {
    CGFloat itemWidth = 46, btnWidth = 24;
    CGFloat marginX = 8, paddingX = 11, originY = 9.66667;
    CGFloat adjust = 8+3;    // 修正值,调整自定义item与系统方法创建的item与屏幕边距的差别,8为x轴偏移,3为btn宽度调整
    NSInteger count = images.count;
    CGFloat width = itemWidth*count + marginX*(count-1)-adjust;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
    for (int i = 0; i < count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.tag = i;
        btn.frame = CGRectMake(width - (itemWidth*(i+1) + marginX*i) + adjust + paddingX, originY, btnWidth, btnWidth); // 最右边是第0个
        [btn setImage:[[UIImage imageNamed:images[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [btn addTarget:self action:kBarItemAction forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    return item;
}

#pragma mark - alert

/* UIAlertController改标题颜色
 [[alert valueForKey:@"alertController"] setValue:[@"aa" attrWithForegroundColor:[UIColor redColor]] forKey:@"attributedTitle"];
 */
- (void)alertFunc:(ZJAlertObject *)object alertCompl:(AlertActionCompl)callBack {
    UIAlertController *ctrl = [UIAlertController alertControllerWithTitle:object.title message:object.msg preferredStyle:object.alertCtrlStyle];
    NSUInteger count = object.actTitles.count;
    for (int i = 0; i < count; i++) {
        UIAlertActionStyle style;
        if (i == object.cancelIndex && object.needCancel) {
            style = UIAlertActionStyleCancel;
        }else if (i == object.destructiveIndex && object.needDestructive) {
            style = UIAlertActionStyleDestructive;
        }else {
            style = UIAlertActionStyleDefault;
        }
        NSString *title = object.actTitles[i];
        ZJAlertAction *act = [ZJAlertAction actionWithTitle:title style:style handler:^(UIAlertAction * _Nonnull action) {
            callBack((ZJAlertAction *)action, ctrl.textFields);
        }];
        act.tag = i;
        if (object.needSetTitleColor) {
            [act setValue:object.actTitleColors[i] forKey:@"_titleTextColor"];
        }
        [ctrl addAction:act];
    }
    //
    if (object.alertCtrlStyle == UIAlertControllerStyleAlert) {
        for (int i = 0; i < object.textFieldConfigs.count; i++) {
            [ctrl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                ZJTextInputConfig *config = object.textFieldConfigs[i];
                textField.tag = config.tag;
                textField.text = config.text;
                textField.placeholder = config.placehold;
                textField.secureTextEntry = config.secureText;
                textField.textAlignment = config.textAlignment;
                textField.keyboardType = config.keyboardType;
                textField.textColor = config.textColor;
                textField.font = config.font;
                NSLog(@"textField1 = %@", textField);
            }];
        }
    }
    
    [self presentViewController:ctrl animated:YES completion:nil];
}

#pragma mark - 系统分享

/**
 系统分享
 */
- (void)systemShareWithIcon:(NSString *)icon text:(NSString *)text url:(NSString *)url {
    
    
    //分享的url
    //    NSURL *urlToShare;
    //    if (url.length) {
    //        urlToShare = [NSURL URLWithString:url];
    //    }
    //    分享的url
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //分享的图片
        UIImage *imageToShare;
        if (icon.length) {
            imageToShare = [UIImage imageNamed:icon];
        }
        //分享的标题
        NSString *textToShare;
        if (text.length) {
            textToShare = text;
        }else {
            textToShare = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
        }
        NSURL *urlToShare;
        if (url.length) {
            NSLog(@"currentThread = %@", [NSThread currentThread]);
            urlToShare = [NSURL URLWithString:url];
        }
        //在这里 如果想分享图片 就把图片添加进去  文字什么的加上
        NSMutableArray *activityItems = @[textToShare].mutableCopy;
        if (imageToShare) {
            [activityItems addObject:imageToShare];
        }
        if (urlToShare) {
            [activityItems addObject:urlToShare];
        }
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        
        //不出现在活动项目
        activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:activityVC animated:YES completion:nil];
        });
        // 分享之后的回调
        activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            if (completed) {
                NSLog(@"completed");    //分享 成功
            } else  {
                NSLog(@"cancled");      //分享 取消
            }
            NSLog(@"activityError = %@", activityError);
        };
    });
    
    /*
     ‌activityItems‌
     
     ‌‌类型‌：NSArray
     ‌‌作用‌：存储待分享或操作的数据集合，支持多种数据类型混合：
     NSString（文本内容）
     UIImage（图片资源）
     NSURL（链接或文件路径）
     NSData（二进制数据）
     其他符合 UIActivityItemSource 协议的对象
     
     applicationActivities‌
     
     ‌‌类型‌：NSArray<UIActivity *>
     ‌‌作用‌：声明应用支持的自定义分享服务（如第三方登录、内部功能扩展），需继承 UIActivity 实现自定义行为；若无需自定义则传 nil
     示例:
     CustomActivity *customActivity = [[CustomActivity alloc] initWithTitle:@"自定义服务"];
     NSArray *activities = @[customActivity];
    */
}

@end
