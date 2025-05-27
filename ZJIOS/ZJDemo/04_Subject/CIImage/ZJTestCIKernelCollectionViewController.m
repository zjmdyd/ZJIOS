//
//  ZJTestCIKernelCollectionViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2025/5/26.
//

#import "ZJTestCIKernelCollectionViewController.h"
#import "ZJKernelCollectionViewCell.h"

@interface ZJTestCIKernelCollectionViewController ()

@property (nonatomic, strong) NSArray *cellTitles;
@property (nonatomic, strong) NSMutableArray *imgs;

@end

@implementation ZJTestCIKernelCollectionViewController

static NSString * const reuseIdentifier = @"KernelCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZJKernelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    

    // Do any additional setup after loading the view.
    self.cellTitles = @[@"originInputImg", @"CIWarpKernel/mirrorX", @"CIWarpKernel/scaleX", @"CIColorKernel/haze", @"originInputImg", @"CIColorKernel/changeColor"];
    UIImage *img0 = [UIImage imageNamed:@"ic_hehua"];
    UIImage *img1 = [UIImage imageNamed:@"makeup_color_upper-transaction_layer"];
    self.imgs = @[img0, img0, img0, img0, img1, img0].mutableCopy;
    [self performSelector:@selector(test) withObject:nil afterDelay:0.05];
}

- (void)test {
    [self test0];
//    [self test1];
//    [self test2];
    [self test3];
}

/*
 extent         CGRect                      输出图像的尺寸范围，通常与输入图像一致1。
 roiCallback    (Int, CGRect) -> CGRect     回调函数，根据输出区域返回输入图像中对应的处理区域26。
 inputImage     CIImage                     待处理的输入图像12。
 arguments      [Any]                       传递给内核的动态参数数组（如浮点数、向量等)
 
 CIImage *resultCIImg = [kernels.firstObject applyWithExtent:ciInputImg.extent roiCallback:^CGRect(int index, CGRect destRect) {
     return destRect;
 } inputImage:ciInputImg arguments:@[@(inputWidth)]];
 // CIImage-->UIImage:法1
 CIContext *context = [[CIContext alloc] initWithOptions:nil];
 CGImageRef ref = [context createCGImage:resultCIImg fromRect:[resultCIImg extent]];
 UIImage *newImage1 = [UIImage imageWithCGImage:ref];
 // CIImage-->UIImage:法2
 UIImage *newImage2 = [UIImage imageWithCIImage:resultCIImg];
 */
// CIWarpKernel
- (void)test0 {
    UIImage *originInputImg = [UIImage imageNamed:@"ic_hehua"];

    NSArray *ary = @[@"a", @"b", @"haze"];
    for (int i = 0; i < ary.count; i++) {
        CIImage *ciInputImg = [[CIImage alloc] initWithImage:originInputImg];
        NSURL *kernelURL = [[NSBundle mainBundle] URLForResource:ary[i] withExtension:@"cikernel"];
        NSError *error;
        NSString *kernelCode = [NSString stringWithContentsOfURL:kernelURL
                                                        encoding:NSUTF8StringEncoding error:&error];
        NSArray *kernels = [CIKernel kernelsWithString:kernelCode];
        NSLog(@"kernels = %@", kernels);
        
        if (kernels.count) {
            NSArray *arguments = @[];
            CIImage *resultCIImg;
            if (i < 2) {
                if (i == 0) {
                    arguments = @[@(ciInputImg.extent.size.width)];
                }else {
                    arguments = @[@0.5];
                }
                resultCIImg = [kernels.firstObject applyWithExtent:ciInputImg.extent roiCallback:^CGRect(int index, CGRect destRect) {
                    return destRect;
                } inputImage:ciInputImg arguments:arguments];
            }else {
                CISampler *src = [CISampler samplerWithImage:ciInputImg];
                CIColor *color = [CIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
                NSNumber *inputDistance = @0.2;
                NSNumber *inputSlope = @0;
                resultCIImg = [kernels.firstObject applyWithExtent:ciInputImg.extent arguments:@[src, color, inputDistance, inputSlope]];
            }

            self.imgs[i+1] = [UIImage imageWithCIImage:resultCIImg];
            [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:i+1 inSection:0]]];
        }
    }
}

/*
 // Listing 9-1  A kernel routine for the haze removal filter

 kernel vec4 myHazeRemovalKernel(sampler src,             // 1
                      __color color,
                     float distance,
                     float slope)
 {
     vec4   t;
     float  d;
  
     d = destCoord().y * slope  +  distance;              // 2
     t = unpremultiply(sample(src, samplerCoord(src)));   // 3
     t = (t - d*color) / (1.0-d);                         // 4
  
     return premultiply(t);                               // 5
 }
 代码如下：

 1.接受四个输入参数并返回一个向量。在声明过滤器的接口时，必须确保声明与在内核中指定的相同数量的输入参数。内核必须返回一个vec4数据类型。
 2.根据目标坐标的y值和斜率和距离输入参数计算一个值。destCoord例程（由Core Image提供）返回当前正在计算的像素在工作空间坐标中的位置。
 3.在应用与src关联的任何变换矩阵之后，获取采样器src中与当前输出像素关联的采样器空间中的像素值。回想一下，Core
 Image使用颜色组件与预乘alpha值。在处理之前，您需要对从采样器收到的颜色值进行无预处理。
 4.通过应用除雾公式计算输出矢量，该公式包含颜色的斜率、距离计算和调整。
 
 5.根据需要返回一个vec4向量。内核在返回结果之前执行预乘操作，因为Core Image使用带有预乘alpha值的颜色分量。
*/
- (void)test3 {
    UIImage *originInputImg = [UIImage imageNamed:@"makeup_color_upper-transaction_layer"];
    CIImage *ciInputImage = [[CIImage alloc] initWithImage:originInputImg];
    
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
        self.imgs[5] = [UIImage imageWithCIImage:resultCIImg];
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]]];
    }
}

/*
 ‌Core Image CISampler 核心解析‌
 ‌‌1. 基本概念‌
 CISampler 是 Core Image 框架中用于图像采样（Texture Sampling）的类，主要用于定义如何从输入图像中读取像素数据，包括采样位置、插值方式等参数13。其核心作用包括：

 ‌‌纹理坐标映射‌：将图像坐标转换为实际采样位置。
 ‌‌插值策略控制‌：指定像素采样时的插值算法（如线性插值、最近邻插值）。
 ‌‌边缘处理‌：定义图像边界外的采样行为（镜像、重复、填充颜色等）。
 常用于创建自定义滤镜时，控制图像数据的读取方式
 
 // 创建默认采样器（使用默认参数）
 CISampler *sampler = [CISampler samplerWithImage:inputCIImage];

 // 自定义采样选项（如插值方式）
 NSDictionary *options = @{ kCISamplerFilterMode: kCISamplerFilterLinear };
 CISampler *customSampler = [CISampler samplerWithImage:inputCIImage options:options];

 ‌(2) 关键参数配置‌
 参数键（Key）    作用描述    可选值示例
 kCISamplerFilterMode    插值算法选择    kCISamplerFilterNearest、kCISamplerFilterLinear
 kCISamplerWrapMode      边界处理模式    kCISamplerWrapClamp、kCISamplerWrapRepeat
 kCISamplerColorSpace    输入图像色彩空间映射    CGColorSpace 实例
 
 // Metal Shader 内使用采样器
 kernel vec4 customFilter(sampler src) {
     vec2 coord = samplerCoord(src);
     vec4 color = sample(src, coord);
     // 处理颜色并返回
     return color * vec4(0.5);
 }
 
 ‌sample() 方法详解‌
 ‌‌1. 功能定义‌
 ‌‌核心作用‌：sample() 是 Core Image Kernel Language (CIKL) 中的内置函数，用于从采样器（sampler）中获取指定坐标的像素颜色值37。
 ‌‌返回值‌：返回 vec4 类型（RGBA颜色值），若坐标越界则返回透明色（vec4(0.0)）
 vec4 sample(sampler src, vec2 coord)
 ‌src‌：绑定到输入图像的采样器对象。
 ‌‌coord‌：纹理坐标（通常通过 samplerCoord() 或手动计算获取），需为归一化值（范围 [0, 1]）
 以下代码演示如何通过 sample() 实现图像边缘检测：
 let kernelCode = """
 kernel vec4 edgeDetection(sampler image) {
     vec2 coord = samplerCoord(image);
     vec4 center = sample(image, coord);
     vec4 left = sample(image, coord - vec2(0.01, 0.0)); // 左邻像素
     vec4 right = sample(image, coord + vec2(0.01, 0.0)); // 右邻像素
     float edge = length(left.rgb - right.rgb); // 计算梯度
     return vec4(vec3(edge), center.a);
 }
 """
 ‌说明‌：通过对比相邻像素颜色差异实现简单边缘检测
 
 ‌unpremultiply 方法详解‌
 ‌‌1. 功能定义‌
 ‌‌核心作用‌：unpremultiply 是一种图像处理操作，用于将预乘（premultiplied）的 RGBA 颜色值还原为非预乘格式4。
 ‌‌数学原理‌：对预乘颜色的每个通道（R、G、B）除以 Alpha 值（A），公式为：
 R_unpremultiplied = R_premultiplied / A
 G_unpremultiplied = G_premultiplied / A
 B_unpremultiplied = B_premultiplied / A
 若 Alpha 为 0，则结果通常置为 04。
 ‌‌2. 使用场景‌
 ‌‌图像合成‌：在混合多层图像时，需将预乘格式还原以正确应用透明度4。
 ‌‌滤镜处理‌：某些 Core Image 滤镜要求输入为非预乘颜色数据4。
 ‌‌3. 代码示例（Core Image 内核）‌
 以下 CIKL 代码实现 unpremultiply 操作
 kernel vec4 unpremultiplyColor(sampler src) {
     vec4 color = sample(src, samplerCoord(src));
     if (color.a > 0.0) {
         color.rgb /= color.a; // 还原非预乘颜色
     }
     return color;
 }
 说明‌：通过采样输入颜色并除以 Alpha 值实现还原
 
 
 自定义去雾内核 myHazeRemovalKernel 实现指南‌
 ‌‌1. 核心设计思路‌
 去雾算法通常基于大气散射模型，需结合透射率估计与大气光恢复。以下是结合暗通道先验（Dark Channel Prior）的简化实现思路25：

 ‌‌暗通道计算‌：取局部区域（如3×3）内RGB通道最小值作为暗通道估计。
 ‌‌大气光估计‌：选择暗通道中亮度最高的像素作为候选大气光值。
 ‌‌透射率优化‌：通过暗通道与大气光的比值计算透射率，并进行平滑约束。
 ‌‌2. CIKL 内核代码示例‌
 以下代码展示基于暗通道先验的快速去雾实现：
 kernel vec4 myHazeRemovalKernel(sampler inputImage, float intensity) {
     // 获取当前坐标并采样颜色
     vec2 coord = samplerCoord(inputImage);
     vec4 color = sample(inputImage, coord);
     
     // 暗通道计算（3x3邻域最小值）
     vec3 minColor = color.rgb;
     for (float dx = -1.0; dx <= 1.0; dx += 1.0) {
         for (float dy = -1.0; dy <= 1.0; dy += 1.0) {
             vec2 offset = vec2(dx, dy) * 0.003; // 调整偏移量适应纹理尺寸
             vec4 neighbor = sample(inputImage, coord + offset);
             minColor = min(minColor, neighbor.rgb);
         }
     }
     float darkChannel = min(min(minColor.r, minColor.g), minColor.b);
     
     // 透射率估计（简化公式）
     float transmission = 1.0 - intensity * darkChannel;
     transmission = clamp(transmission, 0.3, 0.9); // 约束范围避免过度增强
     
     // 大气光恢复（取全局最大值简化）
     float A = 0.95; // 根据场景调整或动态计算
     
     // 去雾公式
     vec3 result = (color.rgb - A * (1.0 - transmission)) / max(transmission, 0.1);
     
     // 限制颜色范围并返回
     return vec4(clamp(result, 0.0, 1.0), color.a);
 }
 ‌3. 关键参数说明‌
 ‌‌intensity‌：控制去雾强度（推荐范围 0.8~1.2）。
 ‌‌A‌：大气光估计值，可静态设定或通过动态计算优化56。
 ‌‌transmission‌：透射率调节，直接影响去雾效果与细节保留6。
 ‌‌4. 优化建议‌
 ‌‌性能优化‌：
 减少邻域搜索范围（如改用2×2邻域）5。
 预计算暗通道并复用中间结果6。
 ‌‌算法改进‌：
 引入引导滤波（Guided Filter）优化透射率平滑度6。
 结合自适应补丁选择（如PMS-Net思路）提升复杂场景效果
 */
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellTitles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZJKernelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.title = self.cellTitles[indexPath.row];
    cell.img = self.imgs[indexPath.row];
        
    return cell;
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (self.view.frame.size.width-1) / 2;
    if (indexPath.row > 3) {
        return CGSizeMake(width, width);
    }
    return CGSizeMake(width, width*1.6);
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
