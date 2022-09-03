//
//  ZJTestRoundView.h
//  ZJIOS
//
//  Created by issuser on 2022/8/4.
//

#import <UIKit/UIKit.h>
#import "ZJAngleObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZJTestRoundView : UIView

@property (nonatomic, strong) NSArray<ZJAngleObject *> *angles;
@property (nonatomic, strong) NSArray *colors;

@end

NS_ASSUME_NONNULL_END
