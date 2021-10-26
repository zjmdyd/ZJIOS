//
//  ZJKeyboardManager.h
//  HeLiCommunity
//
//  Created by ZJ on 2019/8/22.
//  Copyright © 2019 HY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJKeyboardManager : NSObject

+ (instancetype)shareInstance;
@property (nonatomic, assign) CGFloat keyboardOffsetY;
@property (nonatomic, assign) BOOL enable;

@end

NS_ASSUME_NONNULL_END
