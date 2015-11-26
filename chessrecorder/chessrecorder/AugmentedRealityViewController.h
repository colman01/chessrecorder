//
//  AugmentedRealityViewController.h
//  chessrecorder
//
//  Created by colman on 01/10/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GPUImage/GPUImage.h>
#import "CustomGpuImageVidCam.h"

@interface AugmentedRealityViewController : UIViewController<GPUImageVideoCameraDelegate> {
//    GPUImageVideoCamera *videoCamera;
    CustomGpuImageVidCam *videoCamera;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageFilterPipeline *pipeline;
}

@property IBOutlet GPUImageView *cameraView;

@property IBOutlet UIImageView *showImage;
@property UIImage *imageFrame;

@property BOOL historyViewer;
@property (nonatomic, assign) BOOL working;


@end
