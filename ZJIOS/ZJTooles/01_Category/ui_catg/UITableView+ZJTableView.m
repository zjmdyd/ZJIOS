//
//  UITableView+ZJTableView.m
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import "UITableView+ZJTableView.h"

@implementation UITableView (ZJTableView)

+ (UISwitch *)accessorySwitchWithTarget:(id)target {
    UISwitch *sw = [[UISwitch alloc] init];
    SEL s = NSSelectorFromString(@"switchEvent:");
    if (target) {
        [sw addTarget:target action:s forControlEvents:UIControlEventValueChanged];
    }
#ifdef MainColor
    sw.onTintColor = MainColor;
#endif
    return sw;
}

+ (UIButton *)accessoryButtonWithTarget:(id)target title:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 60, 30);
    btn.layer.cornerRadius = 8;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (target) {
        SEL s = NSSelectorFromString(@"buttonEvent:");
        [btn addTarget:target action:s forControlEvents:UIControlEventValueChanged];
    }
    
    return btn;
}

@end
