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
    [self test1];
    [self test2];
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
        self.imgs[1] = [UIImage imageWithCIImage:resultCIImg];
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]]];
    }
}

- (void)test1 {
    UIImage *originInputImg = [UIImage imageNamed:@"ic_hehua"];
    CIImage *ciInputImg = [[CIImage alloc] initWithImage:originInputImg];
    NSURL *kernelURL = [[NSBundle mainBundle] URLForResource:@"b" withExtension:@"cikernel"];
    NSError *error;
    NSString *kernelCode = [NSString stringWithContentsOfURL:kernelURL
                                                    encoding:NSUTF8StringEncoding error:&error];
    NSArray *kernels = [CIKernel kernelsWithString:kernelCode];
    NSLog(@"kernels = %@", kernels);
    
    if (kernels.count) {
        CIImage *resultCIImg = [kernels.firstObject applyWithExtent:ciInputImg.extent roiCallback:^CGRect(int index, CGRect destRect) {
            return destRect;
        } inputImage:ciInputImg arguments:@[@(0.5)]];
        self.imgs[2] = [UIImage imageWithCIImage:resultCIImg];
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]]];
    }
}

// CIColorKernel
- (void)test2 {
    UIImage *originInputImg = [UIImage imageNamed:@"ic_hehua"];
    CIImage *ciInputImage = [[CIImage alloc] initWithImage:originInputImg];
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
        self.imgs[3] = [UIImage imageWithCIImage:resultCIImg];
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]]];
    }
}

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
