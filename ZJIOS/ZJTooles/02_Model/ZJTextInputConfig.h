//
//  ZJTextInputConfig.h
//  ZJIOS
//
//  Created by issuser on 2021/7/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJTextInputConfig : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *placehold;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) BOOL secureText;
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, strong) UIColor *textColor;

@end

NS_ASSUME_NONNULL_END
