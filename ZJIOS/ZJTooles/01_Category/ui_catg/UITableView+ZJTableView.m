//
//  UITableView+ZJTableView.m
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import "UITableView+ZJTableView.h"

#define kSwitchEvent @"switchEvent:"
#define kSwitchAction NSSelectorFromString(kSwitchEvent)

#define kButtonEvent @"buttonEvent:"
#define kButtonAction NSSelectorFromString(kButtonEvent)

@implementation UITableView (ZJTableView)

+ (UISwitch *)accessorySwitchWithTarget:(id)target {
    UISwitch *sw = [[UISwitch alloc] init];
    BOOL resp =  [target respondsToSelector:kSwitchAction];
    NSLog(@"resp = %d", resp);
    if (target) {
        [sw addTarget:target action:kSwitchAction forControlEvents:UIControlEventValueChanged];
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
        [btn addTarget:target action:kButtonAction forControlEvents:UIControlEventValueChanged];
    }
    
    return btn;
}

@end
