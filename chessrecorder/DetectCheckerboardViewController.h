//
//  DetectCheckerboardViewController.h
//  chessrecorder
//
//  Created by Mac on 26.09.14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GPUImage/GPUImage.h>
#import "SimpleVideoFilterViewController.h"
#import "ShowcaseFilterViewController.h"


@interface DetectCheckerboardViewController : UIViewController<GPUImageVideoCameraDelegate> {
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

typedef struct {
    CGPoint a;
    CGPoint b;
} CGLineSegment;

+ (BOOL)isLineSegment:(CGLineSegment)line withinRadius:(CGFloat)radius fromPoint:(CGPoint)point ;

@end
