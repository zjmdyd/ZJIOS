//
//  ZJMaskView.h
//  PhysicalDate
//
//  Created by ZJ on 4/27/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJMaskView;

@protocol ZJMaskViewDelegate <NSObject>

- (void)zjMaskViewDidHidden:(ZJMaskView *)maskView;

@end

#ifndef DefaultDuration

#define DefaultDuration 0.5

#endif

#define PickerViewHeight 250

typedef void(^CompletionHandle)(BOOL finish);

@interface ZJMaskView : UIView

/**
 *  控制touch隐藏self, 默认为YES
 */
@property (nonatomic, assign) BOOL touchEnable;
@property (nonatomic, assign) CGFloat maskAlpha;
@property (nonatomic, weak) id<ZJMaskViewDelegate> maskDelegate;

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated completion:(CompletionHandle)completion;

@end
