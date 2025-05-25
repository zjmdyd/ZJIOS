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

/*
 滤镜名称           算法特点                    适用场景
 ‌‌CIBoxBlur‌       均值模糊，计算简单快速      需要高性能的轻度模糊
 ‌‌CIGaussianBlur‌  高斯分布加权，效果更平滑     高质量模糊需求
 ‌‌CIMotionBlur‌    模拟动态模糊效果           运动轨迹模糊
 */
- (void)test0 {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *originImg = [UIImage imageNamed:@"beautiful_1"];
        CIImage *image = [[CIImage alloc] initWithImage:originImg];
        
        CIFilter *filter = [CIFilter filterWithName:@"CIBoxBlur" keysAndValues:kCIInputImageKey, image, nil];
        [filter setValue:@8.0 forKey:kCIInputRadiusKey];
        [filter setDefaults];
        
        CIContext *context = [[CIContext alloc] initWithOptions:nil];
        CIImage *output = [filter outputImage];
        
        CGImageRef ref = [context createCGImage:output fromRect:[output extent]];
        UIImage *newImage = [UIImage imageWithCGImage:ref];
        CGImageRelease(ref);
                
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat width = self.view.bounds.size.width;
            CGFloat height = (self.view.bounds.size.height-100)/2;
            UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, width, height)];
            imageView1.contentMode = UIViewContentModeScaleAspectFill;
            imageView1.image = originImg;
            [self.view addSubview:imageView1];
            
            UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100 + height, width, height)];
            imageView2.image = newImage;
            imageView2.contentMode = UIViewContentModeScaleAspectFill;
            [self.view addSubview:imageView2];
        });
    });
}

/*
 ‌1. 基本概念‌
 CIFilter 是 iOS/macOS 中 CoreImage框架的核心类，用于对图像进行实时处理或生成特效。它封装了多种滤镜算法，涵盖色彩调整、模糊、扭曲等操作12。关键组件包括：
 ‌‌CIContext‌：图像处理的上下文环境，管理 GPU/CPU 资源，负责实际渲染。
 ‌‌CIImage‌：表示输入/输出的图像数据，支持从 UIImage、文件路径或像素数据初始化。
 ‌‌CIFilter‌：滤镜实例，通过键值对（KVC）配置参数（如模糊半径、颜色参数）。
 ‌‌2. 常用滤镜分类‌
 分类（kCICategory）        典型滤镜示例                      应用场景
 ‌‌Blur‌                CIGaussianBlur、CIBoxBlur        背景虚化、降噪处理
 ‌‌ColorAdjustment‌     CIColorControls、CIHueAdjust     调整亮度、饱和度、色调
 ‌‌Stylize‌             CIVignette、CIPixellate          风格化（暗角、像素化）
 ‌‌DistortionEffect‌    CIBumpDistortion                 图像扭曲特效
 ‌‌Generator‌           CIQRCodeGenerator                生成二维码、条纹图案
 ‌‌3. 基本使用流程‌
 ‌‌步骤1：创建滤镜实例‌

 swift
 // 创建高斯模糊滤镜
 let filter = CIFilter(name: "CIGaussianBlur")!
 ‌‌步骤2：配置输入参数‌

 // 设置输入图像和模糊半径
 let inputImage = CIImage(image: originalImage)!
 filter.setValue(inputImage, forKey: kCIInputImageKey)
 filter.setValue(8.0, forKey: kCIInputRadiusKey)
 ‌‌步骤3：获取输出并渲染‌
 // 获取处理后的 CIImage
 guard let outputImage = filter.outputImage else { return }
 
 // 使用 CIContext 转换为 UIImage
 let context = CIContext(options: nil)
 if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
     let resultImage = UIImage(cgImage: cgImage)
 }
 
 ‌‌4. 性能优化建议‌
 ‌‌复用 CIContext‌
 static let sharedContext = CIContext()  // 全局复用减少资源开销
 ‌‌控制滤镜参数范围‌
 通过 filter.attributes 查询支持的参数值域，避免非法设定导致性能下降。
 ‌‌优先使用 GPU 加速‌
 默认 CIContext 使用 GPU 渲染，复杂滤镜链建议禁用 CPU 回退：
 let context = CIContext(options: [CIContextOption.useSoftwareRenderer: false])

 ‌5. 实际应用示例‌
 ‌‌生成二维码（CIQRCodeGenerator）
 // 创建二维码滤镜
 let filter = CIFilter(name: "CIQRCodeGenerator")!
 filter.setValue("Hello, World!".data(using: .utf8), forKey: "inputMessage")
 filter.setValue("H", forKey: "inputCorrectionLevel")  // 纠错级别

 // 获取二维码图像并调整大小
 if let outputImage = filter.outputImage {
     let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
 }
 
 注意事项‌
 部分滤镜（如 CIColorInvert）对实时视频处理性能要求较高，需结合 AVFoundation 框架优化。
 滤镜链过长可能导致内存激增，建议分步处理或使用 CIImageProcessorKernel 自定义高效滤镜
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
