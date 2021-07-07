//
//  UIGestureRecognizer+ZJGestureRecognizer.h
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, Direction) {
    DirectionOfNoMove,
    DirectionOfUp,
    DirectionOfDown,
    DirectionOfLeft,
    DirectionOfRight,
};

@interface UIGestureRecognizer (ZJGestureRecognizer)

+ (Direction)direction:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end

NS_ASSUME_NONNULL_END
