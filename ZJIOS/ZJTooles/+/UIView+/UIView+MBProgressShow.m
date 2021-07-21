//
//  UIView+MBProgressShow.m
//  spokenenglish
//
//  Created by 二美子 on 2020/4/15.
//  Copyright © 2020 creative. All rights reserved.
//

#import "UIView+MBProgressShow.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation UIView (MBProgressShow)

- (void)mb_showAutoHideMsg:(NSString *)msg{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = msg;
    hud.detailsLabel.font = [UIFont boldSystemFontOfSize:16.f];
    hud.offset = CGPointMake(0.f, -20);
    [hud hideAnimated:YES afterDelay:1.f];
}

@end
