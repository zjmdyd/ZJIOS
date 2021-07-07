//
//  ZJChoosePhotoTableViewController.m
//  WeiMing
//
//  Created by Zengjian on 2018/3/13.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "ZJChoosePhotoTableViewController.h"

#ifdef ZJMMPopupView
#import <MMPopupView/MMSheetView.h>
#endif

#ifdef ZJVPImageCropper
#import "VPImageCropperViewController.h"
#endif

#ifdef ZJMWPhotoBrowser
#import "MWPhotoBrowser.h"
#endif

@interface ZJChoosePhotoTableViewController ()
#if (defined ZJMMPopupView) && (defined ZJVPImageCropper) && (defined ZJMWPhotoBrowser)
<VPImageCropperDelegate, MWPhotoBrowserDelegate>
#endif

@end

@implementation ZJChoosePhotoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - 头像

- (void)chooseImageIsAddNew:(BOOL)isAdd completion:(ChoosePhotoCompletion)cmpt {
    __weak typeof(self) weakSelf = self;
    weakSelf.compeletion = cmpt;
    
#ifdef ZJMMPopupView
    MMPopupItemHandler block = ^(NSInteger index) {
        switch (index) {
            case 0:
                [weakSelf chooseImageFromLibary];
                break;
            case 1:
                [weakSelf chooseImageFromCamera];
                break;
            case 2:
                [weakSelf browserThePhoto];
                break;
            default:
                break;
        }
    };
    
    NSMutableArray *items =
    @[
      MMItemMake(@"相册", MMItemTypeNormal, block),
      MMItemMake(@"拍照", MMItemTypeNormal, block)
      ].mutableCopy;
    
    if (!isAdd) {
        [items addObject:MMItemMake(@"查看照片", MMItemTypeNormal, block)];
    }
    
    [[[MMSheetView alloc] initWithTitle:nil items:items] showWithBlock:nil];
#endif
}

- (void)chooseImageFromLibary {
    [self pickImageWithType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)chooseImageFromCamera {
    [self pickImageWithType:UIImagePickerControllerSourceTypeCamera];
}

- (void)pickImageWithType:(UIImagePickerControllerSourceType)type {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if (![UIImagePickerController isSourceTypeAvailable:type]) {
#ifdef ShowProgress
        ShowProgressView(@"设备不支持该操作", 1.0, MBProgressHUDModeText); return;
#endif
    }
    picker.delegate = self;
    picker.sourceType = type;
#ifdef MainColor
    picker.navigationBar.barTintColor = [UIColor mainColor];
#endif
    picker.navigationBar.tintColor = [UIColor whiteColor];
    picker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    if (self.rootVC) {
        [self.rootVC.navigationController presentViewController:picker animated:YES completion:^{}];
    }else {
        [self.navigationController presentViewController:picker animated:YES completion:^{}];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        if (!portraitImg) {
#ifdef ShowProgress
            ShowProgressView(@"此张照片格式不符合,请重新选择", 2.0, MBProgressHUDModeText); return;
#endif
        }
        // present the cropper view controller
#ifdef ZJVPImageCropper
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgCropperVC.confirmTitle = @"确定";
        imgCropperVC.cancelTitle = @"取消";
        imgCropperVC.delegate = self;
        if (self.rootVC) {
            [self.rootVC presentViewController:imgCropperVC animated:YES completion:^{
                // TO DO
            }];
        }else {
            [self presentViewController:imgCropperVC animated:YES completion:^{
                // TO DO
            }];
        }
#endif
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - VPImageCropperDelegate

#ifdef ZJVPImageCropper

- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    __weak typeof(self) weekSelf = self;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        UIImage *scaledImage = editedImage;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        
        NSString *name = [NSDate todayTimestampString];
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", name]];   // 保存文件的名称
        NSLog(@"imagePath = %@", filePath);
        
        // 保存成功会返回YES
        BOOL result = [UIImageJPEGRepresentation(scaledImage, 1.0) writeToFile:filePath atomically:YES];
        weekSelf.selectPhotoSuccess = result;
        weekSelf.compeletion(result, filePath);
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{}];
}

#endif

#pragma mark - 图片浏览

- (void)browserThePhoto {
#ifdef ZJMWPhotoBrowser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayNavArrows = YES;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = YES;
    //设置当前要显示的图片
    [browser setCurrentPhotoIndex:self.currentIdx];
    //push到MWPhotoBrowser
    
    if (self.rootVC) {
        [self.rootVC.navigationController pushViewController:browser animated:YES];
    }else {
        [self.navigationController pushViewController:browser animated:YES];
    }
#endif
}

#ifdef ZJMWPhotoBrowser

#pragma mark - MWPhotoBrowserDelegate

//返回图片个数

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count - (self.hasEmptyImage ? 1:0);
}

//返回图片模型
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    //创建图片模型
    NSString *path = self.photos[index];
    MWPhoto *photo;
    if ([path isOnlinePic]) {
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:path]];
    }else {
        photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:path]];
    }
    
    return photo;
}

#endif

- (void)showImageAtIndex:(NSInteger)index {
    self.currentIdx = index;
    [self browserThePhoto];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
#ifdef ZJNaviCtrl
    if ([self.navigationController isKindOfClass:[ZJNavigationController class]]) {
        ((ZJNavigationController *)self.navigationController).navigationBarShadowColor = [UIColor clearColor];
    }
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
