//
//  ZJCollectionTableViewCell.m
//  HeLiCommunity
//
//  Created by ZJ on 2019/6/19.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJCollectionTableViewCell.h"

@interface ZJCollectionTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgVewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgVewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgVewTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgVewTopConstraint;

@property (weak, nonatomic) IBOutlet UIView *topCustomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomCustomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCustomConstraint;

@end

@implementation ZJCollectionTableViewCell

@synthesize pagingEnabled = _pagingEnabled;
@synthesize scrollEnabled = _scrollEnabled;
@synthesize scrollDirection = _scrollDirection;

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.topViewHeightConstraint.constant = 0;
    if (self.topCustomView.subviews.count) {
        [[self.topCustomView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    if ([self.collectDataSource respondsToSelector:@selector(collectionTableViewCellTopCustomView:)]) {
        UIView *view = [self.collectDataSource collectionTableViewCellTopCustomView:self];
        if (view) {
            self.topViewHeightConstraint.constant = view.frame.size.height + 20;
            [self.topCustomView addSubview:view];
        }
    }
    
    self.bottomCustomConstraint.constant = 0;
    if (self.bottomCustomView.subviews.count) {
        [[self.bottomCustomView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    if ([self.collectDataSource respondsToSelector:@selector(collectionTableViewCellBottomCustom:)]) {
        UIView *view = [self.collectDataSource collectionTableViewCellBottomCustom:self];
        if (view) {
            self.bottomCustomConstraint.constant = view.frame.size.height + 20;
            [self.bottomCustomView addSubview:view];
        }
    }
    
    self.bgView.layer.cornerRadius = 0;
    if ([self.collectDataSource respondsToSelector:@selector(collectionTableViewCellCornerRadius:)]) {
        self.bgView.layer.cornerRadius = [self.collectDataSource collectionTableViewCellCornerRadius:self];
    }
}

- (void)reload {
    [self.collectionView reloadData];
}

#pragma mark - setter

- (void)setCellContentBgColor:(UIColor *)cellContentBgColor {
    _cellContentBgColor = cellContentBgColor;
    
    self.bgView.backgroundColor = _cellContentBgColor;
}

- (void)setMinimumLineSpacing:(CGFloat)minimumLineSpacing {
    _minimumLineSpacing = minimumLineSpacing;
    
    ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).minimumLineSpacing = minimumLineSpacing;
}

- (void)setMinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing {
    _minimumInteritemSpacing = minimumInteritemSpacing;
    
    ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).minimumInteritemSpacing = _minimumInteritemSpacing;
}

- (void)setBgContentInset:(UIEdgeInsets)bgContentInset {
    _bgContentInset = bgContentInset;
    
    self.bgVewLeadingConstraint.constant = _bgContentInset.left;
    self.bgVewBottomConstraint.constant = _bgContentInset.bottom;
    self.bgVewTrailingConstraint.constant = _bgContentInset.right;
    self.bgVewTopConstraint.constant = _bgContentInset.top;
}

- (void)setCollectContentInset:(UIEdgeInsets)collectContentInset {
    _collectContentInset = collectContentInset;
    
    self.collectionView.contentInset = _collectContentInset;
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;
    
    ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).scrollDirection = _scrollDirection;
}

- (void)setPagingEnabled:(BOOL)pagingEnabled {
    _pagingEnabled = pagingEnabled;
    
    self.collectionView.pagingEnabled = pagingEnabled;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    _scrollEnabled = scrollEnabled;
    
    self.collectionView.scrollEnabled = _scrollEnabled;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerCellWithNibIDs:@[IconTextCollectionViewCell]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
