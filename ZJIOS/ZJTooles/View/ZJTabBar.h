//
//  ZJTabBar.h
//  HeLiCommunity
//
//  Created by ZJ on 2019/7/10.
//  Copyright © 2019 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJTabBar : UITabBar

@property (nonatomic, strong) UIButton *centerBtn;

- (instancetype)initWithImageName:(NSString *)imgName;
@property (nonatomic, assign) BOOL needRotation;

@end

NS_ASSUME_NONNULL_END
