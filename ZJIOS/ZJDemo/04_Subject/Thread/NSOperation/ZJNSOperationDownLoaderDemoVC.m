//
//  ZJNSOperationDownLoaderDemoVC.m
//  ZJFoundation
//
//  Created by hanyou on 15/12/1.
//  Copyright © 2015年 YunTu. All rights reserved.
//

#import "ZJNSOperationDownLoaderDemoVC.h"
#import "ZJNetOperation.h"

@interface ZJNSOperationDownLoaderDemoVC ()<ZJHTTPDownloadDelegate>

@property (nonatomic, strong) ZJNetOperation *downloader;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property (nonatomic, weak) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UIImageView *downloadIV;

@end

//NSString * const URL_STRING = @"http://sanjosetransit.com/extras/SJTransit_Icons.zip";
NSString * const URL_STRING = @"http://gips3.baidu.com/it/u=3886271102,3123389489&fm=3028&app=3028&f=JPEG&fmt=auto?w=1280&h=960";
@implementation ZJNSOperationDownLoaderDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)buttonAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"Download"]) {
        [sender setTitle:@"Cancel" forState:UIControlStateNormal];
        
        self.progress.progress = 0.f;
        NSURL *URL = [NSURL URLWithString:URL_STRING];
        __weak typeof(self) weakSelf = self;
        self.downloader = [[ZJNetOperation alloc] initWithRequestURL:URL progress:^(float percent) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.progress.progress = percent;
            });
        } completion:^(id response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [sender setTitle:@"Finished" forState:UIControlStateNormal];
                if (error) {
                    weakSelf.progress.progress = 0.f;
                }
            });
        }];
        
        self.downloader.delegate = self;
        self.operationQueue = [[NSOperationQueue alloc] init];
        [self.operationQueue addOperation:self.downloader];
        [self.operationQueue addOperationWithBlock:^{
            NSLog(@"next operation");
        }];
    }else {
        [sender setTitle:@"Download" forState:UIControlStateNormal];
        self.progress.progress = 0.f;
        [self.downloader cancel];
    }
}

#pragma mark - 

- (void)zjHTTPDownload:(ZJNetOperation *)downloader downloadProgress:(double)progress {
    NSLog(@"%s", __func__);
}

- (void)zjHTTPDownload:(ZJNetOperation *)downloader didDownloadWithData:(NSData *)data {
    NSLog(@"%s", __func__);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.downloadIV.image = [UIImage imageWithData:data];
    });
}

- (void)zjHTTPDownload:(ZJNetOperation *)downloader didFailWithError:(NSError *)error {
    NSLog(@"%s", __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
