//
//  UIBarButtonItem+ZJBarButtonItem.h
//  ZJIOS
//
//  Created by Zengjian on 2021/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (ZJBarButtonItem)

/**
 *  根据自定义view创建一个UIBarButtonItem
 *
 */
+ (UIBarButtonItem *)barbuttonWithCustomView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
