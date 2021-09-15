//
//  ZJAlertObject.h
//  KeerZhineng
//
//  Created by ZJ on 2019/2/19.
//  Copyright © 2019 HY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZJTextInputConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZJAlertObject : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, assign) UIAlertControllerStyle alertStyle;
@property (nonatomic, strong) NSArray<NSString *> *actTitles;
@property (nonatomic, strong) NSArray<UIColor *> *actTitleColors;
@property (nonatomic, assign) BOOL needCancel;
@property (nonatomic, assign) BOOL needDestructive;
@property (nonatomic, assign) NSUInteger cancelIndex;
@property (nonatomic, assign) NSUInteger destructiveIndex;
@property (nonatomic, strong) NSArray<ZJTextInputConfig *> *textFieldConfigs;
@property (nonatomic, assign) BOOL needSetTitleColor;

@end

NS_ASSUME_NONNULL_END
