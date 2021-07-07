//
//  ZJIconTextCollectionViewCell.h
//  HeLiCommunity
//
//  Created by ZJ on 2019/6/19.
//  Copyright © 2019 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZJIconTextCollectionViewCell;

@protocol ZJIconTextCollectionViewCellDelegate <NSObject>

- (void)iconTextCollectionViewCellDidClickDeleteButton:(ZJIconTextCollectionViewCell *)cell;

@end

@interface ZJIconTextCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) ZJCollectionViewItemType itemType;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *iconPath;
@property (nonatomic, copy) UIColor *textColor;
@property (nonatomic, assign) BOOL enableEdit;
@property (nonatomic, assign) BOOL enableDelete;
@property (nonatomic, assign) CGFloat textOffsetCenterY;
@property (nonatomic, assign) UIEdgeInsets iconEdgeInsets;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) NSInteger numberOfLine;
@property (nonatomic, assign) CGFloat textCornerRadius;
@property (nonatomic, assign) CGFloat textBorderWidth;
@property (nonatomic, strong) UIColor *textBorderColor;
@property (nonatomic, assign) UIEdgeInsets textBorderEdgeInsets;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, weak) id<ZJIconTextCollectionViewCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) NSString *placeholdIcon;

@end

NS_ASSUME_NONNULL_END
