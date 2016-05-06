
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
@synthesize imagesToProcess;
@synthesize whiteOnBlack, whiteOnWhite, blackOnBlack,blackOnWhite;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imagesToProcess = [[NSMutableArray alloc] init];
    filterType = GPUIMAGE_FACES;
    [self setupFilter];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    NSLog(@"got data?");
}

- (void)setupFilter;
{
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    
    
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
//    videoDataOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA] forKey:(NSString*)kCVPixelBufferPixelFormatTypeKey]];
    
    AVCaptureVideoDataOutput *output = [[[videoCamera captureSession] outputs] lastObject];
////    NSDictionary* outputSettings = [output videoSettings];
//    output.videoSettings = @{ (id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA) };
//    output.videoSettings = @{ (id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32RGBA) };
//    output.videoSettings = @{ (id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32ABGR) };

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
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.01];
            [self.filterSettingsSlider setMaximumValue:0.70];
            [self.filterSettingsSlider setValue:0.20];
            
            filter = [[GPUImageFilterGroup alloc] init];
            
            GPUImageXYDerivativeFilter *xyF = [[GPUImageXYDerivativeFilter alloc] init];
            [(GPUImageFilterGroup *)filter addFilter:xyF];
            
            GPUImageHarrisCornerDetectionFilter *harrisCorner = [[GPUImageHarrisCornerDetectionFilter alloc] init];
            [(GPUImageHarrisCornerDetectionFilter *)harrisCorner setThreshold:0.001];
            [(GPUImageFilterGroup *)filter addFilter:harrisCorner];
            
            GPUImageHoughTransformLineDetector *houghFilter = [[GPUImageHoughTransformLineDetector alloc] init];
            [(GPUImageHoughTransformLineDetector *)houghFilter setLineDetectionThreshold:0.004];
            [(GPUImageFilterGroup *)filter addFilter:houghFilter];
            
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
            [(GPUImage3x3ConvolutionFilter *)filter setConvolutionKernel:(GPUMatrix3x3){
                {0.0f, 1.0f, 0.0f},
                {1.0f,  1.0f, 1.0f},
                { 0.0f,  1.0f, 0.0f}
            }];
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
            self.title = @"Harris Corner Detection";

            
            self.title = @"RGB";
            self.filterSettingsSlider.hidden = NO;
            
            [self.filterSettingsSlider setMinimumValue:0.0];
            [self.filterSettingsSlider setMaximumValue:2.0];
            [self.filterSettingsSlider setValue:1.0];
            
            filter = [[GPUImageRGBFilter alloc] init];

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
    }
    if (filterType != GPUIMAGE_VORONOI)
    {
        [videoCamera addTarget:filter];
    }
     
    videoCamera.runBenchmark = YES;
    GPUImageView *filterView = (GPUImageView *)self.view;
    
    [filter addTarget:filterView];
    [videoCamera startCameraCapture];
}
bool lastNumOfPoints;
bool busy;
int i=0, j=0;
#pragma mark - Face Detection Delegate Callback
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    
    [self printColors];
    
    UIImage *img = [self imageFromSamplePlanerPixelBuffer:sampleBuffer];
    

    if (!busy && img != nil) {
        [self.imagesToProcess addObject:img];
        [self performSelectorInBackground:@selector(processArray) withObject:nil];
    } else {
        return;
    }
}

int position=0;
- (void) processArray {
    busy = YES;
    if (imagesToProcess.count < 1) {
        return;
    }
    for (int i = 0; i<imagesToProcess.count; i++) {
        UIImage *img = [imagesToProcess objectAtIndex:i];
        [self findBoardMove:img];
    }
    imagesToProcess = [[NSMutableArray alloc] init];
    busy = NO;
}

- (void ) printColors {
    
    if (whiteOnWhite) {
        NSLog(@"/n /n /n");
        NSLog(@"XXXXXXXSXXXXX");
        
        CGColorRef color = [whiteOnWhite CGColor];
        
        const CGFloat *components = CGColorGetComponents(color);
        CGFloat colorOfField = components[0];
        NSLog(@"white on white %f", colorOfField);
        
        color = [whiteOnBlack CGColor];
        components = CGColorGetComponents(color);
        colorOfField = components[0];
        NSLog(@"white on black %f", colorOfField);
        
        color = [blackOnBlack CGColor];
        components = CGColorGetComponents(color);
        colorOfField = components[0];
        NSLog(@"black on black %f", colorOfField);
        
        color = [blackOnWhite CGColor];
        components = CGColorGetComponents(color);
        colorOfField = components[0];
        NSLog(@"black on black %f", colorOfField);
        
        NSLog(@"XXXXXXXSXXXXX");
        NSLog(@"/n /n /n");
    }

}

-(void)findBoardMove:(UIImage *) img {
    
    ShowFrameViewController *parent = (ShowFrameViewController *)self.parentViewController;
    self.selectedImage = parent.selectedImage;
    bool newSelection = parent.newSelection;
    
    cv::Mat srcImg = [CvMatUIImageConverter cvMatFromUIImage:img];
    
    cv::Point2f* src = (cv::Point2f*) malloc(4 * sizeof(cv::Point2f));
    cv::Point2f* dst = (cv::Point2f*) malloc(4 * sizeof(cv::Point2f));
    
    int dstImgSize = 400;
    
    // if not 49 points then its not a full board
    int numberOfPoints = 0;
    std::vector<cv::Point2f> detectedCorners = CheckDet::getOuterCheckerboardCorners(srcImg, numberOfPoints);
    
    printf("number of point %d\n", numberOfPoints);
    if(numberOfPoints < [parent.numberOfCorners intValue] ) {
        lastNumOfPoints = NO;
        return;
    }
    
    if (lastNumOfPoints == YES && imagesToProcess.count < 5) {
        return;
    }
    
    
    lastNumOfPoints = YES;
    // do comparision and id the the 47points in the harris corner detector array
    
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
    
    cv::Mat plainBoardImg;
    
    cv::Mat srcImgCopy = [CvMatUIImageConverter cvMatFromUIImage:img];
    cv::warpPerspective(srcImgCopy, plainBoardImg, m, cv::Size(dstImgSize, dstImgSize));
    cv::transpose(srcImgCopy, srcImg);
    cv::flip(srcImgCopy,srcImg,1);
    
    UIImage* combinedImg = [CvMatUIImageConverter UIImageFromCVMat:srcImgCopy];
    
    cv::transpose(plainBoardImg, plainBoardImg);
    cv::flip(plainBoardImg, plainBoardImg, 1);
    
    UIImage *plain = [self UIImageFromCVMat:plainBoardImg];
    
    if(!parent.chessImages)
        parent.chessImages = [[NSMutableArray alloc] init];
    [parent.chessImages addObject:plain];
    int position = (int)parent.chessImages.count -1;
    
    [parent.collectionView reloadData];
    [parent.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:position inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
    // change method calls after light intensity found
    
    UIImage* firstField;
    if (!whiteOnWhite) {
        firstField = [self lightOrDarkPiece:plain];
    }
    if(whiteOnWhite && newSelection){
        firstField = [self lightOrDarkPiece:plain];
        parent.newSelection = NO;
        [self printColors];
        
    }
    
    if (parent.chessImages.count > _selectedImage && _selectedImage > 2 ) {
        firstField = [self lightOrDarkPiece:plain];
        NSString *fieldNotation = [self whichSquaresChanged:plain];
        NSLog(@"Field: %@", fieldNotation);
    }
    
    UIColor* average = [self averageColor:firstField];
    
    dispatch_async(dispatch_get_main_queue(), ^{[parent.imgView setImage:combinedImg]; [parent.subView setImage:firstField]; [parent.averageColor setBackgroundColor:average];});

    self.imgView.image = combinedImg;
}
#pragma mark - piece movement detection
-(NSString *)whichSquaresChanged:(UIImage *) img{
    int widthOfField = img.size.width/8;
    int heightOfField = img.size.height/8;
    
    int horizontalLocation = 0;
    int verticalLocation = 0;
    
    for (int i=0; i<8; i++) {
        // calculate horizontal position
        verticalLocation = i*heightOfField;
        
        for (int j=0; j<8; j++) {
            // calculate vertical position
            horizontalLocation = j*widthOfField;
            
            CGRect rect = CGRectMake(horizontalLocation, verticalLocation, widthOfField, heightOfField);
            
            CGImageRef drawImage = CGImageCreateWithImageInRect(img.CGImage, rect);
            UIImage *field = [UIImage imageWithCGImage:drawImage];
            CGImageRelease(drawImage);
            UIColor *fieldColor = [self averageColor:field];
            
            // if the color changed since the last time
            // check min dist to known averages
            // check rule for creating notation
            
            // colors data
            UIColor *uicolor = whiteOnWhite;
            
            if((i+j % 2) == 0 && blackOnBlack)
            {
                uicolor = blackOnBlack;
            }
            
            CGColorRef color = [uicolor CGColor];
            
            int numComponents = (int)CGColorGetNumberOfComponents(color);
            
            if (numComponents == 4)
            {
                const CGFloat *components = CGColorGetComponents(color);
                CGFloat red = components[0];
                CGFloat green = components[1];
                CGFloat blue = components[2];
                
                color = [fieldColor CGColor];
                components = CGColorGetComponents(color);
                CGFloat red_field = components[0];
                CGFloat green_field = components[1];
                CGFloat blue_field = components[2];
                
                CGFloat difference = 0.016;
                if((red_field - red) > 0.2) {
                    NSLog(@"might have a real change");
                    NSLog(@"Location x: %i  y: %i" ,i,j);
                    NSLog(@"\n");
                    NSLog(@"red %f", red_field - red);
                }
                
                
                if(fabs(red_field - red) <= difference || fabs(green_field - green) <= difference || fabs(blue_field - blue) <= difference ) {
                    NSLog(@"whiteOnBlack found");
                    NSLog(@"Location x: %i  y: %i" ,i,j);
                }
            }
        }
    }
    
    return @"";
}



#pragma mark - color detection
-(UIImage *)lightOrDarkPiece:(UIImage *)img{
    int widthOfField = img.size.width/8;
    int heightOfField = img.size.height/8;
    
    
    // TEST Fields
//    int test_position_top_left_x = 0;
//    int test_position_top_left_y = heightOfField*2;
    
    int test_position_top_right_x = img.size.width - widthOfField;
//    int test_position_top_right_y = heightOfField*2;
    
//    int test_position_bottom_left_x = 0;
    int test_position_bottom_left_y = img.size.height - heightOfField*2;
    
    int test_position_bottom_right_x = img.size.width - widthOfField;
    int test_position_bottom_right_y = img.size.height - heightOfField*2;
    
    CGRect test_topLeftRect = CGRectMake(0, 0, widthOfField, heightOfField);
    CGRect test_topRightRect = CGRectMake(test_position_top_right_x, 0, widthOfField, heightOfField);
    CGRect test_bottomLeftRect = CGRectMake(0, test_position_bottom_left_y, widthOfField, heightOfField);
    CGRect test_bottomRightRect = CGRectMake(test_position_bottom_right_x, test_position_bottom_right_y, widthOfField, heightOfField);
    
    CGImageRef test_drawImage = CGImageCreateWithImageInRect(img.CGImage, test_topLeftRect);
    UIImage *test_newImage = [UIImage imageWithCGImage:test_drawImage];
    CGImageRelease(test_drawImage);
//    UIColor* test_whiteOnBlack = [self averageColor:test_newImage];
    
    test_drawImage = CGImageCreateWithImageInRect(img.CGImage, test_topRightRect);
    test_newImage = [UIImage imageWithCGImage:test_drawImage];
    CGImageRelease(test_drawImage);
//    UIColor* test_whiteOnWhite = [self averageColor:test_newImage];
    
    test_drawImage = CGImageCreateWithImageInRect(img.CGImage, test_bottomLeftRect);
    test_newImage = [UIImage imageWithCGImage:test_drawImage];
    CGImageRelease(test_drawImage);
//    UIColor* test_blackOnWhite = [self averageColor:test_newImage];
    
    test_drawImage = CGImageCreateWithImageInRect(img.CGImage, test_bottomRightRect);
    test_newImage = [UIImage imageWithCGImage:test_drawImage];
    CGImageRelease(test_drawImage);
//    UIColor* test_blackOnBlack = [self averageColor:test_newImage];
    
    /*
     1 2 3 4 5 6 7 8
     2 2 3 4 5 6 7 8
     3 2 3 4 5 6 7 8
     4 2 3 4 5 6 7 8
     5 2 3 4 5 6 7 8
     6 2 3 4 5 6 7 8
     7 2 3 4 5 6 7 8
     8 2 3 4 5 6 7 8
     */
    
    int position_top_left_x = 0;
    int position_top_left_y = 0;
    
    int position_top_right_x = img.size.width - img.size.width/8;
    int position_top_right_y = 0;
    
    int position_bottom_left_x = 0;
    int position_bottom_left_y = img.size.height - img.size.height/8;
    
    int position_bottom_right_x = img.size.width - img.size.width/8;
    int position_bottom_right_y = img.size.height - img.size.height/8;

    CGRect topLeftRect = CGRectMake(position_top_left_x, position_top_left_y, img.size.width/8, img.size.height/8);
    CGRect topRightRect = CGRectMake(position_top_right_x, position_top_right_y, img.size.width/8, img.size.height/8);
    CGRect bottomLeftRect = CGRectMake(position_bottom_left_x, position_bottom_left_y, img.size.width/8, img.size.height/8);
    CGRect bottomRightRect = CGRectMake(position_bottom_right_x, position_bottom_right_y, img.size.width/8, img.size.height/8);
    
    CGImageRef drawImage = CGImageCreateWithImageInRect(img.CGImage, topLeftRect);
    UIImage *newImage = [UIImage imageWithCGImage:drawImage];
    CGImageRelease(drawImage);
    whiteOnBlack = [self averageColor:newImage];
    
    
    drawImage = CGImageCreateWithImageInRect(img.CGImage, topRightRect);
    newImage = [UIImage imageWithCGImage:drawImage];
    CGImageRelease(drawImage);
    whiteOnWhite = [self averageColor:newImage];
    
    drawImage = CGImageCreateWithImageInRect(img.CGImage, bottomLeftRect);
    newImage = [UIImage imageWithCGImage:drawImage];
    CGImageRelease(drawImage);
    blackOnWhite = [self averageColor:newImage];
    
    drawImage = CGImageCreateWithImageInRect(img.CGImage, bottomRightRect);
    newImage = [UIImage imageWithCGImage:drawImage];
    CGImageRelease(drawImage);
    blackOnBlack = [self averageColor:newImage];
    
//    UIColor* average = [self averageColor:firstField];
    
    // testIntensity R|B|G - sample +- 0.02 <
    // testIntensity R|B|G - sample +- 0.019 <
    
    return newImage;
}


- (UIColor *)averageColor:(UIImage *)img {
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char rgba[4];
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), img.CGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    if(rgba[3] == 0) {
        CGFloat alpha = ((CGFloat)rgba[3])/255.0;
        CGFloat multiplier = alpha/255.0;
        return [UIColor colorWithRed:((CGFloat)rgba[0])*multiplier
                               green:((CGFloat)rgba[1])*multiplier
                                blue:((CGFloat)rgba[2])*multiplier
                               alpha:alpha];
    }
    else {
        return [UIColor colorWithRed:((CGFloat)rgba[0])/255.0
                               green:((CGFloat)rgba[1])/255.0
                                blue:((CGFloat)rgba[2])/255.0
                               alpha:((CGFloat)rgba[3])/255.0];
    }
}
//-(void) checkColorOfPieceOnField:(UIImage *)img {


//    //YUV(NV12)-->CIImage--->UIImage Conversion
//    NSDictionary *pixelAttributes = @{(id)kCVPixelBufferIOSurfacePropertiesKey : @{}};
//    CVPixelBufferRef pixelBuffer = NULL;
//    
//    CVReturn result = CVPixelBufferCreate(kCFAllocatorDefault,
//                                          640,
//                                          480,
//                                          kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange,
//                                          (__bridge CFDictionaryRef)(pixelAttributes),
//                                          &pixelBuffer);
//    CVPixelBufferLockBaseAddress(pixelBuffer,0);
//    unsigned char *yDestPlane = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
//    memcpy(yDestPlane, y_ch0, 640 * 480); //Here y_ch0 is Y-Plane of YUV(NV12) data.
//    unsigned char *uvDestPlane = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
//    memcpy(uvDestPlane, y_ch1, 640*480/2); //Here y_ch1 is UV-Plane of YUV(NV12) data.
//    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
//    
//    if (result != kCVReturnSuccess) {
//        NSLog(@"Unable to create cvpixelbuffer %d", result);
//    }
//    
//    CIImage *coreImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];//CIImage Conversion DONE!!!!
//    
//    CIContext *MytemporaryContext = [CIContext contextWithOptions:nil];
//    CGImageRef MyvideoImage = [MytemporaryContext
//                               createCGImage:coreImage
//                               fromRect:CGRectMake(0, 0,
//                                                   640,
//                                                   480)];
//    
//    UIImage *Mynnnimage = [[UIImage alloc] initWithCGImage:MyvideoImage scale:1.0 orientation:UIImageOrientationRight];//UIImage Conversion DONE!!!
//    CVPixelBufferRelease(pixelBuffer);
//    CGImageRelease(MyvideoImage);
//}



//-(void) checkColorOfPieceOnField:(cv::Mat )plainBoardImg {
//
//    NSMutableArray *fields = [[NSMutableArray alloc] init];
//    cv::Rect fieldRect = cv::Rect(0, 0, plainBoardImg.cols / 8, plainBoardImg.rows / 8);
//    cv::Mat fieldType0Mean = cv::Mat::zeros(fieldRect.height, fieldRect.width, CV_16UC4);
//    cv::Mat fieldType1Mean = cv::Mat::zeros(fieldRect.height, fieldRect.width, CV_16UC4);
//    
//    for (int i = 0; i < 8; i++) {
//        for (int j = 0; j < 8; j++) {
//            fieldRect.x = fieldRect.width * i;
//            fieldRect.y = fieldRect.height * j;
//            cv::Mat field(plainBoardImg, fieldRect);
//            field.convertTo(field, CV_16UC4);
//            field /= 32;
//            
//            if ((i + j) % 2 == 0) {
//                fieldType0Mean += field;
//            } else {
//                fieldType1Mean += field;
//            }
//            
//            [fields addObject:[CvMatUIImageConverter UIImageFromCVMat:field]];
//            
//            ShowFrameViewController *parent = (ShowFrameViewController *)self.parentViewController;
//            if(!parent.chessImages)
//                parent.chessImages = [[NSMutableArray alloc] init];
//            [parent.chessImages addObject:[CvMatUIImageConverter UIImageFromCVMat:field]];
//        }
//    }
//}

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
    int numberOfPoints =0;

    std::vector<cv::Point2f> detectedCorners = CheckDet::getOuterCheckerboardCorners(mat, numberOfPoints);
    for (int i = 0; i < MIN(4, detectedCorners.size()); i++) {
        cv::circle(mat, cv::Point2i(detectedCorners[i].x, detectedCorners[i].y), 7, cv::Scalar(127, 127, 255), -1);
        src[i] = detectedCorners[i];
    }
    
    cv::Mat m = cv::getPerspectiveTransform(src, dst);
    
    free(dst);
    free(src);
    
    
}

// Create a UIImage from sample buffer data
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    NSLog(@"w: %zu h: %zu bytesPerRow:%zu", width, height, bytesPerRow);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress,
                                                 width,
                                                 height,
                                                 8,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGBitmapByteOrder32Little
                                                 | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    //UIImage *image = [UIImage imageWithCGImage:quartzImage];
    UIImage *image = [UIImage imageWithCGImage:quartzImage 
                                         scale:1.0f 
                                   orientation:UIImageOrientationRight];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
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
    
//        CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
//        CGContextRef context =  CGBitmapContextCreate(NULL,
//                                                         640,
//                                                         480,
//                                                         8,
//                                                         4 * 680,
//                                                         colorSpace,
//                                                         kCGImageAlphaPremultipliedLast);
        
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

-(UIImage *) convertBuffer:(CMSampleBufferRef)sampleBuffer {
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
    return [CvMatUIImageConverter UIImageFromCVMat:mat];
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"chessFilterView"]) {
        return;
    }
}





@end
