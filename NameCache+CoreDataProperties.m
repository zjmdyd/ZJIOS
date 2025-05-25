//
//  NameCache+CoreDataProperties.m
//  
//
//  Created by Zengjian on 2025/5/25.
//
//

#import "NameCache+CoreDataProperties.h"

@implementation NameCache (CoreDataProperties)

+ (NSFetchRequest<NameCache *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"NameCache"];
}

@dynamic cacheKey;
@dynamic cacheName;
@dynamic cacheTime;
@dynamic color;

@end
