
//  ChessFilterViewController.m
//  chessrecorder
//
//  Created by colman on 23/09/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "ChessFilterViewController.h"
#import "ShowFrameViewController.h"
#import "ShowFramePadViewController.h"
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

    filterType = GPUIMAGE_FACES;
    
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

    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;

    BOOL needsSecondImage = NO;
    
    switch (filterType)
    {
        
        case GPUIMAGE_CONVOLUTION:
        {
            self.title = @"3x3 Convolution";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImage3x3ConvolutionFilter alloc] init];
            
            [(GPUImage3x3ConvolutionFilter *)filter setConvolutionKernel:(GPUMatrix3x3){
                {0.0f, 1.0f, 0.0f},
                {1.0f,  1.0f, 1.0f},
                { 0.0f,  1.0f, 0.0f}
            }];
            

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

//#pragma mark -
//#pragma mark Filter adjustments
//
//- (IBAction)updateFilterFromSlider:(id)sender;
//{
//    [videoCamera resetBenchmarkAverage];
////    switch(filterType)
////    {
////        case GPUIMAGE_CANNYEDGEDETECTION: [(GPUImageCannyEdgeDetectionFilter *)filter setBlurTexelSpacingMultiplier:[(UISlider*)sender value]]; break;
////        
////    }
//}

#pragma mark - Face Detection Delegate Callback
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    UIImage *img = [self imageFromSamplePlanerPixelBuffer:sampleBuffer];
    
    if(!_busy) {
        [self performSelectorInBackground:@selector(findBoardMove:) withObject:img];
    }
    
    
    
    
}

-(void)findBoardMove:(UIImage *) img {
    _busy = YES;
    
    ShowFramePadViewController *parent = (ShowFramePadViewController *)self.parentViewController;
    
    
    cv::Mat srcImg = [CvMatUIImageConverter cvMatFromUIImage:img];
    cv::Point2f* src = (cv::Point2f*) malloc(4 * sizeof(cv::Point2f));
    cv::Point2f* dst = (cv::Point2f*) malloc(4 * sizeof(cv::Point2f));
    
    int dstImgSize = 400;
    std::vector<cv::Point2f> detectedCorners = CheckDet::getOuterCheckerboardCorners(srcImg);
    for (int i = 0; i < MIN(4, detectedCorners.size()); i++) {
        cv::circle(srcImg, cv::Point2i(detectedCorners[i].x, detectedCorners[i].y), 7, cv::Scalar(127, 127, 255), -1);
        src[i] = detectedCorners[i];
    }
    
    
    
    for (int i = 0; i < MIN(4, detectedCorners.size()); i++) {
        src[i] = detectedCorners[i];
    }
    
    dst[0] = cv::Point2f(dstImgSize / 8    , dstImgSize / 8    );
    dst[1] = cv::Point2f(dstImgSize / 8 * 7, dstImgSize / 8    );
    dst[2] = cv::Point2f(dstImgSize / 8 * 7, dstImgSize / 8 * 7);
    dst[3] = cv::Point2f(dstImgSize / 8    , dstImgSize / 8 * 7);
    
    cv::Mat m = cv::getPerspectiveTransform(src, dst);
    
    free(dst);
    free(src);
    
    UIImage *fieldImage = [[UIImage alloc] init];
    GPUImageCannyEdgeDetectionFilter *canny = [[GPUImageCannyEdgeDetectionFilter alloc] init];
    
    
    cv::Mat plainBoardImg;
    
    cv::Mat srcImgCopy = [CvMatUIImageConverter cvMatFromUIImage:img];
    cv::warpPerspective(srcImgCopy, plainBoardImg, m, cv::Size(dstImgSize, dstImgSize));
    cv::transpose(srcImgCopy, srcImg);
    cv::flip(srcImgCopy,srcImg,1);
    
    // start
    UIImage *plain = [CvMatUIImageConverter UIImageFromCVMat:plainBoardImg];
    
    fieldImage = [canny imageByFilteringImage:plain];
    
    cv::Mat edgeBoardImg = [CvMatUIImageConverter cvMatFromUIImage:fieldImage];
    
    // end
    
    cv::Rect fieldRect = cv::Rect(0, 0, plainBoardImg.cols / 8, plainBoardImg.rows / 8);
    cv::Mat fieldType0Mean = cv::Mat::zeros(fieldRect.height, fieldRect.width, CV_16UC4);
    cv::Mat fieldType1Mean = cv::Mat::zeros(fieldRect.height, fieldRect.width, CV_16UC4);
    cv::Mat mean;
    cv::Mat eigen;
    cv::Mat mean2;
    cv::Mat std;
    cv::Scalar meanScalar,devScalar;
    
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
            
            fieldRect.x = fieldRect.width * i;
            fieldRect.y = fieldRect.height * j;
            
            cv::Mat grayField(plainBoardImg, fieldRect);
            grayField.convertTo(grayField, CV_16UC4);
            grayField /= 32;
            
            cv::Mat field(edgeBoardImg, fieldRect);
            field.convertTo(field, CV_16UC4);
            field /= 32;
            
            cv::meanStdDev(grayField, meanScalar, devScalar);

            double r1 = meanScalar.val[0];
            double r2 = devScalar.val[0];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(parent.newSelection) {
                    
                    [self setColorInfo:i index:j andMean:r1 andStd:r2];
                } else if(parent.chessImages.count > 1)  {
                    [self checkColor:i withIndex:j withMean:r1 withStd:r2];
                }

            });
            

            field.convertTo(field, CV_16UC4);
            
            field = field.reshape(1,2);
            cv::PCACompute(field, mean, eigen);
            
            cv::PCA pca = cv::PCA(field, mean,CV_PCA_DATA_AS_ROW);
            
            cv::Mat result = pca.eigenvalues;

//            NSLog(@"----- START ------");
            // figure on white squre
            for(int k = 0; k < result.rows; k++) {
                const float* mi = result.ptr<float>(k);
                const float e1 = mi[0];
                const float e2 = mi[1];

                
                if(e1 > 18000.0 && e2 > 6000.0) {
                    NSLog(@"figure found at: %i %i",i, j );
                }
            }
//            NSLog(@"----- END ------");

        }
    }
    
    parent.newSelection = NO;
    
    UIImage* combinedImg = [CvMatUIImageConverter UIImageFromCVMat:srcImgCopy];
    
    cv::transpose(plainBoardImg, plainBoardImg);
    cv::flip(plainBoardImg, plainBoardImg, 1);
    
//    UIImage *plain = [self UIImageFromCVMat:plainBoardImg];
    
    if(!parent.chessImages)
        parent.chessImages = [[NSMutableArray alloc] init];
    [parent.chessImages addObject:plain];
    int position = (int)parent.chessImages.count -1;
    

    dispatch_async(dispatch_get_main_queue(), ^{[parent.imgView setImage:combinedImg]; [parent.subView setImage:fieldImage];self.imgView.image = combinedImg; _busy=NO;
        [parent.collectionView reloadData];
        [parent.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:position inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];});
}


-(void) setColorInfo:(int)i index:(int)j andMean:(double)mean andStd:(double)std{
    if( i == 3 && j == 3)
    {
        //ww
        _ww_mean = mean;
        _ww_std = std;
    }
    if( i == 4 && j == 3)
    {
        //wb
        _wb_mean = mean;
        _wb_std = std;
    }
    if( i == 0 && j == 7)
    {
        //bb
        _bb_mean = mean;
        _bb_std = std;
    }
    if( i == 7 && j == 7)
    {
        //bw
        _bw_mean = mean;
        _bw_std = std;
    }
    
}

-(void) checkColor:(int)i withIndex:(int)j withMean:(double) mean withStd:(double)std {
    double tolMean = 0.5;
    double tolStd = 0.01;
    int side = 30;
    int x = i*side;
    int y = j*side;
    ShowFramePadViewController *parent = (ShowFramePadViewController *)self.parentViewController;
    UIImageView *imgView = [[UIImageView alloc] init];
    
    if (( cv::abs<double>(mean - _ww_mean) < tolMean) && (cv::abs<double>(std - _ww_std) < tolStd)) {
        NSLog(@"white on white found: %i %i", i ,j);
        imgView.image = [UIImage imageNamed:@"AlphaWPawn.tiff"];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [imgView setFrame:CGRectMake(x, y, side, side)];
        [parent.board addSubview:imgView];
        
    }
    if (( cv::abs<double>(mean - _wb_mean) < tolMean) && (cv::abs<double>(std - _wb_std) < tolStd)) {
        NSLog(@"white on black found: %i %i", i ,j);
        imgView.image = [UIImage imageNamed:@"AlphaWPawn.tiff"];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [imgView setFrame:CGRectMake(x, y, side, side)];
        [parent.board addSubview:imgView];
    }
    if (( cv::abs<double>(mean - _bb_mean) < tolMean) && (cv::abs<double>(std - _bb_std) < tolStd)) {
        NSLog(@"black on black found: %i %i", i ,j);
        imgView.image = [UIImage imageNamed:@"AlphaBPawn.tiff"];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [imgView setFrame:CGRectMake(x, y, side, side)];
        [parent.board addSubview:imgView];
    }
    if (( cv::abs<double>(mean - _bw_mean) < tolMean) && (cv::abs<double>(std - _bw_std) < tolStd)) {
        NSLog(@"black on white found: %i %i", i ,j);
        imgView.image = [UIImage imageNamed:@"AlphaBPawn.tiff"];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [imgView setFrame:CGRectMake(x, y, side, side)];
        [parent.board addSubview:imgView];
    }
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



//    printf("    output\n");
//    for(int i = 0; i < m.rows; i++) {
//        const double* mi = m.ptr<double>(i);
//        printf("        ( ");
//        for(int j = 0; j < m.cols; j++) {
//            printf("%8.1f ", mi[j]);
//        }
//        printf(")\n");
//    }