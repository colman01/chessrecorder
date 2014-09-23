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


@end
