//
//  UILabel+TLSize.m
//  remind
//
//  Created by Telen on 14-10-14.
//  Copyright (c) 2014年 Telen. All rights reserved.
//

#import "UILabel+TLSize.h"

@implementation UILabel (ContentSize)

- (CGSize)contentSize {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    
    NSDictionary * attributes = @{NSFontAttributeName : self.font,
                                  NSParagraphStyleAttributeName : paragraphStyle};
    
    CGSize maximumLabelSize = CGSizeMake(self.frame.size.width,MAXFLOAT);
    
    CGSize contentSize = [self.text boundingRectWithSize:maximumLabelSize
                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                              attributes:attributes
                                                 context:nil].size;
    contentSize.height += self.font.lineHeight*0.5;
    return contentSize;
}

+ (CGSize)contentSizeForStr:(NSString *)text withRestrainWidth:(CGFloat)width andHeight:(CGFloat)height
{
    return [self contentSizeForStr:text withFont:nil withBreakMode:0 withTestAlignment:0 withRestrainWidth:width andHeight:height];
}

+ (CGSize)contentSizeForStr:(NSString *)text withFont:(UIFont *)font withRestrainWidth:(CGFloat)width andHeight:(CGFloat)height
{
    return [self contentSizeForStr:text withFont:font withBreakMode:0 withTestAlignment:0 withRestrainWidth:width andHeight:height];
}

+ (CGSize)contentSizeForStr:(NSString *)text withFont:(UIFont *)font withBreakMode:(NSLineBreakMode)breakMode withTestAlignment:(NSTextAlignment)textAlignment withRestrainWidth:(CGFloat)width andHeight:(CGFloat)height
{
    UILabel* lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    lb.text = text;
    if(font)lb.font = font;
    if(breakMode!=0)lb.lineBreakMode = breakMode;
    if(textAlignment!=0)lb.textAlignment = textAlignment;
    return [lb contentSize];
}

@end

@implementation UILabel (dynamicSizeMe)

-(float)resizeToFit{
    float height = [self expectedHeight];
    CGRect newFrame = [self frame];
    newFrame.size.height = height;
    [self setFrame:newFrame];
    return newFrame.origin.y + newFrame.size.height;
}

-(float)expectedHeight{
    [self setNumberOfLines:0];
    [self setLineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize expectedLabelSize = [self contentSize];
                                
    return expectedLabelSize.height;
}

@end

