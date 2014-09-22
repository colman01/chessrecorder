//
//  FilterViewController.h
//  chessrecorder
//
//  Created by colman on 22/09/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleVideoFilterViewController.h"
#import "ShowcaseFilterViewController.h"
#import <GPUImage/GPUImage.h>

@interface FilterViewController : UIViewController<GPUImageVideoCameraDelegate> {
    GPUImageVideoCamera *videoCamera;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImagePicture *sourcePicture;
    GPUImageShowcaseFilterType filterType;
    GPUImageUIElement *uiElementInput;
    GPUImageView *view1, *view2, *view3, *view4;
    
    GPUImageFilterPipeline *pipeline;
    UIView *faceView;
    
    CIDetector *faceDetector;
    
    IBOutlet UISwitch *facesSwitch;
    IBOutlet UILabel *facesLabel;
    __unsafe_unretained UISlider *_filterSettingsSlider;
    BOOL faceThinking;
}


@property(readwrite, unsafe_unretained, nonatomic) IBOutlet UISlider *filterSettingsSlider;
@property(nonatomic,retain) CIDetector*faceDetector;
// Initialization and teardown
- (id)initWithFilterType:(GPUImageShowcaseFilterType)newFilterType;
- (void)setupFilter;
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer;
// Filter adjustments
- (IBAction)updateFilterFromSlider:(id)sender;
- (void)GPUVCWillOutputFeatures:(NSArray*)featureArray forClap:(CGRect)clap
                 andOrientation:(UIDeviceOrientation)curDeviceOrientation;
-(IBAction)facesSwitched:(id)sender;



@property SimpleVideoFilterViewController  *s;

@property IBOutlet GPUImageView *gpuImageView;
@property IBOutlet SimpleVideoFilterViewController *simple;

@end
