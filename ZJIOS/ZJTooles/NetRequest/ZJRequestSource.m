//
//  ZJRequestSource.m
//  KeerZhineng
//
//  Created by ZJ on 2018/12/17.
//  Copyright © 2018 HY. All rights reserved.
//

#import "ZJRequestSource.h"
#import "ZJParseObject.h"

static ZJRequestSource *_source = nil;

@implementation ZJRequestSource

+ (instancetype)shareSource {
    if (!_source) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _source = [[self alloc] init];
        });
    }
    
    return _source;
}

- (NSArray *)requestSources {
    return @[
             @{
                 RequestIndex : @0,
                 RequestPathKey : @"/api/v2/user/estate/search",
                 ReturnDataType : @"HYIndexsPageObject",
                 ParseObjectType : @"HYEstate",
                 ParseDataFlag : @"page",
                 RequestIsPageData : @(YES),
                 ParsePageDataFlag : @"list",
                 PageDataCountFlag : @"totalPage",
                 },
             @{
                 RequestIndex : @1,
                 RequestPathKey : @"/api/v2/user/alley/list",
                 ReturnDataType : @"ZJPageSizeObjectInfo",
                 ParseObjectType : @"HYAlley",
                 ParseDataFlag : @"page",
                 RequestIsPageData : @(YES),
                 ParsePageDataFlag : @"list",
                 PageDataCountFlag : @"totalPage",
                 },
             @{
                 RequestIndex : @2,
                 RequestPathKey : @"/api/v2/user/building/list",
                 ReturnDataType : @"ZJPageSizeObjectInfo",
                 ParseObjectType : @"HYBuilding",
                 ParseDataFlag : @"page",
                 RequestIsPageData : @(YES),
                 ParsePageDataFlag : @"list",
                 PageDataCountFlag : @"totalPage",
                 },
             @{
                 RequestIndex : @3,
                 RequestPathKey : @"/api/v2/user/room/list",
                 ReturnDataType : @"ZJPageSizeObjectInfo",
                 ParseObjectType : @"HYRoom",
                 ParseDataFlag : @"page",
                 RequestIsPageData : @(YES),
                 ParsePageDataFlag : @"list",
                 PageDataCountFlag : @"totalPage",
                 },
             @{
                 RequestIndex : @4,
                 RequestPathKey : @"/api/v2/user/household/apply/list",
                 ReturnDataType : @"ZJPageSizeObjectInfo",
                 ParseObjectType : @"HYApplyInfo",
                 ParseDataFlag : @"page",
                 RequestIsPageData : @(YES),
                 ParsePageDataFlag : @"list",
                 PageDataCountFlag : @"totalPage",
                 },
             @{
                 RequestIndex : @5,
                 RequestPathKey : @"/api/v2/user/rooms",
                 ReturnDataType : @"HYAuthEstates",
                 ParseObjectType : @"HYEstateInfo",
                 ParseDataFlag : @[@"invalidList", @"validList", @"otherList", @"nearList"],
                 ParseSubObjectType : @"HYDevice",
                 ParseSubDataFlag : @"deviceList",
                 },
             @{
                 RequestIndex : @6,
                 RequestPathKey : @"/api/v2/user/banner/ad",
                 ReturnDataType : @"NSArray",
                 ParseDataFlag : @"ads",
                 ParseObjectType : @"HYAds",
                 },
             @{
                 RequestIndex : @7,
                 RequestPathKey : @"/api/v2/user/index/appconfig",
                 ReturnDataType : @"NSArray",
                 ParseDataFlag : @"appconfig",
                 ParseObjectType : @"HYConfig",
                 RequestIsJoinPath : @(YES),
                 },
             @{
                 RequestIndex : @8,
                 RequestPathKey : @"/api/v2/user/houseresource/list",
                 ReturnDataType : @"ZJPageSizeObjectInfo",
                 ParseObjectType : @"HYHouse",
                 ParseDataFlag : @"page",
                 RequestIsPageData : @(YES),
                 ParsePageDataFlag : @"list",
                 PageDataCountFlag : @"totalPage",
                 },
             @{
                 RequestIndex : @9,
                 RequestPathKey : @"/api/v2/user/houseresource/info",
                 ReturnDataType : @"HYHouseDetail",
                 ParseDataFlag : @"info",
                 ParseObjectType : @"HYHouseDetail",
                 RequestIsJoinPath : @(YES),
                 },
             @{
                 RequestIndex : @10,
                 RequestPathKey : @"/api/v2/user/doorguard/key",
                 ReturnDataType : @"HYPassword",
                 ParseDataFlag : @"data",
                 ParseObjectType : @"HYPassword",
                 },
             @{
                 RequestIndex : @11,
                 RequestPathKey : @"/api/v2/user/doorguard/open/log/list",
                 ReturnDataType : @"NSArray",
                 ParseDataFlag : @"list",
                 ParseObjectType : @"HYOpenRecord",
                 },
             @{
                 RequestIndex : @12,
                 RequestPathKey : @"/api/v2/user/household/list",
                 ReturnDataType : @"NSArray",
                 ParseDataFlag : @"list",
                 ParseObjectType : @"HYAuth",
                 RequestIsJoinPath : @(YES),
                 },
             @{
                 RequestIndex : @13,
                 RequestPathKey : @"/api/v2/user/household/notice/list",
                 ReturnDataType : @"NSArray",
                 ParseDataFlag : @"list",
                 ParseObjectType : @"HYDisturb",
                 },
             @{
                 RequestIndex : @14,
                 RequestPathKey : @"/api/v2/user/houseresource/all/areas",
                 ReturnDataType : @"ZJPageSizeObjectInfo",
                 ParseObjectType : @"HYOtherProvince",
                 ParseDataFlag : @"page",
                 RequestIsPageData : @(YES),
                 ParsePageDataFlag : @"list",
                 PageDataCountFlag : @"totalPage",
                 },
             
             @{
                 RequestIndex : @15,
                 RequestPathKey : @"/api/v2/user/repaironline/list",
                 ReturnDataType : @"ZJPageSizeObjectInfo",
                 ParseObjectType : @"HYRepairRecord",
                 ParseDataFlag : @"page",
                 RequestIsPageData : @(YES),
                 ParsePageDataFlag : @"list",
                 PageDataCountFlag : @"totalPage",
                 },
             @{
                 RequestIndex : @16,
                 RequestPathKey : @"/api/v2/user/message/list",
                 ReturnDataType : @"HYMessagePageObject",
                 ParseObjectType : @"HYMessage",
                 ParseDataFlag : @"page",
                 RequestIsPageData : @(YES),
                 ParsePageDataFlag : @"list",
                 PageDataCountFlag : @"totalPage",
                 },
             @{
                 RequestIndex : @17,
                 RequestPathKey : @"/api/v2/user/message/info",
                 ReturnDataType : @"HYMessageDetail",
                 ParseDataFlag : @"userMessage",
                 ParseObjectType : @"HYMessageDetail",
                 RequestIsJoinPath : @(YES),
                 },
             @{
                 RequestIndex : @18,
                 RequestPathKey : @"/api/v2/user/money/list",
                 ReturnDataType : @"ZJPageSizeObjectInfo",
                 ParseObjectType : @"HYMoney",
                 ParseDataFlag : @"page",
                 RequestIsPageData : @(YES),
                 ParsePageDataFlag : @"list",
                 PageDataCountFlag : @"totalPage",
                 },
             @{
                 RequestIndex : @19,
                 RequestPathKey : @"/api/v2/user/houseresource/mine/list",
                 ReturnDataType : @"ZJPageSizeObjectInfo",
                 ParseObjectType : @"HYHouse",
                 ParseDataFlag : @"page",
                 RequestIsPageData : @(YES),
                 ParsePageDataFlag : @"list",
                 PageDataCountFlag : @"totalPage",
                 },
             @{
                 RequestIndex : @20,
                 RequestPathKey : @"/api/v2/user/estate/search",
                 ReturnDataType : @"ZJPageSizeObjectInfo",
                 ParseObjectType : @"HYEstate",
                 ParseDataFlag : @"page",
                 RequestIsPageData : @(YES),
                 ParsePageDataFlag : @"list",
                 PageDataCountFlag : @"totalPage",
                 },
             @{
                 RequestIndex : @21,
                 RequestPathKey : @"/api/v2/user/message/list",
                 ReturnDataType : @"ZJPageSizeObjectInfo",
                 ParseObjectType : @"HYMessage",
                 ParseDataFlag : @"page",
                 RequestIsPageData : @(YES),
                 ParsePageDataFlag : @"list",
                 PageDataCountFlag : @"totalPage",
                 },             
             
             
             
             
             @{
                 RequestIndex : @26,
                 RequestPathKey : @"/api/app/index/alertMsgList",
                 RequestIsJoinPath : @(YES),
                 ReturnDataType : @"ZJPageSizeObjectInfo",
                 ParseDataFlag : @"data",
                 RequestIsPageData : @(YES),
                 ParsePageDataFlag : @"list",
                 ParseObjectType : @"HYMessage",
                 ParseAssistDataType : @(ParseAssistantTypeOfMessage),
                 },
             ];
}

@end
