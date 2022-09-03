//
//  ZJLayoutDefines.h
//  ZJTest
//
//  Created by ZJ on 2019/4/4.
//  Copyright © 2019 HY. All rights reserved.
//
#import "UIApplication+ZJApplication.h"

#ifndef ZJLayoutDefines_h
#define ZJLayoutDefines_h

#ifndef Window
#define Window [UIApplication sharedApplication].window
#endif

#ifndef KeyWindow
#define KeyWindow [UIApplication sharedApplication].keyWindow
#endif

#ifndef kScreenW
#define kScreenW    ([UIScreen mainScreen].bounds.size.width)
#endif

#ifndef kScreenH
#define kScreenH    ([UIScreen mainScreen].bounds.size.height)
#endif

#ifndef kIsAboveI5
#define kIsAboveI5 (kScreenW > 320)     // 是否是iPhone5以上的手机
#endif

#ifndef kIsIplus
#define kIsIplus (kScreenW > 375)       // 是否是plus系列
#endif

#ifndef kIsIphoneX
#define kIsIphoneX (kScreenH > 736)     // 是否是iphoneX系列
#endif

#ifndef kIsIphoneXMax
#define kIsIphoneXMax (kScreenH > 812)  // 是否是iphoneX Max系列
#endif

#ifndef kIsIPadPro12_9
#define kIsIPadPro12_9 (kScreenH >= 1366)   // 是否是12.9英寸的iPad
#endif

#ifndef kIsIPadMini
#define kIsIPadMini (kScreenW < 745)        // kIsIPadMini:744,1133
#endif

#ifndef kIsIPad9_7
#define kIsIPad9_7 (kScreenW < 769 && kScreenH < 1025)        // kIsIPad9_7:768,1024
#endif

#ifndef kIsIPadMini
#define kIsIPadMini (kScreenW < 745)        // kIsIPadMini:744,1133
#endif

#ifndef kIsIPad12_9
#define kIsIPad12_9 (kScreenW > 1023 && kScreenH > 1365)        // kIsIPad12_9:1024,1366
#endif

#ifndef kStatusBarH
#define kStatusBarH [UIApplication getStatusBarHight]
#endif

//#ifndef kStatusBarH
//#define kStatusBarH 20
//#endif

#ifndef kNaviBarHeight
#define kNaviBarHeight 44
#endif

#ifndef kTabBarHeight
#define kTabBarHeight (kIsIphoneX ? 83 : 49)
#endif

#ifndef kNaviBottoom
#define kNaviBottoom (kIsIphoneX ? 88 : 64)
#endif

#endif /* ZJLayoutDefines_h */
