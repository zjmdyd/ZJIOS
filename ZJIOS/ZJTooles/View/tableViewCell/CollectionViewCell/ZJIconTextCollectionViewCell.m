//
//  ZJIconTextCollectionViewCell.m
//  HeLiCommunity
//
//  Created by ZJ on 2019/6/19.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJIconTextCollectionViewCell.h"

@interface ZJIconTextCollectionViewCell()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelCenterCST;

//
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textCenterY;

//
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconTrailing;
@property (weak, nonatomic) IBOutlet UIView *textBorderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *borderLeasingCST;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *borderTrailingCST;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *borderBottomCST;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *borderTopCST;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation ZJIconTextCollectionViewCell

- (void)setItemType:(ZJCollectionViewItemType)itemType {
    _itemType = itemType;
    
    if (_itemType < ZJCollectionViewItemTypeOfIconText) {
        self.iconIV.hidden = _itemType == ZJCollectionViewItemTypeOfText;
        self.label.hidden = !self.iconIV.hidden;
    }else {
        self.label.hidden = self.iconIV.hidden = NO;
    }
}

- (void)setIconEdgeInsets:(UIEdgeInsets)iconEdgeInsets {
    _iconEdgeInsets = iconEdgeInsets;
    
    self.iconTop.constant = _iconEdgeInsets.top;
    self.iconBottom.constant = _iconEdgeInsets.bottom;
    self.iconLeading.constant = _iconEdgeInsets.left;
    self.iconTrailing.constant = _iconEdgeInsets.right;
}

- (void)setTextOffsetCenterY:(CGFloat)textOffsetCenterY {
    _textOffsetCenterY = textOffsetCenterY;
    
    self.textCenterY.constant = _textOffsetCenterY;
    self.labelCenterCST.constant = _textOffsetCenterY;
}

- (void)setText:(NSString *)text {
    _text = text;
    
    self.label.text = _text;
    self.textField.text = _text;
}

- (void)setIconPath:(NSString *)iconPath {
    if (iconPath.length) {
        [self.iconIV setImageWithPath:iconPath placehold:self.placeholdIcon];
    }else {
        self.iconIV.image = nil;
    }
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    
    self.label.textColor = _textColor;
    self.textField.textColor = _textColor;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
    
    self.label.textAlignment = _textAlignment;
    self.textField.textAlignment = _textAlignment;
}

- (void)setEnableEdit:(BOOL)enableEdit {
    _enableEdit = enableEdit;
    
    self.textField.enabled = _enableEdit;
    self.textField.hidden = !_enableEdit;
    self.label.hidden = _enableEdit;
}

- (void)setEnableDelete:(BOOL)enableDelete {
    _enableDelete = enableDelete;
    
    self.deleteBtn.hidden = !_enableDelete;
}

- (void)setNumberOfLine:(NSInteger)numberOfLine {
    _numberOfLine = numberOfLine;
    
    self.label.numberOfLines = _numberOfLine;
}

- (void)setTextCornerRadius:(CGFloat)textCornerRadius {
    _textCornerRadius = textCornerRadius;
    
    self.textBorderView.layer.cornerRadius = _textCornerRadius;
}

- (void)setTextBorderWidth:(CGFloat)textBorderWidth {
    _textBorderWidth = textBorderWidth;
    
    self.textBorderView.layer.borderWidth = _textBorderWidth;
}

- (void)setTextBorderColor:(UIColor *)textBorderColor {
    _textBorderColor = textBorderColor;
    
    self.textBorderView.layer.borderColor = _textBorderColor.CGColor;
}

- (void)setTextBorderEdgeInsets:(UIEdgeInsets)textBorderEdgeInsets {
    _textBorderEdgeInsets = textBorderEdgeInsets;
    
    self.borderTopCST.constant = -_textBorderEdgeInsets.top;
    self.borderLeasingCST.constant = _textBorderEdgeInsets.left;
    self.borderBottomCST.constant = _textBorderEdgeInsets.bottom;
    self.borderTrailingCST.constant = -_textBorderEdgeInsets.right;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    
    if (_font) {
        self.label.font = _font;
        self.textField.font = _font;
    }
}

- (IBAction)btnEvent:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(iconTextCollectionViewCellDidClickDeleteButton:)]) {
        [self.delegate iconTextCollectionViewCellDidClickDeleteButton:self];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

@end
