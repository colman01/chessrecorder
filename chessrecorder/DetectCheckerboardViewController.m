//
//  DetectCheckerboardViewController.m
//  chessrecorder
//
//  Created by Mac on 26.09.14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "DetectCheckerboardViewController.h"

@interface DetectCheckerboardViewController ()

@end

@implementation DetectCheckerboardViewController

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
    
    GPUImage3x3ConvolutionFilter *convoluationCustom = [[GPUImage3x3ConvolutionFilter alloc] init];
    [(GPUImage3x3ConvolutionFilter *)convoluationCustom setConvolutionKernel:(GPUMatrix3x3){
        {0.0f,  0.0f, 0.0f},
        {-1.0f, 0.0f, 1.0f},
        {0.0f,  0.0f, 0.0f}
    }];
    
    GPUImage3x3ConvolutionFilter *convoluation = [[GPUImage3x3ConvolutionFilter alloc] init];
    [(GPUImage3x3ConvolutionFilter *)convoluation setConvolutionKernel:(GPUMatrix3x3){
        {0.0f,  1.0f, 0.0f},
        {0.0f, 0.0f, 0.0f},
        {0.0f,  -1.0f, 0.0f}
    }];
    [convoluation forceProcessingAtSize:view2.sizeInPixels];
    [convoluationCustom forceProcessingAtSize:view3.sizeInPixels];

    [videoCamera addTarget:convoluation];
    [convoluation addTarget:view2];
    [videoCamera addTarget:convoluationCustom];
    [convoluationCustom addTarget:view3];
    
    [videoCamera startCameraCapture];
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

