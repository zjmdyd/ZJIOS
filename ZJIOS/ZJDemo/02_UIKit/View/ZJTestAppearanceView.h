//
//  ZJTestAppearanceView.h
//  ZJIOS
//
//  Created by issuser on 2022/4/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJTestAppearanceView : UIView

@property (nonatomic, strong) UIColor *leftColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *rightColor UI_APPEARANCE_SELECTOR;

@end

NS_ASSUME_NONNULL_END
