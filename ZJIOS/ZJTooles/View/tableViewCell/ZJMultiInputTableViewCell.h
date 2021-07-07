//
//  ZJMultiInputTableViewCell.h
//  HeLiCommunity
//
//  Created by ZJ on 2019/7/24.
//  Copyright © 2019 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZJMultiInputTableViewCell;

@protocol ZJMultiInputTableViewCellDelegate <NSObject>

- (void)multiInputTableViewCell:(ZJMultiInputTableViewCell *)cell didEndEditAtIndex:(NSInteger)index text:(NSString *)text;

@end

@interface ZJMultiInputTableViewCell : UITableViewCell

@property (nonatomic, weak) id<ZJMultiInputTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
