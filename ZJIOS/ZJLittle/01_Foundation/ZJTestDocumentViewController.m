//
//  ZJTestDocumentViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/12/7.
//

#import "ZJTestDocumentViewController.h"
#import "ZJDefine.h"
#import "NSObject+ZJDocument.h"

@interface ZJTestDocumentViewController ()

@end

@implementation ZJTestDocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initSetting];
    [self test3];
}

- (void)initSetting {
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_sandbox"]];
    iv.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    iv.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:iv];
}

/*
 NSJSONReadingMutableContainers
 NSJSONReadingMutableLeaves
 NSJSONReadingAllowFragments
 */
- (void)test3 {
    NSDictionary *dic = @{@"hh" : @"haha\ngg"};
    NSError *wError;

    if ([NSJSONSerialization isValidJSONObject:dic]) {
        NSLog(@"格式正确");
    }else {
        NSLog(@"格式错误");
    }
    NSData *value =  [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&wError];
    
    if (!wError) {
        NSLog(@"写入成功");
    }else {
        NSLog(@"写入失败");
    }
    NSError *rError;

    id result = [NSJSONSerialization JSONObjectWithData:value options:NSJSONReadingMutableContainers error:&rError];
    if (!rError) {
        NSLog(@"反序列化成功:result = %@, %@", result, [result class]);
    }else {
        NSLog(@"反序列化失败:result = %@, %@", result, [result class]);
    }
}

- (void)test2 {
    NSArray *strs = @[@"helloWorld"];
    NSLog(@"isValidJSONObject = %d", [NSJSONSerialization isValidJSONObject:strs]);
    [strs writeToFileWithPathComponent:@"hello"];
    id value = [NSObject readFileWithPathComponent:@"hello"];
    NSLog(@"value = %@", value);
    [NSObject removeFileWithPathComponent:@"hello"];
    [strs writeToFileWithPathComponent:@"hello" needEncodeFileName:YES];
}

- (void)test1 {
    NSString *path = NSHomeDirectory();
    NSLog(@"homePath = %@", path);
    
    NSArray *ary0 = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSArray *ary1 = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *tmpDir =  NSTemporaryDirectory();
    NSLog(@"NSCachesDirectory = %@", ary0);
    NSLog(@"NSLibraryDirectory = %@", ary1);
    NSLog(@"tmpDir = %@", tmpDir);
}

// 测试是否显示完整路径
/*
 2021-12-07 16:54:19.543455+0800 ZJIOS[18862:186993] ary0 = (
     "/Users/issuser/Library/Developer/CoreSimulator/Devices/85CBF745-8847-4843-95E6-D53262D1B3D9/data/Containers/Data/Application/6FFA4980-EDD1-433F-8D60-E71F888450C0/Documents"
 )
 2021-12-07 16:54:19.543657+0800 ZJIOS[18862:186993] ary0 = (
     "~/Documents"
 )
 */
- (void)test0 {
    NSArray *ary0 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSArray *ary1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, NO);
    NSLog(@"ary0 = %@", ary0);
    NSLog(@"ary0 = %@", ary1);
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
