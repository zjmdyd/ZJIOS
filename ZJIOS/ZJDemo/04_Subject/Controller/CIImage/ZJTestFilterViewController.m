//
//  ZJTestFilterViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/7/21.
//

#import "ZJTestFilterViewController.h"

@interface ZJTestFilterViewController ()

@end

@implementation ZJTestFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test0];
}

- (void)test0 {
    UIImage *originImg = [UIImage imageNamed:@"filter_1"];
    CIImage *image = [[CIImage alloc] initWithImage:originImg];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIBoxBlur" keysAndValues:kCIInputImageKey,image, nil];
    [filter setDefaults];
    
    CIContext *context = [[CIContext alloc] initWithOptions:nil];
    CIImage *output = [filter outputImage];
    
    CGImageRef ref = [context createCGImage:output fromRect:[output extent]];
    UIImage *newImage = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 250, 400)];
    imageView1.image = originImg;
    [self.view addSubview:imageView1];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(250, 100, 250, 400)];
    imageView2.image = newImage ;
    [self.view addSubview:imageView2];
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
