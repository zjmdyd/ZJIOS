//
//  ZJFruit+ZJFruitCatgy.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/20.
//

#import "ZJFruit+ZJFruitCatgy.h"
#include <objc/runtime.h>

@implementation ZJFruit (ZJFruitCatgy)

- (NSString *)weight{
    return objc_getAssociatedObject(self, @"weight");
}

-(void)setWeight:(NSString *)weight{
    // objc_setAssociatedObject（将某个值跟某个对象关联起来，将某个值存储到某个对象中）
    // object:给哪个对象添加属性
    // key:属性名称
    // value:属性值
    // policy:保存策略
    objc_setAssociatedObject(self, @"weight", weight, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end


