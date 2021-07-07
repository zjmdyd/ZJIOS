//
//  ZJCollectionBaseTableViewCell.m
//  HeLiCommunity
//
//  Created by ZJ on 2019/6/22.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJCollectionBaseTableViewCell.h"

@interface ZJCollectionBaseTableViewCell()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ZJIconTextCollectionViewCellDelegate>

@end

@implementation ZJCollectionBaseTableViewCell

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.dataSource respondsToSelector:@selector(collectionTableViewCell:numberOfItemsInSection:)]) {
        return [self.dataSource collectionTableViewCell:self numberOfItemsInSection:section];
    }
    
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZJIconTextCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IconTextCollectionViewCell forIndexPath:indexPath];
    cell.indexPath = indexPath;
    
    if ([self.dataSource respondsToSelector:@selector(collectionTableViewCell:textAtIndexPath:)]) {
        cell.text = [self.dataSource collectionTableViewCell:self textAtIndexPath:indexPath];
    }
    if ([self.dataSource respondsToSelector:@selector(collectionTableViewCell:iconPathAtIndexPath:)]) {
        cell.iconPath = [self.dataSource collectionTableViewCell:self iconPathAtIndexPath:indexPath];
    }
    if ([self.dataSource respondsToSelector:@selector(collectionTableViewCell:textColorAtIndexPath:)]) {
        cell.textColor = [self.dataSource collectionTableViewCell:self textColorAtIndexPath:indexPath];
    }
    if ([self.dataSource respondsToSelector:@selector(collectionTableViewCell:textFontAtIndexPath:)]) {
        cell.font = [self.dataSource collectionTableViewCell:self textFontAtIndexPath:indexPath];
    }    
    
    if ([self.dataSource respondsToSelector:@selector(collectionTableViewCell:textAlignmentIndexPath:)]) {
        cell.textAlignment = [self.dataSource collectionTableViewCell:self textAlignmentIndexPath:indexPath];
    }
    if ([self.dataSource respondsToSelector:@selector(collectionTableViewCell:enbaleEditAtIndexPath:)]) {
        cell.enableEdit = [self.dataSource collectionTableViewCell:self enbaleEditAtIndexPath:indexPath];
    }
    if ([self.dataSource respondsToSelector:@selector(collectionTableViewCell:numberOfLine:)]) {
        cell.numberOfLine = [self.dataSource collectionTableViewCell:self numberOfLine:indexPath];
    }
    
    // 删除
    if ([self.dataSource respondsToSelector:@selector(collectionTableViewCell:enableDeleteAtIndexPath:)]) {
        cell.delegate = self;
        cell.enableDelete = [self.dataSource collectionTableViewCell:self enableDeleteAtIndexPath:indexPath];
    }
    
    // text layer
    if ([self.dataSource respondsToSelector:@selector(collectionTableViewCell:textLayerCornerRadiusAtIndexPath:)]) {
        cell.textCornerRadius = [self.dataSource collectionTableViewCell:self textLayerCornerRadiusAtIndexPath:indexPath];
    }
    if ([self.dataSource respondsToSelector:@selector(collectionTableViewCell:textLayerBorderWidthAtIndexPath:)]) {
        cell.textBorderWidth = [self.dataSource collectionTableViewCell:self textLayerBorderWidthAtIndexPath:indexPath];
    }
    if ([self.dataSource respondsToSelector:@selector(collectionTableViewCell:textLayerBorderColorAtIndexPath:)]) {
        cell.textBorderColor = [self.dataSource collectionTableViewCell:self textLayerBorderColorAtIndexPath:indexPath];
    }
    if ([self.dataSource respondsToSelector:@selector(collectionTableViewCell:textLayerEdgeInsetsAtIndexPath:)]) {
        cell.textBorderEdgeInsets = [self.dataSource collectionTableViewCell:self textLayerEdgeInsetsAtIndexPath:indexPath];
    }

    // item类型
    if ([self.dataSource respondsToSelector:@selector(collectionTableViewCell:itemBgColorAtIndexPath:)]) {
        cell.backgroundColor = [self.dataSource collectionTableViewCell:self itemBgColorAtIndexPath:indexPath];
    }
    if ([self.dataSource respondsToSelector:@selector(collectionTableViewCell:itemTypeAtIndexPath:)]) {
        cell.itemType = [self.dataSource collectionTableViewCell:self itemTypeAtIndexPath:indexPath];
    }
    // 约束更新
    if ([self.dataSource respondsToSelector:@selector(collectionTableViewCell:iconEdgeInsetsForItemAtIndexPath:)]) {
        cell.iconEdgeInsets = [self.dataSource collectionTableViewCell:self iconEdgeInsetsForItemAtIndexPath:indexPath];
    }
    if ([self.dataSource respondsToSelector:@selector(collectionTableViewCell:textOffsetCenterYAtIndexPath:)]) {
        cell.textOffsetCenterY = [self.dataSource collectionTableViewCell:self textOffsetCenterYAtIndexPath:indexPath];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(collectionTableViewCell:didSelectItemAtIndexPath:)]) {
        [self.delegate collectionTableViewCell:self didSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataSource respondsToSelector:@selector(collectionTableViewCell:sizeForItemAtIndexPath:)]) {
        return [self.dataSource collectionTableViewCell:self sizeForItemAtIndexPath:indexPath];
    }
    
    return CGSizeZero;
}

#pragma mark - ZJIconTextCollectionViewCellDelegate

- (void)iconTextCollectionViewCellDidClickDeleteButton:(ZJIconTextCollectionViewCell *)cell {
    if ([self.delegate respondsToSelector:@selector(collectionTableViewCell:deleteEventAtIndexPath:)]) {
        [self.delegate collectionTableViewCell:self deleteEventAtIndexPath:cell.indexPath];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
