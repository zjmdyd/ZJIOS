//
//  ZJFuncDefine.h
//  ZJIOS
//
//  Created by issuser on 2021/7/14.
//

#ifndef ZJFuncDefine_h
#define ZJFuncDefine_h

#define kRGBA(r, g, b, a)   [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]
#define UIColorFromHex(s)   [UIColor colorWithRed:(((s&0xFF0000) >> 16))/255.0 green:(((s&0x00FF00) >> 8))/255.0 blue:(s&0x0000FF)/255.0 alpha:1.0]
#define UIColorFromHexA(s, a)   [UIColor colorWithRed:(((s&0xFF0000) >> 16))/255.0 green:(((s&0x00FF00) >> 8))/255.0 blue:(s&0x0000FF)/255.0 alpha:a]

#ifdef DEBUG // 调试
#define ZJNSLog(FORMAT, ...) fprintf(stderr, "%s:%zd\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);
#else       // 发布
#define ZJNSLog(FORMAT, ...) nil
#endif

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define RATIO_H SCREEN_HEIGHT / 1366.0
#define RATIO_W SCREEN_WIDTH / 1024.0
#define XPDockItemWidth 88 * RATIO_W
#define XPDockItemHeight 102 * RATIO_H

#define XPDockHeaderItemHeigt 20 * RATIO_H

#define TIPS_H 562 * RATIO_H
#define TIPS_TOP 96 * RATIO_H
// 平方细体
#define PF_THIN(s) [UIFont fontWithName:NotoSansSC_Thin size:s * RATIO_W]
// 平方字体加粗
#define PF_Medium(s)  [UIFont fontWithName:NotoSansSC_Medium size:s * RATIO_W]
#define PF_Blod(s)  [UIFont fontWithName:NotoSansSC_Bold size:s * RATIO_W]
#define PF_SC(s) [UIFont fontWithName:NotoSansSC_Regular size:s * RATIO_W]

#define PF_Light(s) [UIFont fontWithName:NotoSansSC_Light size:s * RATIO_W]

#endif /* ZJFuncDefine_h */
