//
//  Person.h
//  ZJIOS
//
//  Created by Zengjian on 2021/6/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@end

@interface Person (Property)

@property (nonatomic, copy) NSString *personName;

@end
NS_ASSUME_NONNULL_END
