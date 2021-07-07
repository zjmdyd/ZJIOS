//
//  ZJRequestSource.h
//  KeerZhineng
//
//  Created by ZJ on 2018/12/17.
//  Copyright © 2018 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define RequestPathKey @"path"
#define RequestIsJoinPath @"isJoinPath"
#define JoinPathParamsKey @"joinPath"

#define RequestIndex @"index"   // 暂时未用到
#define ReturnDataType @"returnType"
#define ParseDataFlag @"parseDataFlag"    //
#define ParseObjectType @"parseObjectType"

#define RequestIsPageData @"isPageData"
#define ParsePageDataFlag @"pageDataKey"
#define PageDataCountFlag @"pageDataCountkey"

#define ParseSubObjectType @"subObjectType"
#define ParseSubDataFlag @"subDataFlag"

#define ParseAssistDataType @"assistDataType"

@interface ZJRequestSource : NSObject

+ (instancetype)shareSource;
@property (nonatomic, strong, readonly) NSArray *requestSources;

@end

NS_ASSUME_NONNULL_END
