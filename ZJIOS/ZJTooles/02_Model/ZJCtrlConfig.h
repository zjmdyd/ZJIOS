//
//  ZJCtrlConfig.h
//  ZJIOS
//
//  Created by issuser on 2021/11/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJCtrlConfig : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *vcName;
@property (nonatomic, assign) BOOL hiddenBottom;
@property (nonatomic, assign) BOOL isGroup;
@property (nonatomic, strong) UIColor *vcBackgroundColor;

@end

NS_ASSUME_NONNULL_END
