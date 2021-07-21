//
//  NSDictionary+Log.h
//  descrption
//
//  Created by telen on 15/11/26.
//  Copyright © 2015年 Creative Knowledge Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDictionary (Log)

- (NSString *)descriptionDefine;
- (id)valueForKeyWithOutNSNull:(NSString *)key;
- (id)valueForKeyWithReturnEmptyString:(NSString *)key;
- (int)intValueWithDefaultVaule:(NSString*)key;
@end
