//
//  UIColor+FF.m
//  KidReading
//
//  Created by telen on 15/1/1.
//  Copyright (c) 2015年 Creative Knowledge Ltd. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

//字符串转颜色
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    if (!stringToConvert) {
        return nil;
    }
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return nil;
        //return [UIColor clearColor];
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return nil;
        //return [UIColor clearColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
+(UIColor*)colorWithARGBHexString:(NSString *)stringToConvert{
    if (!stringToConvert) {
        return nil;
    }
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] < 8)
        return [UIColor clearColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *aString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 6;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int a,r, g, b;
    [[NSScanner scannerWithString:aString] scanHexInt:&a];
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:((float) a/225.0f)];
}
//颜色转字符串
+ (NSString *) changeUIColorToRGB:(UIColor *)color
{
    size_t numComponents = CGColorGetNumberOfComponents(color.CGColor);
    if (numComponents == 4) {
        const CGFloat *cs=CGColorGetComponents(color.CGColor);
        NSString *r = [NSString stringWithFormat:@"%@",[self  ToHex_telen:cs[0]*255]];
        NSString *g = [NSString stringWithFormat:@"%@",[self  ToHex_telen:cs[1]*255]];
        NSString *b = [NSString stringWithFormat:@"%@",[self  ToHex_telen:cs[2]*255]];
        return [NSString stringWithFormat:@"#%@%@%@",r,g,b];
    }
    return nil;
}

//颜色转字符串 取 alpha
+ (NSString *)changeUIColorToRGB:(UIColor *)color withAlpha:(CGFloat *)alpha
{
    CGFloat red, green, blue, al;
    if ([color getRed:&red green:&green blue:&blue alpha:&al]) {
        NSString *r = [NSString stringWithFormat:@"%@",[self  ToHex_telen:red*255]];
        NSString *g = [NSString stringWithFormat:@"%@",[self  ToHex_telen:green*255]];
        NSString *b = [NSString stringWithFormat:@"%@",[self  ToHex_telen:blue*255]];
        if(alpha != nil)*alpha = al;
        return [NSString stringWithFormat:@"#%@%@%@",r,g,b];
    }
    return nil;
}

//十进制转十六进制
+ (NSString *)ToHex_telen:(int)tmpid
{
    NSString *endtmp=@"";
    NSString *nLetterValue;
    NSString *nStrat;
    int ttmpig=tmpid%16;
    int tmp=tmpid/16;
    switch (ttmpig)
    {
        case 10:
            nLetterValue =@"A";break;
        case 11:
            nLetterValue =@"B";break;
        case 12:
            nLetterValue =@"C";break;
        case 13:
            nLetterValue =@"D";break;
        case 14:
            nLetterValue =@"E";break;
        case 15:
            nLetterValue =@"F";break;
        default:nLetterValue=[[NSString alloc]initWithFormat:@"%i",ttmpig];
            
    }
    switch (tmp)
    {
        case 10:
            nStrat =@"A";break;
        case 11:
            nStrat =@"B";break;
        case 12:
            nStrat =@"C";break;
        case 13:
            nStrat =@"D";break;
        case 14:
            nStrat =@"E";break;
        case 15:
            nStrat =@"F";break;
        default:nStrat=[[NSString alloc]initWithFormat:@"%i",tmp];
            
    }
    endtmp=[[NSString alloc]initWithFormat:@"%@%@",nStrat,nLetterValue];
    return endtmp;
}

@end
