//
//  ZJShapeLayer.h
//  ZJIOS
//
//  Created by issuser on 2022/5/16.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, UIBorderSideType) {
    UIBorderSideTypeAll  = 0,
    UIBorderSideTypeTop = 1 << 0,
    UIBorderSideTypeBottom = 1 << 1,
    UIBorderSideTypeLeft = 1 << 2,
    UIBorderSideTypeRight = 1 << 3,
};

@interface ZJShapeLayer : CAShapeLayer

@property (nonatomic, assign) UIBorderSideType borderType;

@end

NS_ASSUME_NONNULL_END
