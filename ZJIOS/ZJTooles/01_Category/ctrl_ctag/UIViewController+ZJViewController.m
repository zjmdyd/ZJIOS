//
//  UIViewController+ZJViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/7/6.
//

#import "UIViewController+ZJViewController.h"

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

// show-nib
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

+ (UIViewController *)createVCWithName:(NSString *)name {
    return [self createVCWithName:name title:@"" hidesBottom:YES style:UITableViewStyleGrouped];
}

+ (UIViewController *)createVCWithName:(NSString *)name title:(NSString *)title {
    return [self createVCWithName:name title:title hidesBottom:YES style:UITableViewStyleGrouped];
}

+ (UIViewController *)createVCWithName:(NSString *)name title:(NSString *)title hidesBottom:(BOOL)hidden {
    return [self createVCWithName:name title:title hidesBottom:hidden style:UITableViewStyleGrouped];
}

+ (UIViewController *)createVCWithName:(NSString *)name title:(NSString *)title hidesBottom:(BOOL)hidden style:(UITableViewStyle)style {
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
 <_UIButtonBarStackView: 0x7fbc6773bc10; frame = (259 0; 100 44); layer = <CALayer: 0x600000f004c0>> buttonBar=0x600003796940
 <_UIButtonBarStackView: 0x7fe96c732f30; frame = (270 0; 97 44); layer = <CALayer: 0x600002f51040>> buttonBar=0x6000010fe490
自定义UIBarButtonItem和使用系统的UIBarButtonItem会出现与x方向上的偏移
 */
- (UIBarButtonItem *)barButtonItemWithCustomViewWithImageNames:(NSArray *)images {
    CGFloat itemWidth = 46, btnWidth = 24;
    CGFloat offsetX = 8, originX = 11, originY = 9.5;
    CGFloat adjust = 11;    // 修正值,调整自定义item与系统方法创建的item与屏幕边距的差别
    NSInteger count = images.count;
    CGFloat width = itemWidth*count + offsetX*(count-1);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, width-2)];
    for (int i = 0; i < count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.tag = i;
        btn.frame = CGRectMake(width - (itemWidth*(i+1) + offsetX*i) + originX + adjust, originY, btnWidth, btnWidth);
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
    //分享的url
    NSURL *urlToShare;
    if (url.length) {
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
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    //不出现在活动项目
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityVC animated:YES completion:nil];
    // 分享之后的回调
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"completed");    //分享 成功
        } else  {
            NSLog(@"cancled");      //分享 取消
        }
        NSLog(@"activityError = %@", activityError);
    };
}

@end
