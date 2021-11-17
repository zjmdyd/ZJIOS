//
//  ZJTestServerViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2021/7/1.
//

#import "ZJTestServerViewController.h"
#import "ZJSocketManager.h"

@interface ZJTestServerViewController ()

@property (nonatomic, strong) ZJSocketManager *manage;

@end

@implementation ZJTestServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manage = [ZJSocketManager share];
}

- (IBAction)connect:(id)sender {
    [self.manage connect];
}

- (IBAction)send:(id)sender {
    [self.manage sendMsg:@"哈哈，发数据"];
}

- (IBAction)disconnect:(id)sender {
    [self.manage disConnect];
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
