//
//  UIDevice+spe.h
//  spokenenglish
//
//  Created by linziyuan on 2017/11/29.
//  Copyright © 2017年 creative. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (spe)

/// The device's machine model.  e.g. "iPhone6,1" "iPad4,6"
/// @see http://theiphonewiki.com/wiki/Models
@property (nullable, nonatomic, readonly) NSString *speMachineModel;

/// The device's machine model name. e.g. "iPhone 5s" "iPad mini 2"
/// @see http://theiphonewiki.com/wiki/Models
@property (nullable, nonatomic, readonly) NSString *speMachineModelName;


+ (NSString *_Nullable)currentDate;
+ (NSString *_Nullable)libraryCachesFilePathWithName:(NSString *_Nullable)fileName;
+ (NSString *_Nullable)carrierName;
+ (NSString *_Nullable)deviceSoftVersion;
+ (NSString *_Nullable)deviceHardVersion;
+ (NSString *_Nullable)openUDID;
+ (NSString *_Nullable)deviceLanguage;
+ (NSString *_Nullable)bizIqCommonFolderPath;
- (BOOL)isJailbroken;
@end
