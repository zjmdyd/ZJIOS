//
//  Student.h
//  ZJIOS
//
//  Created by Zengjian on 2021/6/20.
//

#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface Student : Person

@property (nonatomic, assign) NSInteger age;

- (void)testSuperClass;

@end

NS_ASSUME_NONNULL_END
