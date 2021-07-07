//
//  ZJCollectionViewController.m
//  CanShengHealth
//
//  Created by ZJ on 2018/7/4.
//  Copyright © 2018 HY. All rights reserved.
//

#import "ZJCollectionViewController.h"

@interface ZJCollectionViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation ZJCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.collectionView.alwaysBounceVertical = YES;
    
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    
    self.needMJHeaderRefresh = YES;
}

- (void)setNeedMJHeaderRefresh:(BOOL)needMJHeaderRefresh {
    _needMJHeaderRefresh = needMJHeaderRefresh;
    
    if (_needMJHeaderRefresh) {
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self mjRefreshEventWithType:RefreshEventTypeOfHeader];
        }];
    }else {
        self.collectionView.mj_header = nil;
    }
}

- (void)setNeedMJFooterRefresh:(BOOL)needMJFooterRefresh {
    _needMJFooterRefresh = needMJFooterRefresh;
    
    if (_needMJFooterRefresh) {
        self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self mjRefreshEventWithType:RefreshEventTypeOfFooter];
        }];
    }else {
        self.collectionView.mj_footer = nil;
    }
}

- (void)endMJRefresh {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView.mj_header endRefreshing];
        if (self.collectionView.mj_footer) {
            [self.collectionView.mj_footer endRefreshing];
        }
    });
}

- (void)mjRefreshEventWithType:(RefreshEventType)type {
    
}

#pragma maek - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *str = self.emptyMessage ?: @"暂无内容";
    return [[NSAttributedString alloc] initWithString:str attributes:@{
                                                                       NSFontAttributeName : [UIFont systemFontOfSize:19]
                                                                       }];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:self.emptyImageName ?: @""];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return self.emptyOffset;
}

#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (void)notiRefreshEvent {
    self.needRefresh = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//#pragma mark <UICollectionViewDataSource>
//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of items
//    return 0;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//
//    // Configure the cell
//
//    return cell;
//}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
