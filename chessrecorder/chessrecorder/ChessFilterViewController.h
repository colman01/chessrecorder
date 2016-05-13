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
//- (IBAction)updateFilterFromSlider:(id)sender;
//- (void)GPUVCWillOutputFeatures:(NSArray*)featureArray forClap:(CGRect)clap
//                 andOrientation:(UIDeviceOrientation)curDeviceOrientation;


@property IBOutlet GPUImageView *gpuImageView;

@property IBOutlet UIImageView *someImage;

@property NSMutableArray *imagesToProcess;

@property bool busy;


@property NSMutableArray *cols_from;
@property NSMutableArray *rows_from;

@property NSMutableArray *cols_too;
@property NSMutableArray *rows_too;

@property double ww_mean;
@property double wb_mean;
@property double bb_mean;
@property double bw_mean;

@property double ww_std;
@property double wb_std;
@property double bb_std;
@property double bw_std;

@property NSMutableArray *lastKnownGoodSrcPoints;

typedef struct _NSPoint {
    CGFloat x;
    CGFloat y;
} NSPoint;

@end
