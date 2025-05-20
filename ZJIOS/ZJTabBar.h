//
//  ZJTabBar.h
//  ZJIOS
//
//  Created by Zengjian on 2025/5/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJTabBar : UITabBar

@property (nonatomic, strong) UIButton *centerBtn;

- (instancetype)initWithImageName:(NSString *)imgName;

@end

NS_ASSUME_NONNULL_END
