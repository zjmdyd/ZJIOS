//
//  UICollectionView+ZJCollectionView.h
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (ZJCollectionView)

- (void)registerNibs:(NSArray *)nibIDs forSupplementaryViewOfKind:(NSString *)kind;

@end

NS_ASSUME_NONNULL_END
