//
//  ZJBaseTableViewCell.h
//  ZJTest
//
//  Created by ZJ on 2019/4/4.
//  Copyright © 2019 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJBaseTableViewCell : UITableViewCell

/*
 同步系统字体，默认为NO
 */
@property (nonatomic, assign) BOOL keepSystemDefaultFont;
@property (nonatomic, assign) CGFloat iconCornerRadius;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
