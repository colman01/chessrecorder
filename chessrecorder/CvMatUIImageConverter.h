//
//  CvMatUIImageConverter.h
//  chessrecorder
//
//  Created by Mac on 25.09.14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/calib3d/calib3d.hpp>

@interface CvMatUIImageConverter : NSObject


+ (cv::Mat) cvMatFromUIImage:(UIImage *)image;
+ (cv::Mat) cvMatGrayFromUIImage:(UIImage *)image;
+ (cv::Mat) cvMatFromUIImage:(UIImage *)image type:(int)type;
+ (UIImage*) UIImageFromCVMat:(cv::Mat)cvMat;

@end
