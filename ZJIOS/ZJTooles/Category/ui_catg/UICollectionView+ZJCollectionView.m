//
//  UICollectionView+ZJCollectionView.m
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import "UICollectionView+ZJCollectionView.h"

@implementation UICollectionView (ZJCollectionView)

- (void)registerNibs:(NSArray *)nibIDs forSupplementaryViewOfKind:(NSString *)kind {
    for (int i = 0; i < nibIDs.count; i++) {
        NSString *cellID = nibIDs[i];
        [self registerNib:[UINib nibWithNibName:cellID bundle:nil] forSupplementaryViewOfKind:kind withReuseIdentifier:cellID];
    }
}

@end
