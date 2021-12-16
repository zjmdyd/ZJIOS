//
//  ZJTestMutableAryViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2021/7/2.
//

#import "ZJTestMutableAryViewController.h"
#import "NSArray+ZJArray.h"

@interface ZJTestMutableAryViewController ()

@end

@implementation ZJTestMutableAryViewController

/*
 NSMutableArray *array = [NSMutableArray arrayWithArray:self.objects];
 [array addObjectsFromArray:obj.objects];
 
 self.objects = [array mutableCopy];
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test0];
}

- (void)test0 {
    NSArray *ary = [NSArray multiArrayWithPrototype:@[@[@"", @""], @[@""]] value:@"1"];
    NSLog(@"ary = %@, %@", ary, ary.class);
    for (NSArray *sAry in ary) {
        NSLog(@"sAry = %@, %@", sAry, sAry.class);  // __NSArrayM
    }
}

/*
 2021-07-05 09:58:29.622767+0800 ZJIOS[1153:60296] (
     1,
     2
 ), 0x600001c583a0, __NSArrayI
 2021-07-05 09:58:29.623108+0800 ZJIOS[1153:60296] (
     1,
     2
 ), 0x60000124a550, __NSArrayM
 2021-07-05 09:58:29.623327+0800 ZJIOS[1153:60296] (
     1,
     2
 ), 0x600001c6d8a0, __NSArrayI
 */
- (void)test1 {
    NSArray *endAry;
    NSArray *originAry = @[@"1", @"2"];
    NSMutableArray *ary = [NSMutableArray arrayWithArray:originAry];
    NSLog(@"%@, %p, %@", originAry, originAry, originAry.class);
    NSLog(@"%@, %p, %@", ary, ary, ary.class);
    endAry = ary.copy;
    NSLog(@"%@, %p, %@", endAry, endAry, endAry.class);
}

/*
 2021-07-02 10:27:21.718155+0800 ZJIOS[3597:134930] (
     1,
     2
 ), 0x60000077f390, __NSArrayM
 2021-07-02 10:27:21.718416+0800 ZJIOS[3597:134930] (
     1,
     2
 ), 0x60000077c090, __NSArrayM
 2021-07-02 10:27:21.718590+0800 ZJIOS[3597:134930] (
     1,
     2
 ), 0x600000931f40, __NSArrayI
 2021-07-02 10:27:21.718744+0800 ZJIOS[3597:134930] (
     1,
     2
 ), 0x60000077f390, __NSArrayM
 2021-07-02 10:27:21.718897+0800 ZJIOS[3597:134930] (
     1
 ), 0x60000077c090, __NSArrayM
 2021-07-02 10:27:21.719065+0800 ZJIOS[3597:134930] (
     1,
     2
 ), 0x600000931f40, __NSArrayI
 */
- (void)test2 {
    NSArray *endAry;
    NSMutableArray *originAry = @[@"1", @"2"].mutableCopy;
    NSMutableArray *ary = [NSMutableArray arrayWithArray:originAry];
    NSLog(@"%@, %p, %@", originAry, originAry, originAry.class);
    NSLog(@"%@, %p, %@", ary, ary, ary.class);
    endAry = ary.copy;
    NSLog(@"%@, %p, %@", endAry, endAry, endAry.class);
    [ary removeLastObject];
    
    NSLog(@"%@, %p, %@", originAry, originAry, originAry.class);
    NSLog(@"%@, %p, %@", ary, ary, ary.class);
    NSLog(@"%@, %p, %@", endAry, endAry, endAry.class);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
