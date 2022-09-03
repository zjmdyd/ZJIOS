//
//  ZJTestImageOverlayViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/7/21.
//

#import "ZJTestImageOverlayViewController.h"

@interface ZJTestImageOverlayViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *originIV;
@property (weak, nonatomic) IBOutlet UIImageView *warpIV;
@property (weak, nonatomic) IBOutlet UIImageView *hazeIV;
@property (weak, nonatomic) IBOutlet UIImageView *bgIV;
@property (weak, nonatomic) IBOutlet UIImageView *changeColorIV;

@end

@implementation ZJTestImageOverlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test0];
    [self test1];
    [self test2];
}

// CIWarpKernel
- (void)test0 {
    UIImage *originInputImg = [UIImage imageNamed:@"ic_hehua"];
    self.originIV.image = originInputImg;
    
    CIImage *ciInputImg = [[CIImage alloc] initWithImage:originInputImg];
    NSURL *kernelURL = [[NSBundle mainBundle] URLForResource:@"a" withExtension:@"cikernel"];
    NSError *error;
    NSString *kernelCode = [NSString stringWithContentsOfURL:kernelURL
                                                    encoding:NSUTF8StringEncoding error:&error];
    
    NSArray *kernels = [CIKernel kernelsWithString:kernelCode];
    NSLog(@"kernels = %@", kernels);
    
    if (kernels.count) {
        CGFloat inputWidth = ciInputImg.extent.size.width;
        CIImage *resultCIImg = [kernels.firstObject applyWithExtent:ciInputImg.extent roiCallback:^CGRect(int index, CGRect destRect) {
            return destRect;
        } inputImage:ciInputImg arguments:@[@(inputWidth)]];
        
        CIContext *context = [[CIContext alloc] initWithOptions:nil];
        CGImageRef ref = [context createCGImage:resultCIImg fromRect:[resultCIImg extent]];
        UIImage *newImage = [UIImage imageWithCGImage:ref];
        CGImageRelease(ref);
        self.warpIV.image = newImage;
    }
}

// CIColorKernel
- (void)test1 {
    UIImage *originInputImg = [UIImage imageNamed:@"ic_hehua"];
    self.originIV.image = originInputImg;
    
    CIImage *ciInputImage = [[CIImage alloc] initWithImage:originInputImg];
    
    if (@available(iOS 11.0, *)) {
        NSURL *kernelURL = [[NSBundle mainBundle] URLForResource:@"haze" withExtension:@"cikernel"];
        NSError *error;
        NSString *kernelCode = [NSString stringWithContentsOfURL:kernelURL
                                                        encoding:NSUTF8StringEncoding error:&error];
        NSArray *kernels = [CIKernel kernelsWithString:kernelCode];
        NSLog(@"kernels = %@", kernels);
        
        if (kernels.count) {
            CISampler *src = [CISampler samplerWithImage:ciInputImage];
            CIColor *color = [CIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
            NSNumber *inputDistance = @0.2;
            NSNumber *inputSlope = @0;
            CIImage *resultCIImg = [kernels.firstObject applyWithExtent:ciInputImage.extent arguments:@[src, color, inputDistance, inputSlope]];
            
            CIContext *context = [[CIContext alloc] initWithOptions:nil];
            CGImageRef ref = [context createCGImage:resultCIImg fromRect:[resultCIImg extent]];
            UIImage *newImage = [UIImage imageWithCGImage:ref];
            CGImageRelease(ref);
            self.hazeIV.image = newImage;
        }
    } else {
        // Fallback on earlier versions
    }
}

- (void)test2 {
    UIImage *originInputImg = [UIImage imageNamed:@"makeup_color_upper-transaction_layer"];
    self.changeColorIV.image = originInputImg;
    
    CIImage *ciInputImage = [[CIImage alloc] initWithImage:originInputImg];
    
    if (@available(iOS 11.0, *)) {
        NSURL *kernelURL = [[NSBundle mainBundle] URLForResource:@"changeColor" withExtension:@"cikernel"];
        NSError *error;
        NSString *kernelCode = [NSString stringWithContentsOfURL:kernelURL
                                                        encoding:NSUTF8StringEncoding error:&error];
        NSArray *kernels = [CIKernel kernelsWithString:kernelCode];
        NSLog(@"kernels = %@", kernels);
        
        if (kernels.count) {
            CISampler *src = [CISampler samplerWithImage:ciInputImage];
            CIColor *color = [CIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
            CIImage *resultCIImg = [kernels.firstObject applyWithExtent:ciInputImage.extent arguments:@[src, color]];
            
            CIContext *context = [[CIContext alloc] initWithOptions:nil];
            CGImageRef ref = [context createCGImage:resultCIImg fromRect:[resultCIImg extent]];
            UIImage *newImage = [UIImage imageWithCGImage:ref];
            CGImageRelease(ref);
            self.changeColorIV.image = newImage;
        }
    } else {
        // Fallback on earlier versions
    }
}

- (void)test3 {
    UIImage *originFgImg = [UIImage imageNamed:@"makeup_color_upper-transaction_layer"];
    UIImage *originBgImg = [UIImage imageNamed:@"ic_hehua"];
    self.originIV.image = originBgImg;
    
    CIImage *ciFgImage = [[CIImage alloc] initWithImage:originFgImg];
//    CIImage *ciBgImage = [[CIImage alloc] initWithImage:originBgImg];
    
    if (@available(iOS 11.0, *)) {
        NSBundle *bundle = [NSBundle mainBundle];
        NSURL *kernelURL = [bundle URLForResource:@"a" withExtension:@"cikernel"];
        NSError *error;
        NSString *kernelCode = [NSString stringWithContentsOfURL:kernelURL
                                                        encoding:NSUTF8StringEncoding error:&error];
        
        NSArray *kernels = [CIKernel kernelsWithString:kernelCode];
        NSLog(@"kernels = %@", kernels);
        
        if (kernels.count) {
            //            CIImage *ciChangedImg = [kernels.firstObject applyWithForeground:ciFgImage background:ciBgImage];
            CGFloat inputWidth = ciFgImage.extent.size.width;
            CIImage *ciChangedImg = [kernels.firstObject applyWithExtent:ciFgImage.extent roiCallback:^CGRect(int index, CGRect destRect) {
                return destRect;
            } inputImage:ciFgImage arguments:@[@(inputWidth)]];
            
            CIContext *context = [[CIContext alloc] initWithOptions:nil];
            CGImageRef ref = [context createCGImage:ciChangedImg fromRect:[ciChangedImg extent]];
            UIImage *newImage = [UIImage imageWithCGImage:ref];
            CGImageRelease(ref);
            self.warpIV.image = newImage;
        }
    } else {
        // Fallback on earlier versions
    }
}

- (NSDictionary *)customAttributes {
    return @{
        @"inputDistance" :  @{
            kCIAttributeMin       : @0.0,
            kCIAttributeMax       : @1.0,
            kCIAttributeSliderMin : @0.0,
            kCIAttributeSliderMax : @0.7,
            kCIAttributeDefault   : @0.2,
            kCIAttributeIdentity  : @0.0,
            kCIAttributeType      : kCIAttributeTypeScalar
        },
        @"inputSlope" : @{
            kCIAttributeSliderMin : @-0.01,
            kCIAttributeSliderMax : @0.01,
            kCIAttributeDefault   : @0.00,
            kCIAttributeIdentity  : @0.00,
            kCIAttributeType      : kCIAttributeTypeScalar
        },
        kCIInputColorKey : @{
            kCIAttributeDefault : [CIColor colorWithRed:1.0
                                                  green:1.0
                                                   blue:1.0
                                                  alpha:1.0]
        },
    };
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
