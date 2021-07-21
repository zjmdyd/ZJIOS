//
//  NSString+pinYin.h
//  123
//
//  Created by ys on 15/11/26.
//  Copyright © 2015年 ys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (pinYin)

@property(nonatomic,readonly)NSString* pinyinWithSign;
@property(nonatomic,readonly)NSString* pinyin;
@property(nonatomic,readonly)NSString* pinyinFirst;

- (NSString *)stringToPinyinWithSign;
- (NSString *)stringToPinyin;
+ (NSString *)spe_stringWithUUID;
@end
