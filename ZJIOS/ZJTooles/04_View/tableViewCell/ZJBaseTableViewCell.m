//
//  ZJBaseTableViewCell.m
//  ZJTest
//
//  Created by ZJ on 2019/4/4.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJBaseTableViewCell.h"

@implementation ZJBaseTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    
    if (self.keepSystemDefaultFont) {
        self.textLabel.font = [UIFont systemFontOfSize:17];
        self.detailTextLabel.font = [UIFont systemFontOfSize:15];
    }
    
    if (self.iconCornerRadius > 0) {
        self.imageView.layer.cornerRadius = self.iconCornerRadius;
        self.imageView.layer.masksToBounds = YES;
    }
}

/*
 [self performSelector:@selector(showFont) withObject:nil afterDelay:1.0];
 改变后的font字体大小获取不到
 */
- (void)showFont {
    NSLog(@"label = %@, font1 = %@", self.textLabel, self.textLabel.font);
    NSLog(@"attributedText = %@", self.textLabel.attributedText);
}
//
//- (void)drawRect:(CGRect)rect {
//
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/*
 2019-04-13 10:31:08.201358+0800 ZJTest[4817:1679904] -[ZJBaseTableViewCell initWithStyle:reuseIdentifier:] 此时控件的frame还没确定
 2019-04-13 10:31:08.274012+0800 ZJTest[4817:1679904] -[ZJBaseTableViewCell setSynchronSysFont:]
 2019-04-13 10:31:08.282615+0800 ZJTest[4817:1679904] -[ZJBaseTableViewCell layoutSubviews]   此时控件的frame已经确定 此方法每次页面显示都会调用
 2019-04-13 10:31:08.287870+0800 ZJTest[4817:1679904] -[ZJBaseTableViewCell drawRect:]    此方法默认只会调用一次，除非开发者自己调用刷新
 */
@end
