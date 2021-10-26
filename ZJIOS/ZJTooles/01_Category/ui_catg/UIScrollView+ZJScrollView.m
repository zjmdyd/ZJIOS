//
//  UIScrollView+ZJScrollView.m
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import "UIScrollView+ZJScrollView.h"

@implementation UIScrollView (ZJScrollView)

- (void)registerCellWithSysIDs:(NSArray *)sysIDs {
    for (int i = 0; i < sysIDs.count; i++) {
        NSString *cellID = sysIDs[i];
        if ([self isKindOfClass:[UITableView class]]) {
            [((UITableView *)self) registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
        }else if([self isKindOfClass:[UICollectionView class]]){
            [((UICollectionView *)self) registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
        }
    }
}

- (void)registerCellWithNibIDs:(NSArray *)nibIDs {
    for (int i = 0; i < nibIDs.count; i++) {
        NSString *cellID = nibIDs[i];
        if ([self isKindOfClass:[UITableView class]]) {
            [((UITableView *)self) registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
        }else if([self isKindOfClass:[UICollectionView class]]){
            [((UICollectionView *)self) registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
        }
    }
}

- (void)registerCellWithNibIDs:(NSArray *)nibIDs sysIDs:(NSArray *)sysIDs {
    [self registerCellWithNibIDs:nibIDs];
    [self registerCellWithSysIDs:sysIDs];
}

@end
