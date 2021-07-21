//
//  UILabel+TLSize.h
//  remind
//
//  Created by Telen on 14-10-14.
//  Copyright (c) 2014年 Telen. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UILabel (ContentSize)

- (CGSize)contentSize;

+ (CGSize)contentSizeForStr:(NSString *)text withRestrainWidth:(CGFloat)width andHeight:(CGFloat)height;

+ (CGSize)contentSizeForStr:(NSString *)text withFont:(UIFont *)font withRestrainWidth:(CGFloat)width andHeight:(CGFloat)height;

+ (CGSize)contentSizeForStr:(NSString *)text withFont:(UIFont *)font withBreakMode:(NSLineBreakMode)breakMode withTestAlignment:(NSTextAlignment)textAlignment withRestrainWidth:(CGFloat)width andHeight:(CGFloat)height;

@end

@interface UILabel (dynamicSizeMe)

-(float)resizeToFit;
-(float)expectedHeight;

@end
