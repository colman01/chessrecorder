//
//  ChessFilterViewController.h
//  chessrecorder
//
//  Created by colman on 23/09/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GPUImage/GPUImage.h>
#import "SimpleVideoFilterViewController.h"
#import "ShowcaseFilterViewController.h"



@interface ChessFilterViewController : UIViewController<GPUImageVideoCameraDelegate> {
    GPUImageVideoCamera *videoCamera;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImagePicture *sourcePicture;
    GPUImageShowcaseFilterType filterType;
    GPUImageUIElement *uiElementInput;
    IBOutlet GPUImageView *view1, *view2, *view3, *view4;
    
    GPUImageFilterPipeline *pipeline;
    UIView *faceView;
    
    __unsafe_unretained UISlider *_filterSettingsSlider;
}

@property(readwrite, unsafe_unretained, nonatomic) IBOutlet UISlider *filterSettingsSlider;

- (void)setupFilter;
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer;
// Filter adjustments
- (IBAction)updateFilterFromSlider:(id)sender;
- (void)GPUVCWillOutputFeatures:(NSArray*)featureArray forClap:(CGRect)clap
                 andOrientation:(UIDeviceOrientation)curDeviceOrientation;


@property IBOutlet GPUImageView *gpuImageView;

@property IBOutlet UIImageView *someImage;

@property NSMutableArray *imagesToProcess;

@property bool busy;

@end


// https://github.com/BradLarson/GPUImage/issues/112

//GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
//[contrastFilter setContrast:3.5]; // 0 - 4
//[(GPUImageFilterGroup *)filter addFilter:contrastFilter];
//
//GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
//[saturationFilter setSaturation:0.0]; // 0 - 2
//[(GPUImageFilterGroup*)filter addFilter:saturationFilter];
//
//GPUImageSharpenFilter *sharpenFilter = [[GPUImageSharpenFilter alloc] init];
//[sharpenFilter setSharpness:0.0]; // -4 - 4
//[(GPUImageFilterGroup *)filter addFilter:sharpenFilter];
//
//GPUImageVignetteFilter *vignetteFilter = [[GPUImageVignetteFilter alloc] init];
//[vignetteFilter setY:0.42];
//[(GPUImageFilterGroup *)filter addFilter:vignetteFilter];
//
//[contrastFilter addTarget:saturationFilter];
//[saturationFilter addTarget:sharpenFilter];
//[sharpenFilter addTarget:vignetteFilter];
//
//[(GPUImageFilterGroup *)filter setInitialFilters:[NSArray arrayWithObject:contrastFilter]];
//[(GPUImageFilterGroup *)filter setTerminalFilter:vignetteFilter];