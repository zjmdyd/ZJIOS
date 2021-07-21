//
//  UIDevice+spe.m
//  spokenenglish
//
//  Created by linziyuan on 2017/11/29.
//  Copyright © 2017年 creative. All rights reserved.
//
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <sys/utsname.h>
#import <sys/sysctl.h>
#import "OpenUDID.h"
#import "UIDevice+spe.h"
#import "NSString+pinYin.h"
#import <SAMKeychain/SAMKeychain.h>
#define KCaches    @"Caches"
#define KAppleLanguage                @"AppleLanguages"
#define kBizIQCommonFolderName        @"BizIqCom"


@implementation UIDevice (spe)
+ (NSString *_Nullable)currentDate{
    return [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
}

+ (NSString *_Nullable)libraryCachesFilePathWithName:(NSString *)fileName
{
    NSArray *dicArray            = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *tmpString   = [dicArray objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/%@/%@",tmpString,KCaches,fileName];
}

+ (NSString *_Nullable)bizIqCommonFolderPath
{
    return  [UIDevice libraryCachesFilePathWithName:kBizIQCommonFolderName];
}
+ (NSString *_Nullable)carrierName
{
#if !TARGET_IPHONE_SIMULATOR
    // 程序目标机器均为4.0即以上，因此不需要判断
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier                            = netInfo.subscriberCellularProvider;
    NSString *carrierName                        = carrier.carrierName;
    return carrierName;
#else
    return @"模拟器";
#endif
}

+ (NSString *_Nullable)deviceSoftVersion
{
    return [UIDevice currentDevice].systemVersion;
}
+ (NSString *_Nullable)deviceHardVersion
{
    struct utsname tmpDevice;
    uname(&tmpDevice);
    //    char* machine =  tmpDevice.machine;
    return [NSString stringWithUTF8String:tmpDevice.machine];
}
+ (NSString *_Nullable)openUDID{
    NSString * openUDID = [SAMKeychain passwordForService:@"com.pep.spokenenglish.service" account:@"com.pep.spokenenglish.openUDID"];
    if (openUDID == nil || (openUDID.length == 0)) {
        openUDID = [OpenUDID value];
        [SAMKeychain setPassword:openUDID forService:@"com.pep.spokenenglish.service" account:@"com.pep.spokenenglish.openUDID"];
    }
    return openUDID;
}

+ (NSString *_Nullable)deviceLanguage
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:KAppleLanguage] objectAtIndex:0];
}

//+ (BOOL)isiPhone5
//{
//    return  (fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)568 ) < DBL_EPSILON);
//}

- (BOOL)isJailbroken
{
    if ([self isSimulator]) return NO; // Dont't check simulator
    
    // iOS9 URL Scheme query changed ...
    // NSURL *cydiaURL = [NSURL URLWithString:@"cydia://package"];
    // if ([[UIApplication sharedApplication] canOpenURL:cydiaURL]) return YES;
    
    NSArray *paths = @[@"/Applications/Cydia.app",
                       @"/private/var/lib/apt/",
                       @"/private/var/lib/cydia",
                       @"/private/var/stash"];
    for (NSString *path in paths) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) return YES;
    }
    
    FILE *bash = fopen("/bin/bash", "r");
    if (bash != NULL) {
        fclose(bash);
        return YES;
    }
    NSString *path = [NSString stringWithFormat:@"/private/%@", [NSString spe_stringWithUUID]];
    if ([@"test" writeToFile : path atomically : YES encoding : NSUTF8StringEncoding error : NULL]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        return YES;
    }
    
    return NO;
}
- (BOOL)isSimulator {
#if TARGET_OS_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

- (NSString *)speMachineModel {
    static dispatch_once_t one;
    static NSString *model;
    dispatch_once(&one, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        model = [NSString stringWithUTF8String:machine];
        free(machine);
    });
    return model;
}

- (NSString *)speMachineModelName {
    static dispatch_once_t one;
    static NSString *name;
    dispatch_once(&one, ^{
        NSString * model = [self speMachineModel];
        if (!model) return;
        NSDictionary *dic = @{
                              @"iPod1,1" : @"iPod touch 1",
                              @"iPod2,1" : @"iPod touch 2",
                              @"iPod3,1" : @"iPod touch 3",
                              @"iPod4,1" : @"iPod touch 4",
                              @"iPod5,1" : @"iPod touch 5",
                              @"iPod7,1" : @"iPod touch 6",
                              
                              @"iPhone1,1" : @"iPhone 1G",
                              @"iPhone1,2" : @"iPhone 3G",
                              @"iPhone2,1" : @"iPhone 3GS",
                              @"iPhone3,1" : @"iPhone 4 (GSM)",
                              @"iPhone3,2" : @"iPhone 4",
                              @"iPhone3,3" : @"iPhone 4 (CDMA)",
                              @"iPhone4,1" : @"iPhone 4S",
                              @"iPhone5,1" : @"iPhone 5",
                              @"iPhone5,2" : @"iPhone 5",
                              @"iPhone5,3" : @"iPhone 5c",
                              @"iPhone5,4" : @"iPhone 5c",
                              @"iPhone6,1" : @"iPhone 5s",
                              @"iPhone6,2" : @"iPhone 5s",
                              @"iPhone7,1" : @"iPhone 6 Plus",
                              @"iPhone7,2" : @"iPhone 6",
                              @"iPhone8,1" : @"iPhone 6s",
                              @"iPhone8,2" : @"iPhone 6s Plus",
                              @"iPhone8,4" : @"iPhone SE",
                              @"iPhone9,1" : @"iPhone 7",
                              @"iPhone9,2" : @"iPhone 7 Plus",
                              @"iPhone9,3" : @"iPhone 7",
                              @"iPhone9,4" : @"iPhone 7 Plus",
                              @"iPhone10,1": @"iPhone 8",
                              @"iPhone10,2": @"iPhone 8 Plus",
                              @"iPhone10,4": @"iPhone 8",
                              @"iPhone10,5": @"iPhone 8 Plus",
                              @"iPhone10,3": @"iPhone X",
                              @"iPhone10,6": @"iPhone X",
                              @"iPhone11,8": @"iPhone XR",
                              @"iPhone11,2": @"iPhone XS",
                              @"iPhone11,4": @"iPhone XS Max",
                              @"iPhone11,6": @"iPhone XS Max",
                              
                              @"iPad1,1" : @"iPad 1",
                              @"iPad2,1" : @"iPad 2 (WiFi)",
                              @"iPad2,2" : @"iPad 2 (GSM)",
                              @"iPad2,3" : @"iPad 2 (CDMA)",
                              @"iPad2,4" : @"iPad 2",
                              @"iPad2,5" : @"iPad mini 1",
                              @"iPad2,6" : @"iPad mini 1",
                              @"iPad2,7" : @"iPad mini 1",
                              @"iPad3,1" : @"iPad 3 (WiFi)",
                              @"iPad3,2" : @"iPad 3 (4G)",
                              @"iPad3,3" : @"iPad 3 (4G)",
                              @"iPad3,4" : @"iPad 4",
                              @"iPad3,5" : @"iPad 4",
                              @"iPad3,6" : @"iPad 4",
                              @"iPad4,1" : @"iPad Air",
                              @"iPad4,2" : @"iPad Air",
                              @"iPad4,3" : @"iPad Air",
                              @"iPad4,4" : @"iPad mini 2",
                              @"iPad4,5" : @"iPad mini 2",
                              @"iPad4,6" : @"iPad mini 2",
                              @"iPad4,7" : @"iPad mini 3",
                              @"iPad4,8" : @"iPad mini 3",
                              @"iPad4,9" : @"iPad mini 3",
                              @"iPad5,1" : @"iPad mini 4",
                              @"iPad5,2" : @"iPad mini 4",
                              @"iPad5,3" : @"iPad Air 2",
                              @"iPad5,4" : @"iPad Air 2",
                              @"iPad6,3" : @"iPad Pro (9.7 inch)",
                              @"iPad6,4" : @"iPad Pro (9.7 inch)",
                              @"iPad6,7" : @"iPad Pro (12.9 inch)",
                              @"iPad6,8" : @"iPad Pro (12.9 inch)",
                              @"iPad6,11": @"iPad (5th generation)",
                              @"iPad6,12": @"iPad (5th generation)",
                              @"iPad7,1" : @"iPad Pro (12.9-inch, 2nd generation)",
                              @"iPad7,2" : @"iPad Pro (12.9-inch, 2nd generation)",
                              @"iPad7,3" : @"iPad Pro (10.5-inch)",
                              @"iPad7,4" : @"iPad Pro (10.5-inch)",
                              @"iPad7,5" : @"iPad (6th generation)",
                              @"iPad7,6" : @"iPad (6th generation)",
                              
                              @"AppleTV2,1" : @"Apple TV 2",
                              @"AppleTV3,1" : @"Apple TV 3",
                              @"AppleTV3,2" : @"Apple TV 3",
                              @"AppleTV5,3" : @"Apple TV 4",
                              
                              @"i386" : @"Simulator x86",
                              @"x86_64" : @"Simulator x64",
                              };
        name = dic[model];
        if (!name) name = model;
    });
    return name;
}


@end
