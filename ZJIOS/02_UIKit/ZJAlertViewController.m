//
//  ZJAlertViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/7/16.
//

#import "ZJAlertViewController.h"
#import "ZJAlertObject.h"
#import "ZJMentionObject.h"

@interface ZJAlertViewController ()

@end

#define  alertSheetEvent @"alertSheetEvent:"

typedef void(^AlertActionCompl)(UIAlertAction *act);


@implementation ZJAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self test];
}

- (void)test {
    ZJAlertObject *obj = [ZJAlertObject new];
    obj.title = @"标题";
    obj.msg = @"message";
    obj.sheetTitles = @[@"第一项"];
    [self alertDefaultFunc:obj alertCompl:^(UIAlertAction *act) {
        NSLog(@"%@", act.title);
    }];
}

/// 自定义
/// @param object 自定义对象
- (void)alertDefaultFunc:(ZJAlertObject *)object alertCompl:(AlertActionCompl)compl {
    UIAlertController *ctrl = [UIAlertController alertControllerWithTitle:object.title message:object.msg preferredStyle:object.alertStyle];
    NSUInteger count = object.needCancel ? object.sheetTitles.count + 1 : object.sheetTitles.count;
    for (int i = 0; i < count; i++) {
        // 当需要cancel时，默认为最后一个title
        UIAlertActionStyle style = object.needCancel && i == count - 1 ? UIAlertActionStyleCancel : UIAlertActionStyleDefault;
        NSString *title = object.needCancel && i == count - 1 ? object.cancelTitle : object.sheetTitles[i];
        UIAlertAction *act = [UIAlertAction actionWithTitle:title style:style handler:^(UIAlertAction * _Nonnull action) {
            compl(action);
        }];
        [ctrl addAction:act];
    }
    [self presentViewController:ctrl animated:YES completion:nil];
}


- (void)alertSheetWithWithAlertObject:(ZJAlertObject *)object alertCompl:(AlertActionCompl *)compl {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
