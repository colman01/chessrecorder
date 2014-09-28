//
//  OpenCVViewController.m
//  chessrecorder
//
//  Created by colman on 28/09/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "OpenCVViewController.h"
#import "CvMatUIImageConverter.h"
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/calib3d/calib3d.hpp>
#include <opencv2/highgui/highgui.hpp>

@interface OpenCVViewController ()

@end

@implementation OpenCVViewController

@synthesize imageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
//    UIImage *img = [UIImage imageNamed:@"Chess-board.jpg"];
    UIImage *img = [UIImage imageNamed:@"chess_rotate.jpg"];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
