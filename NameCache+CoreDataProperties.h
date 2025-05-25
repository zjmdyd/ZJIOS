//
//  NameCache+CoreDataProperties.h
//  
//
//  Created by Zengjian on 2025/5/25.
//
//

#import "NameCache+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface NameCache (CoreDataProperties)

+ (NSFetchRequest<NameCache *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *cacheKey;
@property (nullable, nonatomic, copy) NSString *cacheName;
@property (nullable, nonatomic, copy) NSDate *cacheTime;
@property (nullable, nonatomic, retain) NSObject *color;

@end

NS_ASSUME_NONNULL_END
