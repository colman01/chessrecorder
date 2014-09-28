//
//  DetectCheckerboardViewController.m
//  chessrecorder
//
//  Created by Mac on 26.09.14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "DetectCheckerboardViewController.h"

#import "CvMatUIImageConverter.h"
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/calib3d/calib3d.hpp>
#include <opencv2/highgui/highgui.hpp>

//#include <vector>

@interface DetectCheckerboardViewController ()

@end

@implementation DetectCheckerboardViewController

@synthesize imageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareCamera];
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

// Some other filters of interest
//GPUImageAdaptiveThresholdFilter
//GPUImageBilateralFilter
//GPUImageHoughTransformLineDetector
//GPUImageLineGenerator

- (void) prepareCamera {
    CGRect mainScreenFrame = [[UIScreen mainScreen] applicationFrame];
    UIView *primaryView = [[UIView alloc] initWithFrame:mainScreenFrame] ;
    primaryView.backgroundColor = [UIColor blueColor];
    self.view = primaryView;
    
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    CGFloat halfWidth = round(mainScreenFrame.size.width / 2.0);
    CGFloat halfHeight = round(mainScreenFrame.size.height / 2.0);
    view1 = [[GPUImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, halfWidth, halfHeight)];
    view2 = [[GPUImageView alloc] initWithFrame:CGRectMake(halfWidth, 0.0, halfWidth, halfHeight)];
    view3 = [[GPUImageView alloc] initWithFrame:CGRectMake(0.0, halfHeight, halfWidth, halfHeight)];
    view4 = [[GPUImageView alloc] initWithFrame:CGRectMake(halfWidth, halfHeight, halfWidth, halfHeight)];
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    [self.view addSubview:view3];
    [self.view addSubview:view4];
    
    GPUImageGaussianBlurFilter *gaussian = [[GPUImageGaussianBlurFilter alloc] init];
    gaussian.blurRadiusInPixels = 5.0;
    
    GPUImage3x3ConvolutionFilter *derivativeXConv = [[GPUImage3x3ConvolutionFilter alloc] init];
    [(GPUImage3x3ConvolutionFilter *)derivativeXConv setConvolutionKernel:(GPUMatrix3x3){
        {1.0f,  0.0f, -1.0f},
        {1.0f, 0.0f, -1.0f},
        {1.0f,  0.0f, -1.0f}
    }];
    
    GPUImage3x3ConvolutionFilter *derivativeYConv = [[GPUImage3x3ConvolutionFilter alloc] init];
    [(GPUImage3x3ConvolutionFilter *)derivativeYConv setConvolutionKernel:(GPUMatrix3x3){
        {1.0f,  1.0f, 1.0f},
        {0.0f, 0.0f, 0.0f},
        {-1.0f,  -1.0f, -1.0f}
    }];
    
    
    
    [derivativeYConv forceProcessingAtSize:view2.sizeInPixels];
    [derivativeXConv forceProcessingAtSize:view3.sizeInPixels];
    

    GPUImage3x3ConvolutionFilter *cosConv = [[GPUImage3x3ConvolutionFilter alloc] init];
    [(GPUImage3x3ConvolutionFilter *)cosConv setConvolutionKernel:(GPUMatrix3x3){
        {cosf(M_PI_4),  0.0f, 0.0f},
        {0.0f, cosf(M_PI_4), 0.0f},
        {0.0f,  0.0f, cosf(M_PI_4)}
    }];
    
    GPUImage3x3ConvolutionFilter *sinConv = [[GPUImage3x3ConvolutionFilter alloc] init];
    [(GPUImage3x3ConvolutionFilter *)sinConv setConvolutionKernel:(GPUMatrix3x3){
        {sinf(M_PI_4),  0.0f, 0.0f},
        {0.0f, sinf(M_PI_4), 0.0f},
        {0.0f,  0.0f, sinf(M_PI_4)}
    }];

    UIImage *outputImage  = [[UIImage alloc] init];
    
    UIImage *img = [UIImage imageNamed:@"Chess-board.jpg"];

    UIImage *Ix = [derivativeXConv imageByFilteringImage:img];
    UIImage *Iy = [derivativeYConv imageByFilteringImage:img];
    
    UIImage *Ix_45 = [cosConv imageByFilteringImage:Ix];
    UIImage *Iy_45 = [sinConv imageByFilteringImage:Iy];
    


//    cv::Mat cvResult = [CvMatUIImageConverter cvMatGrayFromImage:outputImage];
    cv::Mat cvResult = [CvMatUIImageConverter cvMatGrayFromUIImage:outputImage];
    cv::Mat cvIx = [CvMatUIImageConverter cvMatGrayFromUIImage:Ix_45];
    cv::Mat cvIy = [CvMatUIImageConverter cvMatGrayFromUIImage:Iy_45];
//    cv::Mat cvIx = [CvMatUIImageConverter cvMatGrayFromImage:Ix_45];
//    cv::Mat cvIy = [CvMatUIImageConverter cvMatGrayFromImage:Iy_45];
    
    cv::add(cvIx, cvIy, cvResult);
    
//    + (UIImage *)imageWithCVMat:(const cv::Mat&)cvMat
    UIImage *cvOutput = [self imageWithCVMat:cvResult];
    
    [imageView setImage:cvOutput];
    
    
    
    
//    [C]
    
    
//    UIImage *I_45_x = cv::add(Ix, Iy, outputImage);
    
//    cv::Mat frame = [CvMatUIImageConverter cvMatGrayFromUIImage:img];
//    cv:cv::Mat Ix = [CvMatUIImageConverter cvMatFromUIImage:[derivativeXConv img]];
//    cv:cv::Mat Iy = [CvMatUIImageConverter cvMatFromUIImage:[derivativeYConv imag]];
//    cv:cv::Mat frame = [CvMatUIImageConverter cvMatFromUIImage:img];
//    
////    cv::multiply(frame, frame, frame);
//    cv::add(Ix, Iy, );

    
    
    // I_45 = Ix * cos(+PI/4) + Iy*sin(PI/4);
//    I_45 = Ix * cos(-PI/4) + Iy*sin(-PI/4);
//    % second derivative
//    Ixy = imfilter(Ix, derivFilter', 'conv');
//                   
//                   I_45_x = imfilter(I_45, derivFilter, 'conv');
//                   I_45_y = imfilter(I_45, derivFilter', 'conv');

//    I_45_45 = I_45_x * cos(-pi/4) + I_45_y * sin(-pi/4);
//    % suppress the outer corners
//    cxy = sigma^2 * abs(Ixy) - sigma * (abs(I_45) + abs(I_n45));
//    cxy(cxy < 0) = 0;
//    c45 = sigma^2 * abs(I_45_45) - sigma * (abs(Ix) + abs(Iy));
//    c45(c45 < 0) = 0;
    
    

    
    GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    [brightnessFilter setBrightness:cosf(M_PI_4)];
    

    NSArray *filters = [[NSArray alloc] initWithObjects:gaussian,derivativeXConv, derivativeYConv, cosConv , nil];
    
    pipeline = [[GPUImageFilterPipeline alloc] initWithOrderedFilters:filters input:videoCamera output:view4];
//    [pipeline_ addFilter:derivativeXConv];
//    [pipeline_ addFilter:derivativeYConv];
//    [pipeline_ addFilter:cosConv];

//    [videoCamera addTarget:derivativeYConv];
//    [derivativeYConv addTarget:view2];
//    [videoCamera addTarget:derivativeXConv];
//    [derivativeXConv addTarget:view3];
    
//    [videoCamera addTarget:pipeline_];
//    [pipeline_ setInput:videoCamera];
//    [pipeline_ setOutput:view4];
    
//    _samplePipeline = [[GPUImageFilterPipeline alloc] initWithOrderedFilters:empty input:videoCamera output:_filteredVideoView];

    
//    GPUImageAddBlendFilter *blend = [[GPUImageAddBlendFilter alloc] init];
//    [blend addTarget:];
    
    [videoCamera startCameraCapture];
}

- (UIImage *)imageWithCVMat:(const cv::Mat&)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize() * cvMat.total()];
    
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                     // Width
                                        cvMat.rows,                                     // Height
                                        8,                                              // Bits per component
                                        8 * cvMat.elemSize(),                           // Bits per pixel
                                        cvMat.step[0],                                  // Bytes per row
                                        colorSpace,                                     // Colorspace
                                        kCGImageAlphaNone | kCGBitmapByteOrderDefault,  // Bitmap info flags
                                        provider,                                       // CGDataProviderRef
                                        NULL,                                           // Decode
                                        false,                                          // Should interpolate
                                        kCGRenderingIntentDefault);                     // Intent
    
    UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return image;
}


NSMutableArray *_setNumberOne, *_setNumberTwo;
GPUImageFilterPipeline *_samplePipeline;

- (void)configureSomeArraysOfFilters {
    _setNumberOne = [[NSMutableArray alloc] init]; //make sure these arrays are at least scoped to the class, if not actual @properties
    GPUImageKuwaharaFilter* kuwahara = [[GPUImageKuwaharaFilter alloc] init];
    [kuwahara setRadius:5];
    GPUImageGrayscaleFilter* gray = [[GPUImageGrayscaleFilter alloc] init];
    [_setNumberOne addObject:kuwahara];
    [_setNumberOne addObject:gray];
    
    
    _setNumberTwo = [[NSMutableArray alloc] init];
    GPUImageGrayscaleFilter* otherGray = [[GPUImageGrayscaleFilter alloc] init];
    GPUImageGaussianBlurFilter* blur = [[GPUImageGaussianBlurFilter alloc] init];
    [blur setBlurRadiusInPixels:3];
    GPUImageColorInvertFilter* invert = [[GPUImageColorInvertFilter alloc] init];
    [_setNumberTwo addObject:otherGray];
    [_setNumberTwo addObject:blur];
    [_setNumberTwo addObject:invert];
}

- (void)configureAnEmptyPipeline {
    if (_samplePipeline == nil) {
        GPUImageFilter* passthrough = [[GPUImageFilter alloc] init];
        NSArray* empty = [NSArray arrayWithObjects:passthrough, nil];
        _samplePipeline = [[GPUImageFilterPipeline alloc] initWithOrderedFilters:empty input:videoCamera output:view4];
        [videoCamera startCameraCapture];
    }
}

- (void)updateFilterPipeline:(NSInteger)style {
    switch (style) {
        case 1:
            [_samplePipeline replaceAllFilters:_setNumberOne];
            break;
            
        case 2:
            [_samplePipeline replaceAllFilters:_setNumberTwo];
            
            
        default:
            break;
    }
}


+ (CGFloat)getDistanceOfLineSegment:(CGLineSegment)line fromPoint:(CGPoint)point {
    CGPoint v = CGPointMake(line.b.x - line.a.x, line.b.y - line.a.y);
    CGPoint w = CGPointMake(point.x - line.a.x, point.y - line.a.y);
    CGFloat c1 = dotProduct(w, v);
    CGFloat c2 = dotProduct(v, v);
    CGFloat d;
    if (c1 <= 0) {
        d = distance(point, line.a);
    }
    else if (c2 <= c1) {
        d = distance(point, line.b);
    }
    else {
        CGFloat b = c1 / c2;
        CGPoint Pb = CGPointMake(line.a.x + b * v.x, line.a.y + b * v.y);
        d = distance(point, Pb);
    }
    return d ;
}

+ (BOOL)isLineSegment:(CGLineSegment)line withinRadius:(CGFloat)radius fromPoint:(CGPoint)point {
    CGPoint v = CGPointMake(line.b.x - line.a.x, line.b.y - line.a.y);
    CGPoint w = CGPointMake(point.x - line.a.x, point.y - line.a.y);
    CGFloat c1 = dotProduct(w, v);
    CGFloat c2 = dotProduct(v, v);
    CGFloat d;
    if (c1 <= 0) {
        d = distance(point, line.a);
    }
    else if (c2 <= c1) {
        d = distance(point, line.b);
    }
    else {
        CGFloat b = c1 / c2;
        CGPoint Pb = CGPointMake(line.a.x + b * v.x, line.a.y + b * v.y);
        d = distance(point, Pb);
    }
    return d <= radius;
}

CGFloat distance(const CGPoint p1, const CGPoint p2) {
    return sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2));
}

CGFloat dotProduct(const CGPoint p1, const CGPoint p2) {
    return p1.x * p2.x + p1.y * p2.y;
}

@end

