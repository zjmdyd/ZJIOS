//
//  ZJParseManager.h
//  ButlerSugar
//
//  Created by ZJ on 3/4/16.
//  Copyright © 2016 csj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZJRequestManager.h"

@interface ZJParseManager : NSObject

+ (instancetype)shareManager;

#pragma mark - new version

- (id)parseDataWithParseObject:(ZJParseObject *)parseObject data:(NSDictionary *)originInfo;

@end
