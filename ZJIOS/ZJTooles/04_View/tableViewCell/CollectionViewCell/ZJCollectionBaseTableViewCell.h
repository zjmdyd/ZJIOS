//
//  ZJCollectionBaseTableViewCell.h
//  HeLiCommunity
//
//  Created by ZJ on 2019/6/22.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJNormalTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZJCollectionViewItemType) {
    ZJCollectionViewItemTypeOfText = 0,
    ZJCollectionViewItemTypeOfIcon,
    ZJCollectionViewItemTypeOfIconText
};


@class ZJCollectionBaseTableViewCell;

@protocol ZJCollectionBaseTableViewCellDataSource <NSObject>

@required

- (NSInteger)collectionTableViewCell:(ZJCollectionBaseTableViewCell *)cell numberOfItemsInSection:(NSInteger)section;

@optional
- (NSInteger)numberOfSectionsInCollectionTableViewCell:(ZJCollectionBaseTableViewCell *)cell;
- (NSString *)collectionTableViewCell:(ZJCollectionBaseTableViewCell *)cell iconPathAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)collectionTableViewCell:(ZJCollectionBaseTableViewCell *)cell textAtIndexPath:(NSIndexPath *)indexPath;
- (UIColor *)collectionTableViewCell:(ZJCollectionBaseTableViewCell *)cell textColorAtIndexPath:(NSIndexPath *)indexPath;
- (UIFont *)collectionTableViewCell:(ZJCollectionBaseTableViewCell *)cell textFontAtIndexPath:(NSIndexPath *)indexPath;
- (NSTextAlignment)collectionTableViewCell:(ZJCollectionBaseTableViewCell *)cell textAlignmentIndexPath:(NSIndexPath *)indexPath;

// text layer
- (CGFloat)collectionTableViewCell:(ZJCollectionBaseTableViewCell *)cell textLayerCornerRadiusAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)collectionTableViewCell:(ZJCollectionBaseTableViewCell *)cell textLayerBorderWidthAtIndexPath:(NSIndexPath *)indexPath;
- (UIColor *)collectionTableViewCell:(ZJCollectionBaseTableViewCell *)cell textLayerBorderColorAtIndexPath:(NSIndexPath *)indexPath;
- (UIEdgeInsets)collectionTableViewCell:(ZJCollectionBaseTableViewCell *)cell textLayerEdgeInsetsAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)collectionTableViewCell:(ZJCollectionBaseTableViewCell *)cell numberOfLine:(NSIndexPath *)indexPath;

- (CGSize)collectionTableViewCell:(ZJCollectionBaseTableViewCell *)cell sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

// item类型
- (ZJCollectionViewItemType)collectionTableViewCell:(ZJCollectionBaseTableViewCell *)cell itemTypeAtIndexPath:(NSIndexPath *)indexPath;
- (UIColor *)collectionTableViewCell:(ZJCollectionBaseTableViewCell *)cell itemBgColorAtIndexPath:(NSIndexPath *)indexPath;

// 约束
- (UIEdgeInsets)collectionTableViewCell:(ZJCollectionBaseTableViewCell *)cell iconEdgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)collectionTableViewCell:(ZJCollectionBaseTableViewCell *)cell textOffsetCenterYAtIndexPath:(NSIndexPath *)indexPath;

// edit textfield
- (BOOL)collectionTableViewCell:(ZJCollectionBaseTableViewCell *)cell enbaleEditAtIndexPath:(NSIndexPath *)indexPath;

// 删除按钮
- (BOOL)collectionTableViewCell:(ZJCollectionBaseTableViewCell *)cell enableDeleteAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol ZJCollectionBaseTableViewCellDelegate <NSObject>

@optional

- (void)collectionTableViewCell:(ZJCollectionBaseTableViewCell *)cell didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionTableViewCell:(ZJCollectionBaseTableViewCell *)cell deleteEventAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZJCollectionBaseTableViewCell : ZJNormalTableViewCell

@property (nonatomic, weak) id <ZJCollectionBaseTableViewCellDataSource> dataSource;
@property (nonatomic, weak) id <ZJCollectionBaseTableViewCellDelegate> delegate;
@property (nonatomic, assign) BOOL pagingEnabled;
@property (nonatomic, assign) BOOL scrollEnabled;
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

@end

NS_ASSUME_NONNULL_END
