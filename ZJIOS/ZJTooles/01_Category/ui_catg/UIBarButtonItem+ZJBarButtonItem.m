//
//  UIBarButtonItem+ZJBarButtonItem.m
//  ZJIOS
//
//  Created by Zengjian on 2021/7/5.
//

#import "UIBarButtonItem+ZJBarButtonItem.h"

@implementation UIBarButtonItem (ZJBarButtonItem)

+ (UIBarButtonItem *)barbuttonWithCustomView:(UIView *)view {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    return item;
}

@end
