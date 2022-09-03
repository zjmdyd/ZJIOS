//
//  UIView+ZJView.h
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZJView)


+ (UIView *)maskViewWithFrame:(CGRect)frame;
- (UIView *)subViewWithTag:(NSInteger)tag;
- (UIView *)fetchSubViewWithClassName:(NSString *)className;
- (UIView *)fetchSuperViewWithClassName:(NSString *)className;
+ (UIView *)createViewWithNibName:(NSString *)name;

- (void)logSubViews;
- (void)removeAllSubViews;

/**
 *  添加tap手势
 *
 *  @param delegate 当不需要delegate时可设为nil
 */
- (UITapGestureRecognizer *)addTapGestureWithDelegate:(id <UIGestureRecognizerDelegate>)delegate target:(id)target;

#pragma mark - supplementView

- (void)addIconBadgeWithImage:(UIImage *)image;
- (void)addIconBadgeWithImage:(UIImage *)image bgColor:(UIColor *)color;
// 左文字右图片
+ (UIView *)createTitleIVWithFrame:(CGRect)frame path:(NSString *)path placehold:(NSString *)placehold title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
