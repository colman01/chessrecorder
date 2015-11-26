//
//  AugmentedRealityViewController.m
//  chessrecorder
//
//  Created by colman on 01/10/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "AugmentedRealityViewController.h"

@interface AugmentedRealityViewController ()

@end

@implementation AugmentedRealityViewController

@synthesize cameraView;
@synthesize historyViewer, working;
@synthesize imageFrame, showImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareCamera];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) prepareCamera {
//    CGRect mainScreenFrame = [[UIScreen mainScreen] applicationFrame];
//    UIView *primaryView = [[UIView alloc] initWithFrame:mainScreenFrame] ;
//    primaryView.backgroundColor = [UIColor blueColor];
//    self.view = primaryView;
    
    if(!historyViewer) {
        videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
        videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        pipeline = [[GPUImageFilterPipeline alloc] initWithOrderedFilters:nil input:videoCamera output:self.cameraView];
    
        [videoCamera startCameraCapture];
    }
    
//    self.imageFrame = videoCamera.imageFrame;
//    self.showImage.image = videoCamera.imageFrame;
    [self.showImage setImage:imageFrame];
}

//- (void)processVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;

//- (void)captureOutput:(AVCaptureOutput *)captureOutput
//didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
//       fromConnection:(AVCaptureConnection *)connection
//{
//    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//    CVPixelBufferLockBaseAddress(imageBuffer, 0);
//    
//    // For the iOS the luma is contained in full plane (8-bit)
//    size_t width = CVPixelBufferGetWidthOfPlane(imageBuffer, 0);
//    size_t height = CVPixelBufferGetHeightOfPlane(imageBuffer, 0);
//    size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0);
//    
//    Pixel_8 *lumaBuffer = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
//    
//    const vImage_Buffer inImage = { lumaBuffer, height, width, bytesPerRow };
//    
//    Pixel_8 *outBuffer = (Pixel_8 *)calloc(width*height, sizeof(Pixel_8));
//    const vImage_Buffer outImage = { outBuffer, height, width, bytesPerRow };
//    [self maxFromImage:inImage toImage:outImage];
//    
//    CGColorSpaceRef grayColorSpace = CGColorSpaceCreateDeviceGray();
//    CGContextRef context = CGBitmapContextCreate(outImage.data, width, height, 8, bytesPerRow, grayColorSpace, kCGBitmapByteOrderDefault);
//    CGImageRef dstImageFilter = CGBitmapContextCreateImage(context);
//    
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        _customPreviewLayer.contents = (__bridge id)dstImageFilter;
//    });
//    
//    free(outBuffer);
//    CGImageRelease(dstImageFilter);
//    CGContextRelease(context);
//    CGColorSpaceRelease(grayColorSpace);
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
