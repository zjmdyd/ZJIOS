//
//  ZJMentionObject.h
//  AoShiTong
//
//  Created by ZJ on 2018/9/7.
//  Copyright © 2018 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJMentionObject : NSObject

@property (nonatomic, copy) NSString *firstText;
@property (nonatomic, copy) NSString *secondText;
@property (nonatomic, assign) NSTimeInterval delay;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) BOOL autoHidden;

@end
