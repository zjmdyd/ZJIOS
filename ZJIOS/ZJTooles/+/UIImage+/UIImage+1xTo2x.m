//
//  UIImage+1xTo2x.m
//  KidReading
//
//  Created by telen on 16/2/5.
//  Copyright © 2016年 Creative Knowledge Ltd. All rights reserved.
//

#import "UIImage+1xTo2x.h"
#import <sys/utsname.h>
#import "NSObject+Telen.h"

//-fno-objc-arc

@implementation UIImage(x1xTo2x)

static NSString* UIImage_x1xTo2x_deviceModel = nil;
+(NSString*) machineName
{
    if (UIImage_x1xTo2x_deviceModel == nil) {
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString* deviceString = [NSString stringWithCString:systemInfo.machine
                                                    encoding:NSUTF8StringEncoding];
        UIImage_x1xTo2x_deviceModel = [[UIDevice currentDevice] model];
        if ([deviceString hasPrefix:UIImage_x1xTo2x_deviceModel]) {
            UIImage_x1xTo2x_deviceModel = deviceString;
        }
    }
    return UIImage_x1xTo2x_deviceModel;
}

+(NSString*)getFile:(NSString*)name exNmae:(NSString*)ex deviceSign:(NSString*)dvstr
{
    int scale = [UIScreen mainScreen].scale;
    NSString* nameX = nil;
    NSString* path = nil;
    do {
        NSString* x = scale > 1 ? [NSString stringWithFormat:@"@%@x",@(scale)]: @"";
        nameX = [NSString stringWithFormat:@"%@%@%@",name,x,dvstr];
        path = [[NSBundle mainBundle] pathForResource:nameX ofType:ex];
        if (path) {
            return path;
        }
        nameX = [NSString stringWithFormat:@"%@%@",name,x];
        path = [[NSBundle mainBundle] pathForResource:nameX ofType:ex];
        if (path) {
            return path;
        }
        if (scale <= 1) {
            break;
        }
        scale--;
    } while (YES);
    //
    //Debug
    if (path == nil) {
        //NSLog(@"imageNamed: Cannot Find image %@.%@",name,ex);
        if(name.length >0)NSLog(@"imageNamed: Cannot Find image %@.%@",name,ex);
    }
    //
    return path;
}

+(NSString*)imageNamed_RealPath:(NSString*)name
{
    //
    NSString* path_na = [name stringByDeletingPathExtension];
    NSString* path_ex = [name pathExtension];
    NSString* path = nil;
    if ([[self machineName] hasPrefix:@"iPhone"]) {
        path = [self getFile:path_na exNmae:path_ex deviceSign:@"~iphone"];
    }else{
        path = [self getFile:path_na exNmae:path_ex deviceSign:@"~ipad"];
    }
    //
    return path;
}

+(void)load
{
    [self swizzleClassSelector:@selector(imageNamed:) withClassSelector:@selector(imageNamed_1xto2x:)];
}

+(UIImage*)imageNamed_1xto2x:(NSString*)name
{
//    NSString* path = [self imageNamed_RealPath:name];
//    UIImage* image = [UIImage imageWithContentsOfFile:path];
    UIImage* image = [UIImage imageNamed_1xto2x:name];
    if (image && [[self machineName] hasPrefix:@"iPhone"] && image.scale == 1) {
        UIImage* img = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:UIImageOrientationUp];
        return img;
    }
    return image;
}


@end
