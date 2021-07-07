//
//  HYSideMenuHeadView.m
//  SportWatch
//
//  Created by ZJ on 3/17/17.
//  Copyright © 2017 ZJ. All rights reserved.
//

#import "HYSideMenuHeadView.h"

@interface HYSideMenuHeadView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation HYSideMenuHeadView

- (void)setImgName:(NSString *)imgName {
    _imgName = imgName;
    
    [self.btn sd_setBackgroundImageWithURL:[NSURL URLWithString:_imgName] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:[NSObject defaultHeadPic]]];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = _title.length ? _title : @"--";
}


- (IBAction)btnEvent:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(sideMenuHeadViewDidSelectHeadView:)]) {
        [self.delegate sideMenuHeadViewDidSelectHeadView:self];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.btn.layer.cornerRadius = 35;
    self.btn.layer.masksToBounds = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
