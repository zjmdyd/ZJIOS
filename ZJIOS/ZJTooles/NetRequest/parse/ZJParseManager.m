//
//  ZJParseManager.m
//  ButlerSugar
//
//  Created by ZJ on 3/4/16.
//  Copyright © 2016 csj. All rights reserved.
//

#import "ZJParseManager.h"
#define DefaultText @"--"

static ZJParseManager *_manager = nil;

@implementation ZJParseManager

+ (instancetype)shareManager {
    if (!_manager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _manager = [[ZJParseManager alloc] init];
        });
    }
    
    return _manager;
}

#pragma mark - new version

- (id)parseDataWithParseObject:(ZJParseObject *)parseObject data:(NSDictionary *)originInfo {
    id returnObj = [NSClassFromString(parseObject.returnType) new];
    id objType = NSClassFromString(parseObject.parseObjectType);
    id parseDataFlag = parseObject.parseDataFlag;
    
    NSString *parseSubDataFlag = parseObject.parseSubDataFlag;
    id subObjType = parseObject.parseSubObjectType;

    if ([parseDataFlag isKindOfClass:[NSString class]]) {
        id data = originInfo[parseObject.parseDataFlag];
        
        if ([returnObj isKindOfClass:[NSArray class]]) {
            returnObj = [self parseData:data model:objType subDataFlag:parseSubDataFlag subModel:subObjType];
        }else if ([returnObj isKindOfClass:[ZJPageSizeObjectInfo class]]) {
            id subData = data[parseObject.parsePageDataFlag];
            ((ZJPageSizeObjectInfo *)returnObj).objects = [self parseData:subData model:objType subDataFlag:parseSubDataFlag subModel:subObjType];
            ((ZJPageSizeObjectInfo *)returnObj).pageSize = [data[parseObject.pageDataCountFlag] integerValue];
        }else if ([returnObj isKindOfClass:[objType class]]) {
            id obj = [objType new];
            if ([data isKindOfClass:[NSDictionary class]]) {
                [data jsonToModel:obj];
                returnObj = obj;
            }
        }
    }else if([parseDataFlag isKindOfClass:[NSArray class]]) {   // 多个data分支
        for (NSString *key in parseDataFlag) {
            id data = originInfo[key];
            NSArray *ary = [self parseData:data model:objType subDataFlag:parseSubDataFlag subModel:subObjType];
            [returnObj setValue:ary forKey:key];
        }
    }
    
    return returnObj;
}

- (NSArray *)parseData:(id)data model:(id)objType subDataFlag:(NSString *)subFlag subModel:(id)subObjType {
    NSMutableArray *ary = [NSMutableArray array];
    if ([data isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dic in data) {
            id obj = [objType new];
            [dic jsonToModel:obj];
            if (subFlag != nil) {
                id subData = dic[subFlag];
                NSMutableArray *subAry = @[].mutableCopy;
                if ([subData isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *subDic in subData) {
                        id subObj = [NSClassFromString(subObjType) new];
                        [subDic jsonToModel:subObj];
                        [subAry addObject:subObj];
                    }
                }
                if ([[obj objectProperties] containsObject:subFlag]) {
                    [obj setValue:subAry forKey:subFlag];
                }
            }
            [ary addObject:obj];
        }
    }
    
    return ary;
}

/**
 //            NSMutableArray *ary = [NSMutableArray array];
 //            if ([data isKindOfClass:[NSArray class]]) {
 //                for (NSDictionary *dic in data) {
 //                    id obj = [objType new];
 //                    [dic noNullJsonToModel:obj];
 //                    [ary addObject:obj];
 //                }
 //            }
 */
@end

