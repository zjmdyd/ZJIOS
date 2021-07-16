//
//  ZJAlertObject.h
//  KeerZhineng
//
//  Created by ZJ on 2019/2/19.
//  Copyright © 2019 HY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJAlertObject : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, assign) UIAlertControllerStyle alertStyle;
@property (nonatomic, strong) NSArray <NSString *>*sheetTitles;


@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy, nullable) NSString *cancelTitle;
@property (nonatomic, copy, nullable) NSString *otherTitle;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) BOOL secureText;
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) UIAlertViewStyle alertViewStyle;
@property (nonatomic, weak) id<UIAlertViewDelegate> delegate;

//
@property (nonatomic, strong) NSArray *sheetObjects;
@property (nonatomic, assign) BOOL needCancel;

@end

NS_ASSUME_NONNULL_END
