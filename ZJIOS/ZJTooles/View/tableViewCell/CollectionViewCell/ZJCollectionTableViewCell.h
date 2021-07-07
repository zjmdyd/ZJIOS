//
//  ZJCollectionTableViewCell.h
//  HeLiCommunity
//
//  Created by ZJ on 2019/6/19.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJCollectionBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class ZJCollectionTableViewCell;

@protocol ZJCollectionTableViewCellDatasource <NSObject>

@optional
- (UIView *)collectionTableViewCellTopCustomView:(ZJCollectionTableViewCell *)cell;
- (UIView *)collectionTableViewCellBottomCustom:(ZJCollectionTableViewCell *)cell;
- (CGFloat)collectionTableViewCellCornerRadius:(ZJCollectionBaseTableViewCell *)cell;

@end

@interface ZJCollectionTableViewCell : ZJCollectionBaseTableViewCell

@property (nonatomic, assign) CGFloat minimumLineSpacing;       // 默认为10 行间距
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;  // 默认为10 item间距
@property (nonatomic, assign) UIEdgeInsets bgContentInset;
@property (nonatomic, assign) UIEdgeInsets collectContentInset;
@property (nonatomic, strong) UIColor *cellContentBgColor;

@property (nonatomic, weak) id<ZJCollectionTableViewCellDatasource> collectDataSource;

- (void)reload;

@end

NS_ASSUME_NONNULL_END
