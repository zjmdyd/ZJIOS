//
//  ZJKernelCollectionViewCell.m
//  ZJIOS
//
//  Created by Zengjian on 2025/5/26.
//

#import "ZJKernelCollectionViewCell.h"

@interface ZJKernelCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iv;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ZJKernelCollectionViewCell

- (void)setImg:(UIImage *)img {
    _img = img;
    
    self.iv.image = _img;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
}

@end
