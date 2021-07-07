//
//  ZJHTTPRequest.h
//  CanShengHealth
//
//  Created by ZJ on 03/02/2018.
//  Copyright © 2018 HY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZJRequestObject.h"

typedef void(^HTTPRequestCompletionHandle)(id obj, BOOL hasLogin);

static NSString *const kComDomain = @"https://api.heli.hanyouapp.com";
static NSString *const kNetDomain = @"https://api.door.hlsqzj.com";

@interface ZJHTTPRequest : NSObject

+ (instancetype)shareHTTPRequest;

@property (nonatomic, copy, readonly) NSString *kDomain;
@property (nonatomic, strong) NSDictionary *shareHeaders;

- (void)requestWithRequestObject:(ZJRequestObject *)object completion:(HTTPRequestCompletionHandle)completion;

@end
