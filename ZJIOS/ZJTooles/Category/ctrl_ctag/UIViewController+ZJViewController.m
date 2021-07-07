//
//  UIViewController+ZJViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/7/6.
//

#import "UIViewController+ZJViewController.h"
#import "ZJMentionObject.h"
//#import "ZJDefine.h"

#define  barItemAction @"barItemAction:"

@implementation UIViewController (ZJViewController)

- (UIViewController *)preControllerWithIndex:(NSInteger)index {
    NSArray *ary = self.navigationController.viewControllers;
    return ary[ary.count - (index + 1)];
}

- (void)popToVCWithIndex:(NSInteger)index {
    NSArray *vcs = self.navigationController.viewControllers;
    [self.navigationController popToViewController:vcs[index] animated:YES];
}

- (void)popToVCWithName:(NSString *)name {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(name)]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UIBarButtonItem

- (UIBarButtonItem *)barbuttonWithSystemType:(UIBarButtonSystemItem)type {
    SEL s = NSSelectorFromString(barItemAction);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:type target:self action:s];
    
    return item;
}

- (UIBarButtonItem *)barbuttonWithTitle:(NSString *)title {
    SEL s = NSSelectorFromString(barItemAction);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:s];
    
    return item;
}

- (UIBarButtonItem *)barButtonWithImageName:(NSString *)imgName {
    SEL s = NSSelectorFromString(barItemAction);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:s];
    
    return item;
}

- (NSArray *)barButtonWithImageNames:(NSArray *)imgNames {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < imgNames.count; i++) {
        UIBarButtonItem *item = [self barButtonWithImageName:imgNames[i]];
        item.tag = i;
        [array addObject:item];
    }
    
    return [array copy];
}

- (UIBarButtonItem *)barButtonItemWithCustomViewWithImageNames:(NSArray *)images {
    SEL sel = NSSelectorFromString(barItemAction);
    
    CGFloat width = 35;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width*images.count+8, width)];
    NSInteger count = images.count;
    if (count > 2) count = 2;
    for (int i = 0; i < count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.tag = i;
        btn.frame = CGRectMake(view.frame.size.width-(width*(i+1) + 8*i), 0, width, width);
        [btn setImage:[[UIImage imageNamed:images[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    return item;
}

#pragma mark - alert
/* UIAlertController改标题颜色
 [[alert valueForKey:@"alertController"] setValue:[@"aa" attrWithForegroundColor:[UIColor redColor]] forKey:@"attributedTitle"];
 */
// input
- (void)alertWithAlertObject:(ZJAlertObject *)object {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:object.title message:object.msg delegate:object.delegate cancelButtonTitle:object.cancelTitle otherButtonTitles:object.otherTitle, nil];
    alert.alertViewStyle = object.alertViewStyle;
    alert.tag = object.tag;
    
    if (alert.alertViewStyle != UIAlertViewStyleDefault) {
        UITextField *tf = [alert textFieldAtIndex:0];
        tf.textAlignment = NSTextAlignmentCenter;
        tf.placeholder = [NSString stringWithFormat:@"请输入%@", object.title];
        tf.keyboardType = object.keyboardType;
        tf.text = object.value;
    }
    
    [alert show];
}

#define  alertSheetEvent @"alertSheetEvent:"

- (void)alertSheetWithWithAlertObject:(ZJAlertObject *)object {
    UIAlertController *ctrl = [UIAlertController alertControllerWithTitle:object.title message:object.msg preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *ary = object.sheetObjects;
    if (ary.count == 0) {
        ary = object.sheetTitles;
    }
    for (int i = 0; i < ary.count; i++) {
        NSString *title;
        if (object.sheetObjects) {
            ZJMentionObject *sheetObj = ary[i];
            title = [NSString stringWithFormat:@"%@(%@)", sheetObj.firstText, sheetObj.secondText];
        }else {
            title = ary[i];
        }
        UIAlertAction *act = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SEL sel = NSSelectorFromString(alertSheetEvent);
            if ([self respondsToSelector:sel]) {
                [self performSelector:sel withObject:@(i)];
            }
        }];
        [ctrl addAction:act];
    }
    
    if (object.needCancel) {
        UIAlertAction *act = [UIAlertAction actionWithTitle:object.cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [ctrl addAction:act];
    }
    [self presentViewController:ctrl animated:YES completion:nil];
}

#pragma mark - 系统分享

/**
 系统分享
 */
- (void)systemShareWithIcon:(NSString *)icon text:(NSString *)text path:(NSString *)path {
    //分享的标题
    NSString *textToShare;
    if (text.length) {
        textToShare = text;
    }else {
        textToShare = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    }
    //分享的图片
    UIImage *imageToShare;
    if (icon.length) {
        imageToShare = [UIImage imageNamed:icon];
    }
    //分享的url
    NSURL *urlToShare;
    if (path.length) {
        urlToShare = [NSURL URLWithString:path];
    }
    //在这里呢 如果想分享图片 就把图片添加进去  文字什么的通上
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
            NSLog(@"completed");
            //分享 成功
        } else  {
            NSLog(@"cancled");
            //分享 取消
        }
        NSLog(@"activityError = %@", activityError);
    };
}

#pragma mark - NSNotificationCenter

- (void)removeNotificationObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
