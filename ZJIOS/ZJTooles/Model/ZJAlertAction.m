//
//  ZJAlertAction.m
//  ZJIOS
//
//  Created by issuser on 2021/8/27.
//

#import "ZJAlertAction.h"

@implementation ZJAlertAction

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    
    [self setValue:_titleColor forKey:@"_titleTextColor"];
}

@end
