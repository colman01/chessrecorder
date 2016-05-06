
//  ChessFilterViewController.m
//  chessrecorder
//
//  Created by colman on 23/09/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "ChessFilterViewController.h"
#import "ShowFrameViewController.h"
#import "CvMatUIImageConverter.h"
#include <opencv2/imgproc/imgproc.hpp>
#include "CheckerboardDetector.h"


@interface ChessFilterViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *subView;

@end

@implementation ChessFilterViewController

@synthesize someImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    filterType = GPUIMAGE_XYGRADIENT;

//    filterType = GPUIMAGE_CANNYEDGEDETECTION;
//    filterType =GPUIMAGE_CONVOLUTION;
//    filterType =GPUIMAGE_TRANSFORM3D;
    filterType = GPUIMAGE_FACES;
    
//    
//    filterType = GPUIMAGE_FILECONFIG;
//    filterType = GPUIMAGE_COLORINVERT;
    
    [self setupFilter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setupFilter;
{
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    //    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
    //    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1920x1080 cameraPosition:AVCaptureDevicePositionBack];
    //    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;

    BOOL needsSecondImage = NO;
    
    switch (filterType)
    {
        



        
        case GPUIMAGE_CONVOLUTION:
        {
            self.title = @"3x3 Convolution";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImage3x3ConvolutionFilter alloc] init];
            //            [(GPUImage3x3ConvolutionFilter *)filter setConvolutionKernel:(GPUMatrix3x3){
            //                {-2.0f, -1.0f, 0.0f},
            //                {-1.0f,  1.0f, 1.0f},
            //                { 0.0f,  1.0f, 2.0f}
            //            }];
            
            //            [(GPUImage3x3ConvolutionFilter *)filter setConvolutionKernel:(GPUMatrix3x3){
            //                {0.0f, 1.0f, 0.0f},
            //                {1.0f,  1.0f, 1.0f},
            //                { 0.0f,  1.0f, 0.0f}
            //            }];
            
            //            [(GPUImage3x3ConvolutionFilter *)filter setConvolutionKernel:(GPUMatrix3x3){
            //                {1.0f, 1.0f, 1.0f},
            //                {1.0f,  1.0f, 1.0f},
            //                { 1.0f,  1.0f, 1.0f}
            //            }];
            
//            [(GPUImage3x3ConvolutionFilter *)filter setConvolutionKernel:(GPUMatrix3x3){
//                {-1.0f,  0.0f, 1.0f},
//                {-2.0f, 0.0f, 2.0f},
//                {-1.0f,  0.0f, 1.0f}
//            }];
            
            [(GPUImage3x3ConvolutionFilter *)filter setConvolutionKernel:(GPUMatrix3x3){
                {0.0f, 1.0f, 0.0f},
                {1.0f,  1.0f, 1.0f},
                { 0.0f,  1.0f, 0.0f}
            }];
            
            
            //            [(GPUImage3x3ConvolutionFilter *)filter setConvolutionKernel:(GPUMatrix3x3){
            //                {1.0f,  1.0f, 1.0f},
            //                {1.0f, -8.0f, 1.0f},
            //                {1.0f,  1.0f, 1.0f}
            //            }];
            //            [(GPUImage3x3ConvolutionFilter *)filter setConvolutionKernel:(GPUMatrix3x3){
            //                { 0.11f,  0.11f, 0.11f},
            //                { 0.11f,  0.11f, 0.11f},
            //                { 0.11f,  0.11f, 0.11f}
            //            }];
        }; break;
        
            
        case GPUIMAGE_FACES:
        {
            self.title = @"Face Detection";

            [self.filterSettingsSlider setValue:0.5];
            filter = [[GPUImageBrightnessFilter alloc] init];
            
            [videoCamera setDelegate:self];
            break;
        }
            
            

            
    }
        if (filterType != GPUIMAGE_VORONOI)
        {
            [videoCamera addTarget:filter];
        }
        
    videoCamera.runBenchmark = NO;
    GPUImageView *filterView = (GPUImageView *)self.view;
        


    [filter addTarget:filterView];
    [videoCamera startCameraCapture];
}

#pragma mark -
#pragma mark Filter adjustments

- (IBAction)updateFilterFromSlider:(id)sender;
{
    [videoCamera resetBenchmarkAverage];
    switch(filterType)
    {
        case GPUIMAGE_CANNYEDGEDETECTION: [(GPUImageCannyEdgeDetectionFilter *)filter setBlurTexelSpacingMultiplier:[(UISlider*)sender value]]; break;
        
    }
}

#pragma mark - Face Detection Delegate Callback
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    UIImage *img = [self imageFromSamplePlanerPixelBuffer:sampleBuffer];
    
    if(!_busy) {
        [self performSelectorInBackground:@selector(findBoardMove:) withObject:img];
    }
    
    
    
    
}

-(void)findBoardMove:(UIImage *) img {
    _busy = YES;
    cv::Mat srcImg = [CvMatUIImageConverter cvMatFromUIImage:img];
    cv::Point2f* src = (cv::Point2f*) malloc(4 * sizeof(cv::Point2f));
    cv::Point2f* dst = (cv::Point2f*) malloc(4 * sizeof(cv::Point2f));
    
    int dstImgSize = 400;
    std::vector<cv::Point2f> detectedCorners = CheckDet::getOuterCheckerboardCorners(srcImg);
    for (int i = 0; i < MIN(4, detectedCorners.size()); i++) {
        cv::circle(srcImg, cv::Point2i(detectedCorners[i].x, detectedCorners[i].y), 7, cv::Scalar(127, 127, 255), -1);
        src[i] = detectedCorners[i];
    }
    cv::Mat m = cv::getPerspectiveTransform(src, dst);
    
    //    printf("    output\n");
    //    for(int i = 0; i < m.rows; i++) {
    //        const double* mi = m.ptr<double>(i);
    //        printf("        ( ");
    //        for(int j = 0; j < m.cols; j++) {
    //            printf("%8.1f ", mi[j]);
    //        }
    //        printf(")\n");
    //    }
    free(dst);
    free(src);
    
    cv::Mat plainBoardImg;
    cv::warpPerspective(srcImg, plainBoardImg, m, cv::Size(dstImgSize, dstImgSize));
    
    ShowFrameViewController *parent = (ShowFrameViewController *)self.parentViewController;
    
    UIImage* combinedImg = [CvMatUIImageConverter UIImageFromCVMat:srcImg];
    UIImage *plain = [self UIImageFromCVMat:plainBoardImg];
    dispatch_async(dispatch_get_main_queue(), ^{[parent.imgView setImage:combinedImg]; [parent.subView setImage:plain];self.imgView.image = combinedImg; _busy=NO;});
}


-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    colorSpace = CGColorSpaceCreateDeviceGray();
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        
                                        
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}


- (void) parseBuffer:(CMSampleBufferRef) sampleBuffer
{
    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress( pixelBuffer, 0 );
    
    //Processing here
    int bufferWidth = CVPixelBufferGetWidth(pixelBuffer);
    int bufferHeight = CVPixelBufferGetHeight(pixelBuffer);
    unsigned char *pixel = (unsigned char *)CVPixelBufferGetBaseAddress(pixelBuffer);
    
    // put buffer in open cv, no memory copied
    cv::Mat mat = cv::Mat(bufferHeight,bufferWidth,CV_8UC4,pixel);
    
    //End processing
    CVPixelBufferUnlockBaseAddress( pixelBuffer, 0 );
    
    cv::Point2f* src = (cv::Point2f*) malloc(4 * sizeof(cv::Point2f));
    cv::Point2f* dst = (cv::Point2f*) malloc(4 * sizeof(cv::Point2f));
    
    int dstImgSize = 400;

    std::vector<cv::Point2f> detectedCorners = CheckDet::getOuterCheckerboardCorners(mat);
    for (int i = 0; i < MIN(4, detectedCorners.size()); i++) {
        cv::circle(mat, cv::Point2i(detectedCorners[i].x, detectedCorners[i].y), 7, cv::Scalar(127, 127, 255), -1);
        src[i] = detectedCorners[i];
    }

//    printf("getPerspectiveTransform\n");
//    printf("    input\n");
//    for (int i = 0; i < 4; i++) {
//        printf("        (%5.1f, %5.1f) -> (%5.1f, %5.1f)\n", src[i].x, src[i].y, dst[i].x, dst[i].y);
//    }
    
    cv::Mat m = cv::getPerspectiveTransform(src, dst);
    
//    printf("    output\n");
//    for(int i = 0; i < m.rows; i++) {
//        const double* mi = m.ptr<double>(i);
//        printf("        ( ");
//        for(int j = 0; j < m.cols; j++) {
//            printf("%8.1f ", mi[j]);
//        }
//        printf(")\n");
//    }
    free(dst);
    free(src);
    
    
}

// Create a UIImage from sample buffer data
// Works only if pixel format is kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
-(UIImage *) imageFromSamplePlanerPixelBuffer:(CMSampleBufferRef) sampleBuffer{
    
    @autoreleasepool {
        // Get a CMSampleBuffer's Core Video image buffer for the media data
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        // Lock the base address of the pixel buffer
        CVPixelBufferLockBaseAddress(imageBuffer, 0);
        
        // Get the number of bytes per row for the plane pixel buffer
        void *baseAddress = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
        
        // Get the number of bytes per row for the plane pixel buffer
        size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer,0);
        // Get the pixel buffer width and height
        size_t width = CVPixelBufferGetWidth(imageBuffer);
        size_t height = CVPixelBufferGetHeight(imageBuffer);
        
        // Create a device-dependent gray color space
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        
        // Create a bitmap graphics context with the sample buffer data
        CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                     bytesPerRow, colorSpace, kCGImageAlphaNone);
        // Create a Quartz image from the pixel data in the bitmap graphics context
        CGImageRef quartzImage = CGBitmapContextCreateImage(context);
        // Unlock the pixel buffer
        CVPixelBufferUnlockBaseAddress(imageBuffer,0);
        
        // Free up the context and color space
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        
        // Create an image object from the Quartz image
        UIImage *image = [UIImage imageWithCGImage:quartzImage];
        
        // Release the Quartz image
        CGImageRelease(quartzImage);
        
        
        return (image);
    }
}




@end
