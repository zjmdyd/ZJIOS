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
#define ZJNSLog(FORMAT, ...) fprintf(stderr, "%s:%d\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String])
#else       // 发布
#define ZJNSLog(FORMAT, ...) nil
#endif

#endif /* ZJFuncDefine_h */
