
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
        case GPUIMAGE_COLORINVERT:
        {
            self.title = @"Color Invert";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageColorInvertFilter alloc] init];
        }; break;
        case GPUIMAGE_GRAYSCALE:
        {
            self.title = @"Grayscale";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageGrayscaleFilter alloc] init];
        }; break;
        case GPUIMAGE_MONOCHROME:
        {
            self.title = @"Monochrome";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setValue:1.0];
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:1.0];
            
            filter = [[GPUImageMonochromeFilter alloc] init];
            [(GPUImageMonochromeFilter *)filter setColor:(GPUVector4){0.0f, 0.0f, 1.0f, 1.f}];
        }; break;
        case GPUIMAGE_FALSECOLOR:
        {
            self.title = @"False Color";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageFalseColorFilter alloc] init];
        }; break;
        case GPUIMAGE_SOFTELEGANCE:
        {
            self.title = @"Soft Elegance (Lookup)";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageSoftEleganceFilter alloc] init];
        }; break;
        case GPUIMAGE_MISSETIKATE:
        {
            self.title = @"Miss Etikate (Lookup)";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageMissEtikateFilter alloc] init];
        }; break;
        case GPUIMAGE_AMATORKA:
        {
            self.title = @"Amatorka (Lookup)";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageAmatorkaFilter alloc] init];
        }; break;
            
        case GPUIMAGE_SATURATION:
        {
            self.title = @"Saturation";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setValue:1.0];
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:2.0];
            
            filter = [[GPUImageSaturationFilter alloc] init];
        }; break;
        case GPUIMAGE_CONTRAST:
        {
            self.title = @"Contrast";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:4.0];
            [self.filterSettingsSlider setValue:1.0];
            
            filter = [[GPUImageContrastFilter alloc] init];
        }; break;
        case GPUIMAGE_BRIGHTNESS:
        {
            self.title = @"Brightness";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:-1.0];
            [self.filterSettingsSlider setMaximumValue:1.0];
            [self.filterSettingsSlider setValue:0.0];
            
            filter = [[GPUImageBrightnessFilter alloc] init];
        }; break;
        case GPUIMAGE_LEVELS:
        {
            self.title = @"Levels";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:1.0];
            [self.filterSettingsSlider setValue:0.0];
            
            filter = [[GPUImageLevelsFilter alloc] init];
        }; break;
        case GPUIMAGE_RGB:
        {
            self.title = @"RGB";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:2.0];
            [self.filterSettingsSlider setValue:1.0];
            
            filter = [[GPUImageRGBFilter alloc] init];
        }; break;

        case GPUIMAGE_WHITEBALANCE:
        {
            self.title = @"White Balance";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:2500.0];
            [self.filterSettingsSlider setMaximumValue:7500.0];
            [self.filterSettingsSlider setValue:5000.0];
            
            filter = [[GPUImageWhiteBalanceFilter alloc] init];
        }; break;
        case GPUIMAGE_EXPOSURE:
        {
            self.title = @"Exposure";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:-4.0];
            [self.filterSettingsSlider setMaximumValue:4.0];
            [self.filterSettingsSlider setValue:0.0];
            
            filter = [[GPUImageExposureFilter alloc] init];
        }; break;
        case GPUIMAGE_SHARPEN:
        {
            self.title = @"Sharpen";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:-1.0];
            [self.filterSettingsSlider setMaximumValue:4.0];
            [self.filterSettingsSlider setValue:0.0];
            
            filter = [[GPUImageSharpenFilter alloc] init];
        }; break;
        case GPUIMAGE_UNSHARPMASK:
        {
            self.title = @"Unsharp Mask";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:5.0];
            [self.filterSettingsSlider setValue:1.0];
            
            filter = [[GPUImageUnsharpMaskFilter alloc] init];
            
            //            [(GPUImageUnsharpMaskFilter *)filter setIntensity:3.0];
        }; break;
        case GPUIMAGE_GAMMA:
        {
            self.title = @"Gamma";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:3.0];
            [self.filterSettingsSlider setValue:1.0];
            
            filter = [[GPUImageGammaFilter alloc] init];
        }; break;
        case GPUIMAGE_HAZE:
        {
            self.title = @"Haze / UV";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:-0.2];
            [self.filterSettingsSlider setMaximumValue:0.2];
            [self.filterSettingsSlider setValue:0.2];
            
            filter = [[GPUImageHazeFilter alloc] init];
        }; break;
        case GPUIMAGE_AVERAGECOLOR:
        {
            self.title = @"Average Color";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageAverageColor alloc] init];
        }; break;
        case GPUIMAGE_LUMINOSITY:
        {
            self.title = @"Luminosity";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageLuminosity alloc] init];
        }; break;
        case GPUIMAGE_HISTOGRAM:
        {
            self.title = @"Histogram";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:4.0];
            [self.filterSettingsSlider setMaximumValue:32.0];
            [self.filterSettingsSlider setValue:16.0];
            
            filter = [[GPUImageHistogramFilter alloc] initWithHistogramType:kGPUImageHistogramRGB];
        }; break;
        case GPUIMAGE_HISTOGRAM_EQUALIZATION:
        {
            self.title = @"Histogram Equalization";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:4.0];
            [self.filterSettingsSlider setMaximumValue:32.0];
            [self.filterSettingsSlider setValue:16.0];
            
            filter = [[GPUImageHistogramEqualizationFilter alloc] initWithHistogramType:kGPUImageHistogramLuminance];
        }; break;
        case GPUIMAGE_THRESHOLD:
        {
            self.title = @"Luminance Threshold";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:1.0];
            [self.filterSettingsSlider setValue:0.5];
            
            filter = [[GPUImageLuminanceThresholdFilter alloc] init];
        }; break;
        case GPUIMAGE_ADAPTIVETHRESHOLD:
        {
            self.title = @"Adaptive Threshold";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:1.0];
            [self.filterSettingsSlider setMaximumValue:20.0];
            [self.filterSettingsSlider setValue:1.0];
            
            filter = [[GPUImageAdaptiveThresholdFilter alloc] init];
        }; break;
        case GPUIMAGE_AVERAGELUMINANCETHRESHOLD:
        {
            self.title = @"Avg. Lum. Threshold";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:2.0];
            [self.filterSettingsSlider setValue:1.0];
            
            filter = [[GPUImageAverageLuminanceThresholdFilter alloc] init];
        }; break;
        case GPUIMAGE_CROP:
        {
            self.title = @"Crop";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.2];
            [self.filterSettingsSlider setMaximumValue:1.0];
            [self.filterSettingsSlider setValue:0.5];
            
            filter = [[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0.0, 0.0, 1.0, 0.25)];
        }; break;
        case GPUIMAGE_MASK:
        {
            self.title = @"Mask";
            self.filterSettingsSlider.hidden = YES;
            needsSecondImage = YES;
            
            filter = [[GPUImageMaskFilter alloc] init];
            
            [(GPUImageFilter*)filter setBackgroundColorRed:0.0 green:1.0 blue:0.0 alpha:1.0];
        }; break;
        case GPUIMAGE_TRANSFORM:
        {
            self.title = @"Transform (2-D)";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:6.28];
            [self.filterSettingsSlider setValue:2.0];
            
            filter = [[GPUImageTransformFilter alloc] init];
            [(GPUImageTransformFilter *)filter setAffineTransform:CGAffineTransformMakeRotation(2.0)];
            //            [(GPUImageTransformFilter *)filter setIgnoreAspectRatio:YES];
        }; break;
        case GPUIMAGE_TRANSFORM3D:
        {
            self.title = @"Transform (3-D)";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:6.28];
            [self.filterSettingsSlider setValue:0.75];
            
            filter = [[GPUImageTransformFilter alloc] init];
            CATransform3D perspectiveTransform = CATransform3DIdentity;
            perspectiveTransform.m34 = 0.4;
            perspectiveTransform.m33 = 0.4;
            perspectiveTransform = CATransform3DScale(perspectiveTransform, 0.75, 0.75, 0.75);
            perspectiveTransform = CATransform3DRotate(perspectiveTransform, 0.75, 0.0, 1.0, 0.0);
            
            [(GPUImageTransformFilter *)filter setTransform3D:perspectiveTransform];
        }; break;
        case GPUIMAGE_SOBELEDGEDETECTION:
        {
            self.title = @"Sobel Edge Detection";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:1.0];
            [self.filterSettingsSlider setValue:0.25];
            
            filter = [[GPUImageSobelEdgeDetectionFilter alloc] init];
        }; break;
        case GPUIMAGE_XYGRADIENT:
        {
            self.title = @"XY Derivative";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageXYDerivativeFilter alloc] init];
        }; break;
        case GPUIMAGE_HARRISCORNERDETECTION:
        {
            self.title = @"Harris Corner Detection";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.01];
            [self.filterSettingsSlider setMaximumValue:0.70];
            [self.filterSettingsSlider setValue:0.20];
            
            filter = [[GPUImageHarrisCornerDetectionFilter alloc] init];
            [(GPUImageHarrisCornerDetectionFilter *)filter setThreshold:0.20];
        }; break;
        case GPUIMAGE_NOBLECORNERDETECTION:
        {
            self.title = @"Noble Corner Detection";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.01];
            [self.filterSettingsSlider setMaximumValue:0.70];
            [self.filterSettingsSlider setValue:0.20];
            
            filter = [[GPUImageNobleCornerDetectionFilter alloc] init];
            [(GPUImageNobleCornerDetectionFilter *)filter setThreshold:0.20];
        }; break;
        case GPUIMAGE_SHITOMASIFEATUREDETECTION:
        {
            self.title = @"Shi-Tomasi Feature Detection";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.01];
            [self.filterSettingsSlider setMaximumValue:0.70];
            [self.filterSettingsSlider setValue:0.20];
            
            filter = [[GPUImageShiTomasiFeatureDetectionFilter alloc] init];
            [(GPUImageShiTomasiFeatureDetectionFilter *)filter setThreshold:0.20];
        }; break;
        case GPUIMAGE_HOUGHTRANSFORMLINEDETECTOR:
        {
            self.title = @"Line Detection";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.2];
            [self.filterSettingsSlider setMaximumValue:1.0];
            [self.filterSettingsSlider setValue:0.6];
            
            filter = [[GPUImageHoughTransformLineDetector alloc] init];
            [(GPUImageHoughTransformLineDetector *)filter setLineDetectionThreshold:0.60];
        }; break;
            
        case GPUIMAGE_PREWITTEDGEDETECTION:
        {
            self.title = @"Prewitt Edge Detection";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:1.0];
            [self.filterSettingsSlider setValue:1.0];
            
            filter = [[GPUImagePrewittEdgeDetectionFilter alloc] init];
        }; break;
        case GPUIMAGE_CANNYEDGEDETECTION:
        {
//            self.title = @"Canny Edge Detection";
//            self.filterSettingsSlider.hidden = NO;
//            
//            [self.filterSettingsSlider setMinimumValue:0.0];
//            [self.filterSettingsSlider setMaximumValue:1.0];
//            [self.filterSettingsSlider setValue:1.0];
//            
//            filter = [[GPUImageCannyEdgeDetectionFilter alloc] init];
            
//            self.filterSettingsSlider.hidden = NO;
//            
//            [self.filterSettingsSlider setMinimumValue:0.01];
//            [self.filterSettingsSlider setMaximumValue:0.70];
//            [self.filterSettingsSlider setValue:0.20];
//            
//            filter = [[GPUImageFilterGroup alloc] init];
//
//            GPUImageHarrisCornerDetectionFilter *harrisCorner = [[GPUImageHarrisCornerDetectionFilter alloc] init];
//            [(GPUImageHarrisCornerDetectionFilter *)harrisCorner setThreshold:0.001];
//            [(GPUImageFilterGroup *)filter addFilter:harrisCorner];
//            
//            GPUImageHoughTransformLineDetector *houghFilter = [[GPUImageHoughTransformLineDetector alloc] init];
//            [(GPUImageHoughTransformLineDetector *)houghFilter setLineDetectionThreshold:0.01];
//            [(GPUImageFilterGroup *)filter addFilter:houghFilter];
//            
//            [harrisCorner addTarget:houghFilter];
//            
//            [(GPUImageFilterGroup *)filter setInitialFilters:[NSArray arrayWithObject:harrisCorner]];
//            [(GPUImageFilterGroup *)filter setTerminalFilter:houghFilter];

            
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.01];
            [self.filterSettingsSlider setMaximumValue:0.70];
            [self.filterSettingsSlider setValue:0.20];
            
            filter = [[GPUImageFilterGroup alloc] init];
            
            GPUImageXYDerivativeFilter *xyF = [[GPUImageXYDerivativeFilter alloc] init];
            [(GPUImageFilterGroup *)filter addFilter:xyF];
            
//            GPUImageCannyEdgeDetectionFilter * cannyEdge = [[GPUImageCannyEdgeDetectionFilter alloc] init];
//            [(GPUImageFilterGroup *)filter addFilter:cannyEdge];
            
            GPUImageHarrisCornerDetectionFilter *harrisCorner = [[GPUImageHarrisCornerDetectionFilter alloc] init];
            [(GPUImageHarrisCornerDetectionFilter *)harrisCorner setThreshold:0.001];
            [(GPUImageFilterGroup *)filter addFilter:harrisCorner];
            
            GPUImageHoughTransformLineDetector *houghFilter = [[GPUImageHoughTransformLineDetector alloc] init];
            [(GPUImageHoughTransformLineDetector *)houghFilter setLineDetectionThreshold:0.004];
            [(GPUImageFilterGroup *)filter addFilter:houghFilter];
            
//            [xyF addTarget:harrisCorner];
//            [harrisCorner addTarget:houghFilter];
            
//            [houghFilter addTarget:harrisCorner];
            
            [xyF addTarget:harrisCorner];
            
            [(GPUImageFilterGroup *)filter setInitialFilters:[NSArray arrayWithObject:xyF]];
            [(GPUImageFilterGroup *)filter setTerminalFilter:harrisCorner];
            
            [videoCamera addTarget:filter];

        }; break;
        case GPUIMAGE_THRESHOLDEDGEDETECTION:
        {
            self.title = @"Threshold Edge Detection";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:1.0];
            [self.filterSettingsSlider setValue:0.25];
            
            filter = [[GPUImageThresholdEdgeDetectionFilter alloc] init];
        }; break;
        case GPUIMAGE_LOCALBINARYPATTERN:
        {
            self.title = @"Local Binary Pattern";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:1.0];
            [self.filterSettingsSlider setMaximumValue:5.0];
            [self.filterSettingsSlider setValue:1.0];
            
            filter = [[GPUImageLocalBinaryPatternFilter alloc] init];
        }; break;
        case GPUIMAGE_BUFFER:
        {
            self.title = @"Image Buffer";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageBuffer alloc] init];
        }; break;
        case GPUIMAGE_LOWPASS:
        {
            self.title = @"Low Pass";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:1.0];
            [self.filterSettingsSlider setValue:0.5];
            
            filter = [[GPUImageLowPassFilter alloc] init];
        }; break;
        case GPUIMAGE_HIGHPASS:
        {
            self.title = @"High Pass";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:1.0];
            [self.filterSettingsSlider setValue:0.5];
            
            filter = [[GPUImageHighPassFilter alloc] init];
        }; break;
        case GPUIMAGE_MOTIONDETECTOR:
        {
            [videoCamera rotateCamera];
            
            self.title = @"Motion Detector";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:1.0];
            [self.filterSettingsSlider setValue:0.5];
            
            filter = [[GPUImageMotionDetector alloc] init];
        }; break;
        case GPUIMAGE_SKETCH:
        {
            self.title = @"Sketch";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:1.0];
            [self.filterSettingsSlider setValue:0.25];
            
            filter = [[GPUImageSketchFilter alloc] init];
        }; break;
        case GPUIMAGE_THRESHOLDSKETCH:
        {
            self.title = @"Threshold Sketch";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:1.0];
            [self.filterSettingsSlider setValue:0.25];
            
            filter = [[GPUImageThresholdSketchFilter alloc] init];
        }; break;
        case GPUIMAGE_TOON:
        {
            self.title = @"Toon";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageToonFilter alloc] init];
        }; break;
        case GPUIMAGE_SMOOTHTOON:
        {
            self.title = @"Smooth Toon";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:1.0];
            [self.filterSettingsSlider setMaximumValue:6.0];
            [self.filterSettingsSlider setValue:1.0];
            
            filter = [[GPUImageSmoothToonFilter alloc] init];
        }; break;
        case GPUIMAGE_TILTSHIFT:
        {
            self.title = @"Tilt Shift";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.2];
            [self.filterSettingsSlider setMaximumValue:0.8];
            [self.filterSettingsSlider setValue:0.5];
            
            filter = [[GPUImageTiltShiftFilter alloc] init];
            [(GPUImageTiltShiftFilter *)filter setTopFocusLevel:0.4];
            [(GPUImageTiltShiftFilter *)filter setBottomFocusLevel:0.6];
            [(GPUImageTiltShiftFilter *)filter setFocusFallOffRate:0.2];
        }; break;
        case GPUIMAGE_CGA:
        {
            self.title = @"CGA Colorspace";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageCGAColorspaceFilter alloc] init];
        }; break;
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
        case GPUIMAGE_EMBOSS:
        {
            self.title = @"Emboss";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:5.0];
            [self.filterSettingsSlider setValue:1.0];
            
            filter = [[GPUImageEmbossFilter alloc] init];
        }; break;
        case GPUIMAGE_LAPLACIAN:
        {
            self.title = @"Laplacian";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageLaplacianFilter alloc] init];
        }; break;
        case GPUIMAGE_POSTERIZE:
        {
            self.title = @"Posterize";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:1.0];
            [self.filterSettingsSlider setMaximumValue:20.0];
            [self.filterSettingsSlider setValue:10.0];
            
            filter = [[GPUImagePosterizeFilter alloc] init];
        }; break;
        case GPUIMAGE_SWIRL:
        {
            self.title = @"Swirl";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:2.0];
            [self.filterSettingsSlider setValue:1.0];
            
            filter = [[GPUImageSwirlFilter alloc] init];
        }; break;
        case GPUIMAGE_BULGE:
        {
            self.title = @"Bulge";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:-1.0];
            [self.filterSettingsSlider setMaximumValue:1.0];
            [self.filterSettingsSlider setValue:0.5];
            
            filter = [[GPUImageBulgeDistortionFilter alloc] init];
        }; break;
        case GPUIMAGE_SPHEREREFRACTION:
        {
            self.title = @"Sphere Refraction";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:1.0];
            [self.filterSettingsSlider setValue:0.15];
            
            filter = [[GPUImageSphereRefractionFilter alloc] init];
            [(GPUImageSphereRefractionFilter *)filter setRadius:0.15];
        }; break;
        case GPUIMAGE_GLASSSPHERE:
        {
            self.title = @"Glass Sphere";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:1.0];
            [self.filterSettingsSlider setValue:0.15];
            
            filter = [[GPUImageGlassSphereFilter alloc] init];
            [(GPUImageGlassSphereFilter *)filter setRadius:0.15];
        }; break;
        case GPUIMAGE_PINCH:
        {
            self.title = @"Pinch";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:-2.0];
            [self.filterSettingsSlider setMaximumValue:2.0];
            [self.filterSettingsSlider setValue:0.5];
            
            filter = [[GPUImagePinchDistortionFilter alloc] init];
        }; break;
        case GPUIMAGE_STRETCH:
        {
            self.title = @"Stretch";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageStretchDistortionFilter alloc] init];
        }; break;
        case GPUIMAGE_DILATION:
        {
            self.title = @"Dilation";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageRGBDilationFilter alloc] initWithRadius:4];
        }; break;
        case GPUIMAGE_EROSION:
        {
            self.title = @"Erosion";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageRGBErosionFilter alloc] initWithRadius:4];
        }; break;
        case GPUIMAGE_OPENING:
        {
            self.title = @"Opening";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageRGBOpeningFilter alloc] initWithRadius:4];
        }; break;
        case GPUIMAGE_CLOSING:
        {
            self.title = @"Closing";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageRGBClosingFilter alloc] initWithRadius:4];
        }; break;
            
        case GPUIMAGE_PERLINNOISE:
        {
            self.title = @"Perlin Noise";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:1.0];
            [self.filterSettingsSlider setMaximumValue:30.0];
            [self.filterSettingsSlider setValue:8.0];
            
            filter = [[GPUImagePerlinNoiseFilter alloc] init];
        }; break;
        case GPUIMAGE_VORONOI:
        {
            self.title = @"Voronoi";
            self.filterSettingsSlider.hidden = YES;
            
            GPUImageJFAVoronoiFilter *jfa = [[GPUImageJFAVoronoiFilter alloc] init];
            [jfa setSizeInPixels:CGSizeMake(1024.0, 1024.0)];
            
            sourcePicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"voroni_points2.png"]];
            
            [sourcePicture addTarget:jfa];
            
            filter = [[GPUImageVoronoiConsumerFilter alloc] init];
            
            [jfa setSizeInPixels:CGSizeMake(1024.0, 1024.0)];
            [(GPUImageVoronoiConsumerFilter *)filter setSizeInPixels:CGSizeMake(1024.0, 1024.0)];
            
            [videoCamera addTarget:filter];
            [jfa addTarget:filter];
            [sourcePicture processImage];
        }; break;
        case GPUIMAGE_MOSAIC:
        {
            self.title = @"Mosaic";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.002];
            [self.filterSettingsSlider setMaximumValue:0.05];
            [self.filterSettingsSlider setValue:0.025];
            
            filter = [[GPUImageMosaicFilter alloc] init];
            [(GPUImageMosaicFilter *)filter setTileSet:@"squares.png"];
            [(GPUImageMosaicFilter *)filter setColorOn:NO];
            //[(GPUImageMosaicFilter *)filter setTileSet:@"dotletterstiles.png"];
            //[(GPUImageMosaicFilter *)filter setTileSet:@"curvies.png"];
            
        }; break;
        case GPUIMAGE_CHROMAKEY:
        {
            self.title = @"Chroma Key (Green)";
            self.filterSettingsSlider.hidden = NO;
            needsSecondImage = YES;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:1.0];
            [self.filterSettingsSlider setValue:0.4];
            
            filter = [[GPUImageChromaKeyBlendFilter alloc] init];
            [(GPUImageChromaKeyBlendFilter *)filter setColorToReplaceRed:0.0 green:1.0 blue:0.0];
        }; break;
        case GPUIMAGE_CHROMAKEYNONBLEND:
        {
            self.title = @"Chroma Key (Green)";
            self.filterSettingsSlider.hidden = NO;
            needsSecondImage = YES;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:1.0];
            [self.filterSettingsSlider setValue:0.4];
            
            filter = [[GPUImageChromaKeyFilter alloc] init];
            [(GPUImageChromaKeyFilter *)filter setColorToReplaceRed:0.0 green:1.0 blue:0.0];
        }; break;
        case GPUIMAGE_ADD:
        {
            self.title = @"Add Blend";
            self.filterSettingsSlider.hidden = YES;
            needsSecondImage = YES;
            
            filter = [[GPUImageAddBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_DIVIDE:
        {
            self.title = @"Divide Blend";
            self.filterSettingsSlider.hidden = YES;
            needsSecondImage = YES;
            
            filter = [[GPUImageDivideBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_MULTIPLY:
        {
            self.title = @"Multiply Blend";
            self.filterSettingsSlider.hidden = YES;
            needsSecondImage = YES;
            
            filter = [[GPUImageMultiplyBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_OVERLAY:
        {
            self.title = @"Overlay Blend";
            self.filterSettingsSlider.hidden = YES;
            needsSecondImage = YES;
            
            filter = [[GPUImageOverlayBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_LIGHTEN:
        {
            self.title = @"Lighten Blend";
            self.filterSettingsSlider.hidden = YES;
            needsSecondImage = YES;
            
            filter = [[GPUImageLightenBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_DARKEN:
        {
            self.title = @"Darken Blend";
            self.filterSettingsSlider.hidden = YES;
            
            needsSecondImage = YES;
            filter = [[GPUImageDarkenBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_DISSOLVE:
        {
            self.title = @"Dissolve Blend";
            self.filterSettingsSlider.hidden = NO;
            needsSecondImage = YES;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:1.0];
            [self.filterSettingsSlider setValue:0.5];
            
            filter = [[GPUImageDissolveBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_SCREENBLEND:
        {
            self.title = @"Screen Blend";
            self.filterSettingsSlider.hidden = YES;
            needsSecondImage = YES;
            
            filter = [[GPUImageScreenBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_COLORBURN:
        {
            self.title = @"Color Burn Blend";
            self.filterSettingsSlider.hidden = YES;
            needsSecondImage = YES;
            
            filter = [[GPUImageColorBurnBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_COLORDODGE:
        {
            self.title = @"Color Dodge Blend";
            self.filterSettingsSlider.hidden = YES;
            needsSecondImage = YES;
            
            filter = [[GPUImageColorDodgeBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_LINEARBURN:
        {
            self.title = @"Linear Burn Blend";
            self.filterSettingsSlider.hidden = YES;
            needsSecondImage = YES;
            
            filter = [[GPUImageLinearBurnBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_EXCLUSIONBLEND:
        {
            self.title = @"Exclusion Blend";
            self.filterSettingsSlider.hidden = YES;
            needsSecondImage = YES;
            
            filter = [[GPUImageExclusionBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_DIFFERENCEBLEND:
        {
            self.title = @"Difference Blend";
            self.filterSettingsSlider.hidden = YES;
            needsSecondImage = YES;
            
            filter = [[GPUImageDifferenceBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_SUBTRACTBLEND:
        {
            self.title = @"Subtract Blend";
            self.filterSettingsSlider.hidden = YES;
            needsSecondImage = YES;
            
            filter = [[GPUImageSubtractBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_HARDLIGHTBLEND:
        {
            self.title = @"Hard Light Blend";
            self.filterSettingsSlider.hidden = YES;
            needsSecondImage = YES;
            
            filter = [[GPUImageHardLightBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_COLORBLEND:
        {
            self.title = @"Color Blend";
            self.filterSettingsSlider.hidden = YES;
            needsSecondImage = YES;
            
            filter = [[GPUImageColorBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_HUEBLEND:
        {
            self.title = @"Hue Blend";
            self.filterSettingsSlider.hidden = YES;
            needsSecondImage = YES;
            
            filter = [[GPUImageHueBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_SATURATIONBLEND:
        {
            self.title = @"Saturation Blend";
            self.filterSettingsSlider.hidden = YES;
            needsSecondImage = YES;
            
            filter = [[GPUImageSaturationBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_LUMINOSITYBLEND:
        {
            self.title = @"Luminosity Blend";
            self.filterSettingsSlider.hidden = YES;
            needsSecondImage = YES;
            
            filter = [[GPUImageLuminosityBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_NORMALBLEND:
        {
            self.title = @"Normal Blend";
            self.filterSettingsSlider.hidden = YES;
            needsSecondImage = YES;
            
            filter = [[GPUImageNormalBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_POISSONBLEND:
        {
            self.title = @"Poisson Blend";
            self.filterSettingsSlider.hidden = NO;
            needsSecondImage = YES;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:1.0];
            [self.filterSettingsSlider setValue:0.5];
            
            filter = [[GPUImagePoissonBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_OPACITY:
        {
            self.title = @"Opacity Adjustment";
            self.filterSettingsSlider.hidden = NO;
            needsSecondImage = YES;
            
            [self.filterSettingsSlider setValue:1.0];
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:1.0];
            
            filter = [[GPUImageOpacityFilter alloc] init];
        }; break;
        case GPUIMAGE_CUSTOM:
        {
            self.title = @"Custom";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageFilter alloc] initWithFragmentShaderFromFile:@"CustomFilter"];
        }; break;
        case GPUIMAGE_KUWAHARA:
        {
            self.title = @"Kuwahara";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:3.0];
            [self.filterSettingsSlider setMaximumValue:8.0];
            [self.filterSettingsSlider setValue:3.0];
            
            filter = [[GPUImageKuwaharaFilter alloc] init];
        }; break;
        case GPUIMAGE_KUWAHARARADIUS3:
        {
            self.title = @"Kuwahara (Radius 3)";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageKuwaharaRadius3Filter alloc] init];
        }; break;
        case GPUIMAGE_GAUSSIAN:
        {
            self.title = @"Gaussian Blur";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:24.0];
            [self.filterSettingsSlider setValue:2.0];
            
            filter = [[GPUImageGaussianBlurFilter alloc] init];
        }; break;
        case GPUIMAGE_BOXBLUR:
        {
            self.title = @"Box Blur";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:24.0];
            [self.filterSettingsSlider setValue:2.0];
            
            filter = [[GPUImageBoxBlurFilter alloc] init];
        }; break;
        case GPUIMAGE_MEDIAN:
        {
            self.title = @"Median";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageMedianFilter alloc] init];
        }; break;
        case GPUIMAGE_IOSBLUR:
        {
            self.title = @"iOS 7 Blur";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageiOSBlurFilter alloc] init];
        }; break;
        case GPUIMAGE_UIELEMENT:
        {
            self.title = @"UI Element";
            self.filterSettingsSlider.hidden = YES;
            
            filter = [[GPUImageSepiaFilter alloc] init];
        }; break;
        case GPUIMAGE_GAUSSIAN_SELECTIVE:
        {
            self.title = @"Selective Blur";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:.75f];
            [self.filterSettingsSlider setValue:40.0/320.0];
            
            filter = [[GPUImageGaussianSelectiveBlurFilter alloc] init];
            [(GPUImageGaussianSelectiveBlurFilter*)filter setExcludeCircleRadius:40.0/320.0];
        }; break;
        case GPUIMAGE_GAUSSIAN_POSITION:
        {
            self.title = @"Selective Blur";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:.75f];
            [self.filterSettingsSlider setValue:40.0/320.0];
            
            filter = [[GPUImageGaussianBlurPositionFilter alloc] init];
            [(GPUImageGaussianBlurPositionFilter*)filter setBlurRadius:40.0/320.0];
        }; break;
        case GPUIMAGE_BILATERAL:
        {
            self.title = @"Bilateral Blur";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:10.0];
            [self.filterSettingsSlider setValue:1.0];
            
            filter = [[GPUImageBilateralFilter alloc] init];
        }; break;
        case GPUIMAGE_FILTERGROUP:
        {
            self.title = @"Filter Group";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setValue:0.05];
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:0.3];
            
            filter = [[GPUImageFilterGroup alloc] init];
            
            GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init];
            [(GPUImageFilterGroup *)filter addFilter:sepiaFilter];
            
            GPUImagePixellateFilter *pixellateFilter = [[GPUImagePixellateFilter alloc] init];
            [(GPUImageFilterGroup *)filter addFilter:pixellateFilter];
            
            [sepiaFilter addTarget:pixellateFilter];
            [(GPUImageFilterGroup *)filter setInitialFilters:[NSArray arrayWithObject:sepiaFilter]];
            [(GPUImageFilterGroup *)filter setTerminalFilter:pixellateFilter];
        }; break;
            
        case GPUIMAGE_FACES:
        {
//            [videoCamera rotateCamera];
            self.title = @"Face Detection";
//            self.filterSettingsSlider.hidden = YES;
//            
//            [self.filterSettingsSlider setValue:1.0];
//            [self.filterSettingsSlider setMinimumValue:0.0];
//            [self.filterSettingsSlider setMaximumValue:2.0];
//            
//            filter = [[GPUImageSaturationFilter alloc] init];
            [self.filterSettingsSlider setValue:0.5];
            filter = [[GPUImageBrightnessFilter alloc] init];
            
            [videoCamera setDelegate:self];
            break;
        }
            
            
        case GPUIMAGE_FILECONFIG:
        {
            self.title = @"Canny Edge Detection";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:1.0];
            [self.filterSettingsSlider setValue:1.0];
            
            filter = [[GPUImageCannyEdgeDetectionFilter alloc] init];
        }; break;
            
    
//        {
//            self.filterSettingsSlider.hidden = NO;
//            
//            [self.filterSettingsSlider setMinimumValue:0.01];
//            [self.filterSettingsSlider setMaximumValue:0.70];
//            [self.filterSettingsSlider setValue:0.20];
//            
//            filter = [[GPUImageHarrisCornerDetectionFilter alloc] init];
//            [(GPUImageHarrisCornerDetectionFilter *)filter setThreshold:0.20];
//
//        }; break;
//        default: filter = [[GPUImageSepiaFilter alloc] init]; break;
    }
    
    
//case GPUIMAGE_GAUSSIAN_POSITION:
//    {
//        self.title = @"Selective Blur";
//        self.filterSettingsSlider.hidden = NO;
//        
//        [self.filterSettingsSlider setMinimumValue:0.0];
//        [self.filterSettingsSlider setMaximumValue:.75f];
//        [self.filterSettingsSlider setValue:40.0/320.0];
//        
//        filter = [[GPUImageGaussianBlurPositionFilter alloc] init];
//        [(GPUImageGaussianBlurPositionFilter*)filter setBlurRadius:40.0/320.0];
//    }; break;
    
//    if (filterType == GPUIMAGE_FILECONFIG:
//    {
//        self.filterSettingsSlider.hidden = NO;
//        
//        [self.filterSettingsSlider setMinimumValue:0.01];
//        [self.filterSettingsSlider setMaximumValue:0.70];
//        [self.filterSettingsSlider setValue:0.20];
//        
//        filter = [[GPUImageHarrisCornerDetectionFilter alloc] init];
//        [(GPUImageHarrisCornerDetectionFilter *)filter setThreshold:0.20];
    
//        [videoCamera setDelegate:self];
//        [videoCamera startCameraCapture];
//        return;
        
//        GPUImageFilterGroup *groupFilter = [[GPUImageFilterGroup alloc] init];
//        GPUImageHarrisCornerDetectionFilter *harrisCorner = [[GPUImageHarrisCornerDetectionFilter alloc] init];
////        [contrastFilter setContrast:3.5]; // 0 - 4
////        [(GPUImageFilterGroup *)filter addFilter:harrisCorner];
//        [(GPUImageHarrisCornerDetectionFilter *)harrisCorner setThreshold:0.20];
//        
//        GPUImageHoughTransformLineDetector *houghFilter = [[GPUImageHoughTransformLineDetector alloc] init];
//        [(GPUImageHoughTransformLineDetector *)houghFilter setLineDetectionThreshold:0.60];
//        
//        [harrisCorner addTarget:houghFilter];
//        
//        [(GPUImageFilterGroup *)groupFilter setInitialFilters:[NSArray arrayWithObject:harrisCorner]];
//        [(GPUImageFilterGroup *)groupFilter setTerminalFilter:houghFilter];
//        
//        [videoCamera addTarget:harrisCorner];
//        [videoCamera out]
//        
//        
////        GPUImageDifferenceBlendFilter *blendFilter = [[GPUImageDifferenceBlendFilter alloc] init];
////        
////        [videoCamera removeTarget:filter];
////        
////        GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc] init];
////        [videoCamera addTarget:gammaFilter];
////        [gammaFilter addTarget:blendFilter];
////        [videoCamera addTarget:filter];
////        
////        [filter addTarget:blendFilter];
////        
////        [blendFilter addTarget:filterView];
//        
////        GPUImageView *filterView = (GPUImageView *)self.view;
////        filterView.view.setFilter(groupFilter);
//        
//
//        
////        gpuImageView
////        super.view.setFilter(groupFilter);
//        
//
//        
////        self.title = @"File Configuration";
////        pipeline = [[GPUImageFilterPipeline alloc] initWithConfigurationFile:[[NSBundle mainBundle] URLForResource:@"SampleConfiguration" withExtension:@"plist"]
////                                                                       input:videoCamera output:(GPUImageView*)self.view];
////        
////        
//////        [pipeline addFilter:rotationFilter atIndex:0];
//////        [pipeline addFilter:rotationFilter atIndex:0];
////        
////        self.title = @"Line Detection";
////        self.filterSettingsSlider.hidden = NO;
////        [self.filterSettingsSlider setMinimumValue:0.2];
////        [self.filterSettingsSlider setMaximumValue:1.0];
////        [self.filterSettingsSlider setValue:0.6];
////        
////        filter = [[GPUImageHoughTransformLineDetector alloc] init];
////        [(GPUImageHoughTransformLineDetector *)filter setLineDetectionThreshold:0.60];
////        
////        [pipeline addFilter:filter atIndex:0];
////        
////        self.filterSettingsSlider.hidden = NO;
////        [self.filterSettingsSlider setMinimumValue:0.01];
////        [self.filterSettingsSlider setMaximumValue:0.70];
////        [self.filterSettingsSlider setValue:0.20];
////        
////        filter = [[GPUImageHarrisCornerDetectionFilter alloc] init];
////        [(GPUImageHarrisCornerDetectionFilter *)filter setThreshold:0.20];
////        [pipeline addFilter:filter atIndex:1];
//        
//        [videoCamera setDelegate:self];
//        [videoCamera startCameraCapture];
//
//        return;
        
        
//    }

    
//
        if (filterType != GPUIMAGE_VORONOI)
        {
            [videoCamera addTarget:filter];
        }
        
        videoCamera.runBenchmark = YES;
        GPUImageView *filterView = (GPUImageView *)self.view;
        
//        if (needsSecondImage)
//        {
//            UIImage *inputImage;
//            
//            if (filterType == GPUIMAGE_MASK)
//            {
//                inputImage = [UIImage imageNamed:@"mask"];
//            }
//            /*
//             else if (filterType == GPUIMAGE_VORONOI) {
//             inputImage = [UIImage imageNamed:@"voroni_points.png"];
//             }*/
//            else {
//                // The picture is only used for two-image blend filters
//                inputImage = [UIImage imageNamed:@"WID-small.jpg"];
//            }
//            
//            //            sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:NO];
//            sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
//            [sourcePicture processImage];
//            [sourcePicture addTarget:filter];
//        }
//        
//        
//        if (filterType == GPUIMAGE_HISTOGRAM)
//        {
//            // I'm adding an intermediary filter because glReadPixels() requires something to be rendered for its glReadPixels() operation to work
//            [videoCamera removeTarget:filter];
//            GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc] init];
//            [videoCamera addTarget:gammaFilter];
//            [gammaFilter addTarget:filter];
//            
//            GPUImageHistogramGenerator *histogramGraph = [[GPUImageHistogramGenerator alloc] init];
//            
//            [histogramGraph forceProcessingAtSize:CGSizeMake(256.0, 330.0)];
//            [filter addTarget:histogramGraph];
//            
//            GPUImageAlphaBlendFilter *blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
//            blendFilter.mix = 0.75;
//            [blendFilter forceProcessingAtSize:CGSizeMake(256.0, 330.0)];
//            
//            [videoCamera addTarget:blendFilter];
//            [histogramGraph addTarget:blendFilter];
//            
//            [blendFilter addTarget:filterView];
//        }
//        else if ( (filterType == GPUIMAGE_HARRISCORNERDETECTION) || (filterType == GPUIMAGE_NOBLECORNERDETECTION) || (filterType == GPUIMAGE_SHITOMASIFEATUREDETECTION) )
//        {
//            GPUImageCrosshairGenerator *crosshairGenerator = [[GPUImageCrosshairGenerator alloc] init];
//            crosshairGenerator.crosshairWidth = 60.0;
//            [crosshairGenerator forceProcessingAtSize:CGSizeMake(480.0, 640.0)];
//            
//            [(GPUImageHarrisCornerDetectionFilter *)filter setCornersDetectedBlock:^(GLfloat* cornerArray, NSUInteger cornersDetected, CMTime frameTime) {
//                [crosshairGenerator renderCrosshairsFromArray:cornerArray count:cornersDetected frameTime:frameTime];
//            }];
//            
//            GPUImageAlphaBlendFilter *blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
//            [blendFilter forceProcessingAtSize:CGSizeMake(480.0, 640.0)];
//            GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc] init];
//            [videoCamera addTarget:gammaFilter];
//            [gammaFilter addTarget:blendFilter];
//            
//            [crosshairGenerator addTarget:blendFilter];
//            
//            [blendFilter addTarget:filterView];
//        }
//        else if (filterType == GPUIMAGE_HOUGHTRANSFORMLINEDETECTOR)
//        {
//            GPUImageLineGenerator *lineGenerator = [[GPUImageLineGenerator alloc] init];
//            //            lineGenerator.crosshairWidth = 15.0;
//            [lineGenerator forceProcessingAtSize:CGSizeMake(480.0, 640.0)];
//            [lineGenerator setLineColorRed:1.0 green:0.0 blue:0.0];
//            [(GPUImageHoughTransformLineDetector *)filter setLinesDetectedBlock:^(GLfloat* lineArray, NSUInteger linesDetected, CMTime frameTime){
//                [lineGenerator renderLinesFromArray:lineArray count:linesDetected frameTime:frameTime];
//            }];
//            
//            GPUImageAlphaBlendFilter *blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
//            [blendFilter forceProcessingAtSize:CGSizeMake(480.0, 640.0)];
//            GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc] init];
//            [videoCamera addTarget:gammaFilter];
//            [gammaFilter addTarget:blendFilter];
//            
//            [lineGenerator addTarget:blendFilter];
//            
//            [blendFilter addTarget:filterView];
//        }
//        else if (filterType == GPUIMAGE_UIELEMENT)
//        {
//            GPUImageAlphaBlendFilter *blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
//            blendFilter.mix = 1.0;
//            
//            NSDate *startTime = [NSDate date];
//            
//            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 240.0f, 320.0f)];
//            timeLabel.font = [UIFont systemFontOfSize:17.0f];
//            timeLabel.text = @"Time: 0.0 s";
//            //            timeLabel.textAlignment = UITextAlignmentCenter;
//            timeLabel.backgroundColor = [UIColor clearColor];
//            timeLabel.textColor = [UIColor whiteColor];
//            
//            uiElementInput = [[GPUImageUIElement alloc] initWithView:timeLabel];
//            
//            [filter addTarget:blendFilter];
//            [uiElementInput addTarget:blendFilter];
//            
//            [blendFilter addTarget:filterView];
//            
//            __unsafe_unretained GPUImageUIElement *weakUIElementInput = uiElementInput;
//            
//            [filter setFrameProcessingCompletionBlock:^(GPUImageOutput * filter, CMTime frameTime){
//                timeLabel.text = [NSString stringWithFormat:@"Time: %f s", -[startTime timeIntervalSinceNow]];
//                [weakUIElementInput update];
//            }];
//        }
//        else if (filterType == GPUIMAGE_BUFFER)
//        {
//            GPUImageDifferenceBlendFilter *blendFilter = [[GPUImageDifferenceBlendFilter alloc] init];
//            
//            [videoCamera removeTarget:filter];
//            
//            GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc] init];
//            [videoCamera addTarget:gammaFilter];
//            [gammaFilter addTarget:blendFilter];
//            [videoCamera addTarget:filter];
//            
//            [filter addTarget:blendFilter];
//            
//            [blendFilter addTarget:filterView];
//        }
//        else if ( (filterType == GPUIMAGE_OPACITY) || (filterType == GPUIMAGE_CHROMAKEYNONBLEND) )
//        {
//            [sourcePicture removeTarget:filter];
//            [videoCamera removeTarget:filter];
//            [videoCamera addTarget:filter];
//            
//            GPUImageAlphaBlendFilter *blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
//            blendFilter.mix = 1.0;
//            [sourcePicture addTarget:blendFilter];
//            [filter addTarget:blendFilter];
//            
//            [blendFilter addTarget:filterView];
//        }
//        else if ( (filterType == GPUIMAGE_SPHEREREFRACTION) || (filterType == GPUIMAGE_GLASSSPHERE) )
//        {
//            // Provide a blurred image for a cool-looking background
//            GPUImageGaussianBlurFilter *gaussianBlur = [[GPUImageGaussianBlurFilter alloc] init];
//            [videoCamera addTarget:gaussianBlur];
//            gaussianBlur.blurRadiusInPixels = 5.0;
//            
//            GPUImageAlphaBlendFilter *blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
//            blendFilter.mix = 1.0;
//            [gaussianBlur addTarget:blendFilter];
//            [filter addTarget:blendFilter];
//            
//            [blendFilter addTarget:filterView];
//            
//        }
//        else if (filterType == GPUIMAGE_AVERAGECOLOR)
//        {
//            GPUImageSolidColorGenerator *colorGenerator = [[GPUImageSolidColorGenerator alloc] init];
//            [colorGenerator forceProcessingAtSize:[filterView sizeInPixels]];
//            
//            [(GPUImageAverageColor *)filter setColorAverageProcessingFinishedBlock:^(CGFloat redComponent, CGFloat greenComponent, CGFloat blueComponent, CGFloat alphaComponent, CMTime frameTime) {
//                [colorGenerator setColorRed:redComponent green:greenComponent blue:blueComponent alpha:alphaComponent];
//                //                NSLog(@"Average color: %f, %f, %f, %f", redComponent, greenComponent, blueComponent, alphaComponent);
//            }];
//            
//            [colorGenerator addTarget:filterView];
//        }
//        else if (filterType == GPUIMAGE_LUMINOSITY)
//        {
//            GPUImageSolidColorGenerator *colorGenerator = [[GPUImageSolidColorGenerator alloc] init];
//            [colorGenerator forceProcessingAtSize:[filterView sizeInPixels]];
//            
//            [(GPUImageLuminosity *)filter setLuminosityProcessingFinishedBlock:^(CGFloat luminosity, CMTime frameTime) {
//                [colorGenerator setColorRed:luminosity green:luminosity blue:luminosity alpha:1.0];
//            }];
//            
//            [colorGenerator addTarget:filterView];
//        }
//        else
//        {
//            [filter addTarget:filterView];
//        }
//    

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
        case GPUIMAGE_SEPIA: [(GPUImageSepiaFilter *)filter setIntensity:[(UISlider *)sender value]]; break;
        case GPUIMAGE_PIXELLATE: [(GPUImagePixellateFilter *)filter setFractionalWidthOfAPixel:[(UISlider *)sender value]]; break;
        case GPUIMAGE_POLARPIXELLATE: [(GPUImagePolarPixellateFilter *)filter setPixelSize:CGSizeMake([(UISlider *)sender value], [(UISlider *)sender value])]; break;
        case GPUIMAGE_PIXELLATE_POSITION: [(GPUImagePixellatePositionFilter *)filter setRadius:[(UISlider *)sender value]]; break;
        case GPUIMAGE_POLKADOT: [(GPUImagePolkaDotFilter *)filter setFractionalWidthOfAPixel:[(UISlider *)sender value]]; break;
        case GPUIMAGE_HALFTONE: [(GPUImageHalftoneFilter *)filter setFractionalWidthOfAPixel:[(UISlider *)sender value]]; break;
        case GPUIMAGE_SATURATION: [(GPUImageSaturationFilter *)filter setSaturation:[(UISlider *)sender value]]; break;
        case GPUIMAGE_CONTRAST: [(GPUImageContrastFilter *)filter setContrast:[(UISlider *)sender value]]; break;
        case GPUIMAGE_BRIGHTNESS: [(GPUImageBrightnessFilter *)filter setBrightness:[(UISlider *)sender value]]; break;
        case GPUIMAGE_LEVELS: {
            float value = [(UISlider *)sender value];
            [(GPUImageLevelsFilter *)filter setRedMin:value gamma:1.0 max:1.0 minOut:0.0 maxOut:1.0];
            [(GPUImageLevelsFilter *)filter setGreenMin:value gamma:1.0 max:1.0 minOut:0.0 maxOut:1.0];
            [(GPUImageLevelsFilter *)filter setBlueMin:value gamma:1.0 max:1.0 minOut:0.0 maxOut:1.0];
        }; break;
        case GPUIMAGE_EXPOSURE: [(GPUImageExposureFilter *)filter setExposure:[(UISlider *)sender value]]; break;
        case GPUIMAGE_MONOCHROME: [(GPUImageMonochromeFilter *)filter setIntensity:[(UISlider *)sender value]]; break;
        case GPUIMAGE_RGB: [(GPUImageRGBFilter *)filter setGreen:[(UISlider *)sender value]]; break;
        case GPUIMAGE_HUE: [(GPUImageHueFilter *)filter setHue:[(UISlider *)sender value]]; break;
        case GPUIMAGE_WHITEBALANCE: [(GPUImageWhiteBalanceFilter *)filter setTemperature:[(UISlider *)sender value]]; break;
        case GPUIMAGE_SHARPEN: [(GPUImageSharpenFilter *)filter setSharpness:[(UISlider *)sender value]]; break;
        case GPUIMAGE_HISTOGRAM: [(GPUImageHistogramFilter *)filter setDownsamplingFactor:round([(UISlider *)sender value])]; break;
        case GPUIMAGE_HISTOGRAM_EQUALIZATION: [(GPUImageHistogramEqualizationFilter *)filter setDownsamplingFactor:round([(UISlider *)sender value])]; break;
        case GPUIMAGE_UNSHARPMASK: [(GPUImageUnsharpMaskFilter *)filter setIntensity:[(UISlider *)sender value]]; break;
            //        case GPUIMAGE_UNSHARPMASK: [(GPUImageUnsharpMaskFilter *)filter setBlurSize:[(UISlider *)sender value]]; break;
        case GPUIMAGE_GAMMA: [(GPUImageGammaFilter *)filter setGamma:[(UISlider *)sender value]]; break;
        case GPUIMAGE_CROSSHATCH: [(GPUImageCrosshatchFilter *)filter setCrossHatchSpacing:[(UISlider *)sender value]]; break;
        case GPUIMAGE_POSTERIZE: [(GPUImagePosterizeFilter *)filter setColorLevels:round([(UISlider*)sender value])]; break;
        case GPUIMAGE_HAZE: [(GPUImageHazeFilter *)filter setDistance:[(UISlider *)sender value]]; break;
        case GPUIMAGE_SOBELEDGEDETECTION: [(GPUImageSobelEdgeDetectionFilter *)filter setEdgeStrength:[(UISlider *)sender value]]; break;
        case GPUIMAGE_PREWITTEDGEDETECTION: [(GPUImagePrewittEdgeDetectionFilter *)filter setEdgeStrength:[(UISlider *)sender value]]; break;
        case GPUIMAGE_SKETCH: [(GPUImageSketchFilter *)filter setEdgeStrength:[(UISlider *)sender value]]; break;
        case GPUIMAGE_THRESHOLD: [(GPUImageLuminanceThresholdFilter *)filter setThreshold:[(UISlider *)sender value]]; break;
        case GPUIMAGE_ADAPTIVETHRESHOLD: [(GPUImageAdaptiveThresholdFilter *)filter setBlurRadiusInPixels:[(UISlider*)sender value]]; break;
        case GPUIMAGE_AVERAGELUMINANCETHRESHOLD: [(GPUImageAverageLuminanceThresholdFilter *)filter setThresholdMultiplier:[(UISlider *)sender value]]; break;
        case GPUIMAGE_DISSOLVE: [(GPUImageDissolveBlendFilter *)filter setMix:[(UISlider *)sender value]]; break;
        case GPUIMAGE_POISSONBLEND: [(GPUImagePoissonBlendFilter *)filter setMix:[(UISlider *)sender value]]; break;
        case GPUIMAGE_LOWPASS: [(GPUImageLowPassFilter *)filter setFilterStrength:[(UISlider *)sender value]]; break;
        case GPUIMAGE_HIGHPASS: [(GPUImageHighPassFilter *)filter setFilterStrength:[(UISlider *)sender value]]; break;
        case GPUIMAGE_MOTIONDETECTOR: [(GPUImageMotionDetector *)filter setLowPassFilterStrength:[(UISlider *)sender value]]; break;
        case GPUIMAGE_CHROMAKEY: [(GPUImageChromaKeyBlendFilter *)filter setThresholdSensitivity:[(UISlider *)sender value]]; break;
        case GPUIMAGE_CHROMAKEYNONBLEND: [(GPUImageChromaKeyFilter *)filter setThresholdSensitivity:[(UISlider *)sender value]]; break;
        case GPUIMAGE_KUWAHARA: [(GPUImageKuwaharaFilter *)filter setRadius:round([(UISlider *)sender value])]; break;
        case GPUIMAGE_SWIRL: [(GPUImageSwirlFilter *)filter setAngle:[(UISlider *)sender value]]; break;
        case GPUIMAGE_EMBOSS: [(GPUImageEmbossFilter *)filter setIntensity:[(UISlider *)sender value]]; break;
        case GPUIMAGE_CANNYEDGEDETECTION: [(GPUImageCannyEdgeDetectionFilter *)filter setBlurTexelSpacingMultiplier:[(UISlider*)sender value]]; break;
            //        case GPUIMAGE_CANNYEDGEDETECTION: [(GPUImageCannyEdgeDetectionFilter *)filter setLowerThreshold:[(UISlider*)sender value]]; break;
        case GPUIMAGE_HARRISCORNERDETECTION: [(GPUImageHarrisCornerDetectionFilter *)filter setThreshold:[(UISlider*)sender value]]; break;
        case GPUIMAGE_NOBLECORNERDETECTION: [(GPUImageNobleCornerDetectionFilter *)filter setThreshold:[(UISlider*)sender value]]; break;
        case GPUIMAGE_SHITOMASIFEATUREDETECTION: [(GPUImageShiTomasiFeatureDetectionFilter *)filter setThreshold:[(UISlider*)sender value]]; break;
        case GPUIMAGE_HOUGHTRANSFORMLINEDETECTOR: [(GPUImageHoughTransformLineDetector *)filter setLineDetectionThreshold:[(UISlider*)sender value]]; break;
            //        case GPUIMAGE_HARRISCORNERDETECTION: [(GPUImageHarrisCornerDetectionFilter *)filter setSensitivity:[(UISlider*)sender value]]; break;
        case GPUIMAGE_THRESHOLDEDGEDETECTION: [(GPUImageThresholdEdgeDetectionFilter *)filter setThreshold:[(UISlider *)sender value]]; break;
        case GPUIMAGE_SMOOTHTOON: [(GPUImageSmoothToonFilter *)filter setBlurRadiusInPixels:[(UISlider*)sender value]]; break;
        case GPUIMAGE_THRESHOLDSKETCH: [(GPUImageThresholdSketchFilter *)filter setThreshold:[(UISlider *)sender value]]; break;
            //        case GPUIMAGE_BULGE: [(GPUImageBulgeDistortionFilter *)filter setRadius:[(UISlider *)sender value]]; break;
        case GPUIMAGE_BULGE: [(GPUImageBulgeDistortionFilter *)filter setScale:[(UISlider *)sender value]]; break;
        case GPUIMAGE_SPHEREREFRACTION: [(GPUImageSphereRefractionFilter *)filter setRadius:[(UISlider *)sender value]]; break;
        case GPUIMAGE_GLASSSPHERE: [(GPUImageGlassSphereFilter *)filter setRadius:[(UISlider *)sender value]]; break;
        case GPUIMAGE_TONECURVE: [(GPUImageToneCurveFilter *)filter setBlueControlPoints:[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)], [NSValue valueWithCGPoint:CGPointMake(0.5, [(UISlider *)sender value])], [NSValue valueWithCGPoint:CGPointMake(1.0, 0.75)], nil]]; break;
        case GPUIMAGE_HIGHLIGHTSHADOW: [(GPUImageHighlightShadowFilter *)filter setHighlights:[(UISlider *)sender value]]; break;
        case GPUIMAGE_PINCH: [(GPUImagePinchDistortionFilter *)filter setScale:[(UISlider *)sender value]]; break;
        case GPUIMAGE_PERLINNOISE:  [(GPUImagePerlinNoiseFilter *)filter setScale:[(UISlider *)sender value]]; break;
        case GPUIMAGE_MOSAIC:  [(GPUImageMosaicFilter *)filter setDisplayTileSize:CGSizeMake([(UISlider *)sender value], [(UISlider *)sender value])]; break;
        case GPUIMAGE_VIGNETTE: [(GPUImageVignetteFilter *)filter setVignetteEnd:[(UISlider *)sender value]]; break;
        case GPUIMAGE_BOXBLUR: [(GPUImageBoxBlurFilter *)filter setBlurRadiusInPixels:[(UISlider*)sender value]]; break;
        case GPUIMAGE_GAUSSIAN: [(GPUImageGaussianBlurFilter *)filter setBlurRadiusInPixels:[(UISlider*)sender value]]; break;
            //        case GPUIMAGE_GAUSSIAN: [(GPUImageGaussianBlurFilter *)filter setBlurPasses:round([(UISlider*)sender value])]; break;
            //        case GPUIMAGE_BILATERAL: [(GPUImageBilateralFilter *)filter setBlurSize:[(UISlider*)sender value]]; break;
        case GPUIMAGE_BILATERAL: [(GPUImageBilateralFilter *)filter setDistanceNormalizationFactor:[(UISlider*)sender value]]; break;
        case GPUIMAGE_MOTIONBLUR: [(GPUImageMotionBlurFilter *)filter setBlurAngle:[(UISlider*)sender value]]; break;
        case GPUIMAGE_ZOOMBLUR: [(GPUImageZoomBlurFilter *)filter setBlurSize:[(UISlider*)sender value]]; break;
        case GPUIMAGE_OPACITY:  [(GPUImageOpacityFilter *)filter setOpacity:[(UISlider *)sender value]]; break;
        case GPUIMAGE_GAUSSIAN_SELECTIVE: [(GPUImageGaussianSelectiveBlurFilter *)filter setExcludeCircleRadius:[(UISlider*)sender value]]; break;
        case GPUIMAGE_GAUSSIAN_POSITION: [(GPUImageGaussianBlurPositionFilter *)filter setBlurRadius:[(UISlider *)sender value]]; break;
        case GPUIMAGE_FILTERGROUP: [(GPUImagePixellateFilter *)[(GPUImageFilterGroup *)filter filterAtIndex:1] setFractionalWidthOfAPixel:[(UISlider *)sender value]]; break;
        case GPUIMAGE_CROP: [(GPUImageCropFilter *)filter setCropRegion:CGRectMake(0.0, 0.0, 1.0, [(UISlider*)sender value])]; break;
        case GPUIMAGE_TRANSFORM: [(GPUImageTransformFilter *)filter setAffineTransform:CGAffineTransformMakeRotation([(UISlider*)sender value])]; break;
        case GPUIMAGE_TRANSFORM3D:
        {
            CATransform3D perspectiveTransform = CATransform3DIdentity;
            perspectiveTransform.m34 = 0.4;
            perspectiveTransform.m33 = 0.4;
            perspectiveTransform = CATransform3DScale(perspectiveTransform, 0.75, 0.75, 0.75);
            perspectiveTransform = CATransform3DRotate(perspectiveTransform, [(UISlider*)sender value], 0.0, 1.0, 0.0);
            
            [(GPUImageTransformFilter *)filter setTransform3D:perspectiveTransform];
        }; break;
        case GPUIMAGE_TILTSHIFT:
        {
            CGFloat midpoint = [(UISlider *)sender value];
            [(GPUImageTiltShiftFilter *)filter setTopFocusLevel:midpoint - 0.1];
            [(GPUImageTiltShiftFilter *)filter setBottomFocusLevel:midpoint + 0.1];
        }; break;
        case GPUIMAGE_LOCALBINARYPATTERN:
        {
            CGFloat multiplier = [(UISlider *)sender value];
            [(GPUImageLocalBinaryPatternFilter *)filter setTexelWidth:(multiplier / self.view.bounds.size.width)];
            [(GPUImageLocalBinaryPatternFilter *)filter setTexelHeight:(multiplier / self.view.bounds.size.height)];
        }; break;
        default: break;
    }
}

#pragma mark - Face Detection Delegate Callback
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer{
//    UIImage *img = [self imageFromSamplePlanerPixelBuffer:sampleBuffer];
//    
//    cv::Mat srcImg = [CvMatUIImageConverter cvMatFromUIImage:img];
//    
//    cv::Point2f* src = (cv::Point2f*) malloc(4 * sizeof(cv::Point2f));
//    cv::Point2f* dst = (cv::Point2f*) malloc(4 * sizeof(cv::Point2f));
//    
//    int dstImgSize = 400;
//    
//
//    std::vector<cv::Point2f> detectedCorners = CheckDet::getOuterCheckerboardCorners(srcImg);
//    for (int i = 0; i < MIN(4, detectedCorners.size()); i++) {
//        cv::circle(srcImg, cv::Point2i(detectedCorners[i].x, detectedCorners[i].y), 7, cv::Scalar(127, 127, 255), -1);
//        src[i] = detectedCorners[i];
//    }
//    
////    printf("getPerspectiveTransform\n");
////    printf("    input\n");
////    for (int i = 0; i < 4; i++) {
////        printf("        (%5.1f, %5.1f) -> (%5.1f, %5.1f)\n", src[i].x, src[i].y, dst[i].x, dst[i].y);
////    }
//    
//    cv::Mat m = cv::getPerspectiveTransform(src, dst);
//    
////    printf("    output\n");
////    for(int i = 0; i < m.rows; i++) {
////        const double* mi = m.ptr<double>(i);
////        printf("        ( ");
////        for(int j = 0; j < m.cols; j++) {
////            printf("%8.1f ", mi[j]);
////        }
////        printf(")\n");
////    }
//    free(dst);
//    free(src);
//    
//    cv::Mat plainBoardImg;
//    cv::warpPerspective(srcImg, plainBoardImg, m, cv::Size(dstImgSize, dstImgSize));
//    
////    cv::Rect fieldRect = cv::Rect(0, 0, plainBoardImg.cols / 8, plainBoardImg.rows / 8);
////    cv::Mat fieldType0Mean = cv::Mat::zeros(fieldRect.height, fieldRect.width, CV_16UC4);
////    cv::Mat fieldType1Mean = cv::Mat::zeros(fieldRect.height, fieldRect.width, CV_16UC4);
////    for (int i = 0; i < 8; i++) {
////        for (int j = 0; j < 8; j++) {
////            fieldRect.x = fieldRect.width * i;
////            fieldRect.y = fieldRect.height * j;
////            
////            cv::Mat field(plainBoardImg, fieldRect);
////            field.convertTo(field, CV_16UC4);
////            field /= 32;
////            
////            if ((i + j) % 2 == 0) {
////                fieldType0Mean += field;
////            } else {
////                fieldType1Mean += field;
////            }
////        }
////    }
////    
////    NSMutableArray *fields = [[NSMutableArray alloc] init];
////    
////    for (int i = 0; i < 8; i++) {
////        for (int j = 0; j < 8; j++) {
////            fieldRect.x = fieldRect.width * i;
////            fieldRect.y = fieldRect.height * j;
////            
////            cv::Mat field(plainBoardImg, fieldRect);
////            field.convertTo(field, CV_16UC4);
////            field /= 32;
////            
////            [fields addObject:[CvMatUIImageConverter UIImageFromCVMat:field]];
////            
////            if ((i + j) % 2 == 0) {
////                fieldType0Mean += field;
////            } else {
////                fieldType1Mean += field;
////            }
////        }
////    }
//    
////    fieldRect.x = 0; fieldRect.y = 0;
////    fieldType0Mean.copyTo(srcImg(fieldRect));
////    fieldRect.x = fieldRect.width; fieldRect.y = 0;
////    fieldType1Mean.copyTo(srcImg(fieldRect));
//    
////    cv::Scalar meanPixel = cv::mean(fieldType0Mean);
////    meanPixel.val[3] = 0;
////    double brightnessType0 = sqrtl(meanPixel.dot(meanPixel));
////    
////    meanPixel = cv::mean(fieldType1Mean);
////    meanPixel.val[3] = 0;
////    double brightnessType1 = sqrtl(meanPixel.dot(meanPixel));
////    
////    if (brightnessType0 < brightnessType1) {
////        //printf("board is adjusted left-right, thus it needs to be rotated 90deg\n");
////        cv::transpose(plainBoardImg, plainBoardImg);
////        cv::flip(plainBoardImg, plainBoardImg, 0);
////    }
//    
////    cv::Mat sub = srcImg(cv::Rect(srcImg.cols - plainBoardImg.cols, 0, plainBoardImg.cols, plainBoardImg.rows));
////    plainBoardImg.copyTo(sub);
//    
//    //    [self.subView setImage:[CvMatUIImageConverter UIImageFromCVMat:fieldType0Mean]];
//    
//    ShowFrameViewController *parent = (ShowFrameViewController *)self.parentViewController;
//
//    UIImage* combinedImg = [CvMatUIImageConverter UIImageFromCVMat:srcImg];
////    UIImage* plain = [CvMatUIImageConverter UIImageFromCVMat:plainBoardImg];
////    UIImageFromCVMat
//    UIImage *plain = [self UIImageFromCVMat:plainBoardImg];
//    // plainBoardImg
////
////    [parent.imgView setImage:combinedImg];
//    
//    dispatch_async(dispatch_get_main_queue(), ^{[parent.imgView setImage:combinedImg]; [parent.subView setImage:plain];});
    
//    self.imgView.image = combinedImg;
    
    
}

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    colorSpace = CGColorSpaceCreateDeviceGray();
    
//    if (cvMat.elemSize() == 1) {
//        colorSpace = CGColorSpaceCreateDeviceGray();
//    } else {
//        colorSpace = CGColorSpaceCreateDeviceRGB();
//    }
    
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
