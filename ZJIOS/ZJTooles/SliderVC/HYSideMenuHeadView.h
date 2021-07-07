//
//  HYSideMenuHeadView.h
//  SportWatch
//
//  Created by ZJ on 3/17/17.
//  Copyright © 2017 ZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYSideMenuHeadView;

@protocol HYSideMenuHeadViewDelegate <NSObject>

- (void)sideMenuHeadViewDidSelectHeadView:(HYSideMenuHeadView *)view;

@end

@interface HYSideMenuHeadView : UIView

@property (nonatomic, copy) NSString *imgName;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, weak) id <HYSideMenuHeadViewDelegate> delegate;

@end
