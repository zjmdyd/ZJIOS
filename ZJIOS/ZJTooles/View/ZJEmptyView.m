//
//  ZJEmptyView.m
//  HeLiCommunity
//
//  Created by ZJ on 2019/7/13.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJEmptyView.h"

@interface ZJEmptyView()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ZJEmptyView

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = _title;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
