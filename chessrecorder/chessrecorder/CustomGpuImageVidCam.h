//
//  CustomGpuImageVidCam.h
//  chessrecorder
//
//  Created by colman on 26/11/15.
//  Copyright © 2015 Colman Marcus-Quinn. All rights reserved.
//

#import <GPUImage/GPUImage.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreMedia/CoreMedia.h>
#import <Accelerate/Accelerate.h>

@interface CustomGpuImageVidCam : GPUImageVideoCamera

@property UIImage *imageFrame;

@end
