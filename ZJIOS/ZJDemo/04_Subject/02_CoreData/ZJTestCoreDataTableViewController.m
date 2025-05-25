//
//  ZJTestCoreDataTableViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2025/5/25.
//

#import "ZJTestCoreDataTableViewController.h"
#import "NameCache+CoreDataProperties.h"
#import "AppDelegate.h"
#import "ColorTransformer.h"

@interface ZJTestCoreDataTableViewController () {
    AppDelegate *_appDelegate;
}

@end

@implementation ZJTestCoreDataTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
}

- (void)initAry {
    self.vcType = ZJBaseTableViewTypeExecute;
    
    self.cellTitles = @[@"test0", @"test1", @"test2", @"test3"];
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
}

// 插入
- (void)test0 {
    NameCache *obj = [NSEntityDescription insertNewObjectForEntityForName:@"NameCache" inManagedObjectContext:_appDelegate.persistentContainer.viewContext];
    obj.cacheKey = @"k0";
    obj.cacheName = @"Name0";
    obj.cacheTime = [NSDate date];
    obj.color = [UIColor yellowColor];
    [_appDelegate saveContext];
}

// 查找
- (void)test1 {
    NSManagedObjectContext *context = _appDelegate.persistentContainer.viewContext;

    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"NameCache"];
    // 执行查询请求 并得到查询出来的结果
    NSArray *persons = [context executeFetchRequest:request error:nil];
    for (NameCache *p in persons) {
        NSLog(@"%@  %@  %@ %@", p.cacheKey, p.cacheName, p.cacheTime, p.color);
    }
}

// 修改
- (void)test2 {
    NSManagedObjectContext *context = _appDelegate.persistentContainer.viewContext;
    // 创建查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"NameCache"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"cacheKey = %@", @"k0"];
    request.predicate = pre;
    
    // 发送请求
    NSArray *ary = [context executeFetchRequest:request error:nil];
    // 修改
    for (NameCache *che in ary) {
        che.cacheKey = @"k00";
    }
    
    // 保存
    NSError *saveError = nil;
    if ([context save:&saveError]) {
        NSLog(@"需修改数据成功");
    }else{
        NSLog(@"修改数据失败, %@", saveError);
    }
}

// 删除
- (void)test3 {
    NSManagedObjectContext *context = _appDelegate.persistentContainer.viewContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"NameCache"];
    NSError *error = nil;
    NSArray *ary = [context executeFetchRequest:request error:&error];
    for (NameCache *obj in ary) {
        NSLog(@"%@  %@  %@ %@", obj.cacheKey, obj.cacheName, obj.cacheTime, obj.color);
        if ([obj.cacheKey isEqualToString:@"k00"]) {
            [context deleteObject:obj];
        }
    }
    
    // 保存
    NSError *saveError = nil;
    if ([context save:&saveError]) {
        NSLog(@"删除数据成功");
    }else{
        NSLog(@"删除数据失败, %@", saveError);
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
