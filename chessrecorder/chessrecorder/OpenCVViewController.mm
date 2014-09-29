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

#include <opencv2/legacy/legacy.hpp>

#include <vector>

@interface OpenCVViewController ()

@end

@implementation OpenCVViewController

@synthesize imageView, imageViewC45,imageViewCxy, imageViewI;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated {

    
    [self performSelectorInBackground:@selector(createImages) withObject:nil];
    [self performSelectorInBackground:@selector(calculate) withObject:nil];

    
    
}

- (void) calculate {
    UIImage *img = [UIImage imageNamed:@"nicely.jpg"];
    cv::Mat grayImage = [CvMatUIImageConverter cvMatGrayFromUIImage:img];
    img = [CvMatUIImageConverter UIImageFromCVMat:grayImage];
    [imageViewI setImage:[self matlab_I_cxy:img]];
}

- (UIImage *) matlab_I_cxy:(UIImage *) image {
    GPUImageGaussianBlurFilter *gaussianFilter = [[GPUImageGaussianBlurFilter alloc ] init];
    UIImage *Ig = [gaussianFilter imageByFilteringImage:image];
    
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
    
    UIImage *Ix = [derivativeXConv imageByFilteringImage:Ig];
    UIImage *Iy = [derivativeYConv imageByFilteringImage:Ig];
    
    UIImage *Ixy = [derivativeYConv imageByFilteringImage:Iy];
    
    cv::Mat cv_Ixy = [CvMatUIImageConverter cvMatFromUIImage:Ixy];
    
    cv::Mat cv_Ix = [CvMatUIImageConverter cvMatFromUIImage:Ix];
    cv::Mat cv_Iy = [CvMatUIImageConverter cvMatFromUIImage:Iy];
    
    cv::Mat Ix45 = cv_Ix*cosf(M_PI_4);
    cv::Mat Iy45 = cv_Iy*sinf(M_PI_4);
    
    cv::Mat I_45;
    cv::add(Ix45,Iy45, I_45);
    
    
    cv::Mat Ixn45 = cv_Ix*cosf(-M_PI_4);
    cv::Mat Iyn45 = cv_Iy*sinf(-M_PI_4);
    
    cv::Mat I_45_45;
    cv::Mat Ix_n45 = Ix45*cosf(-M_PI_4);
    cv::Mat Iy_n45 = Ix45*sinf(-M_PI_4);
    
    cv::add(Ix_n45,Iy_n45, I_45_45);
    
    cv::Mat I_n45;
    cv::add(Ix_n45, Iy_n45, I_n45);
    
    
//    cv::Mat mask = (I_45_45 <= 0);
    
    float sigmaSquared = 4.0;
    cv::Mat abs_Ixy = cv::abs(cv_Ixy);
    cv::Mat LHS = sigmaSquared*abs_Ixy;
    cv::Mat product;
    cv::add(cv::abs(I_45), cv::abs(I_n45), product);
    cv::Mat RHS = 2*product;
    cv::Mat cxy;
    cv::add(LHS, RHS,cxy);
    cv::Mat mask = (cxy <= 0);
    
    
    cv::Mat c45;
    cv::Mat absI_45_45 = cv::abs(I_45_45);
    cv::Mat abs_Ix = cv::abs(cv_Ix);
    cv::Mat abs_Iy = cv::abs(cv_Iy);
    
    cv::Mat absI;
    cv::add(abs_Ix, abs_Iy, absI);
    
    LHS = absI_45_45*4;
    RHS = absI*2;
    cv::subtract(RHS, LHS, c45);
    
    cv::Mat IxIy;
    cv::add(abs_Ix, abs_Iy, IxIy);
    mask = (RHS <= 0);
//    mask = (c45 <= 0);
    return [CvMatUIImageConverter UIImageFromCVMat:c45];

    
    
}


- (void) createImages {
    UIImage *img = [UIImage imageNamed:@"nicely.jpg"];
    cv::Mat grayImage = [CvMatUIImageConverter cvMatGrayFromUIImage:img];
    img = [CvMatUIImageConverter UIImageFromCVMat:grayImage];
    
    UIImage *outputImage  = [[UIImage alloc] init];
    cv::Mat image1, image2, image3, image4;
    
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
    
    GPUImage3x3ConvolutionFilter *negCosConv = [[GPUImage3x3ConvolutionFilter alloc] init];
    [(GPUImage3x3ConvolutionFilter *)negCosConv setConvolutionKernel:(GPUMatrix3x3){
        {-cosf(M_PI_4),  0.0f, 0.0f},
        {0.0f, -cosf(M_PI_4), 0.0f},
        {0.0f,  0.0f, -cosf(M_PI_4)}
    }];
    
    GPUImage3x3ConvolutionFilter *sinConv = [[GPUImage3x3ConvolutionFilter alloc] init];
    [(GPUImage3x3ConvolutionFilter *)sinConv setConvolutionKernel:(GPUMatrix3x3){
        {sinf(M_PI_4),  0.0f, 0.0f},
        {0.0f, sinf(M_PI_4), 0.0f},
        {0.0f,  0.0f, sinf(M_PI_4)}
    }];
    
    GPUImage3x3ConvolutionFilter *negSinConv = [[GPUImage3x3ConvolutionFilter alloc] init];
    [(GPUImage3x3ConvolutionFilter *)negSinConv setConvolutionKernel:(GPUMatrix3x3){
        {-sinf(M_PI_4),  0.0f, 0.0f},
        {0.0f, -sinf(M_PI_4), 0.0f},
        {0.0f,  0.0f, -sinf(M_PI_4)}
    }];
    
    
    UIImage *gaussianImage = [gaussian imageByFilteringImage:img];
    UIImage *Ix = [derivativeXConv imageByFilteringImage:gaussianImage];
    UIImage *Iy = [derivativeYConv imageByFilteringImage:gaussianImage];
    
    cv::Mat cvResult = [CvMatUIImageConverter cvMatGrayFromUIImage:outputImage];
    
    cv::Mat cv_Ix_ = [CvMatUIImageConverter cvMatFromUIImage:gaussianImage];
    cv::Mat cv_Iy_ = [CvMatUIImageConverter cvMatFromUIImage:gaussianImage];
    cv::Mat cvIx_cos = cv_Ix_*cosf(M_PI_4);
    cv::Mat cvIy_sin = cv_Iy_*-sinf(M_PI_4);
    cv::Mat cv_I_45;
    cv::add(cvIx_cos, cvIy_sin, cv_I_45);
    
    UIImage *I_45 = [CvMatUIImageConverter UIImageFromCVMat:cv_I_45];  /////// I_45
    UIImage *Ixy = [derivativeYConv imageByFilteringImage:I_45];      /////// Ixy
    //    UIImage *Ixy = [xyFilter imageByFilteringImage:I_45];
    
    UIImage *I_45_x = [derivativeXConv imageByFilteringImage:I_45];
    UIImage *I_45_y = [derivativeYConv imageByFilteringImage:I_45];
    
    cv::Mat cv_I_45_x = [CvMatUIImageConverter cvMatFromUIImage:I_45_x ]  ;
    cv::Mat cv_I_45_y = [CvMatUIImageConverter cvMatFromUIImage:I_45_y ]  ;
    cv_I_45_x *= cosf(-M_PI_4);
    cv_I_45_y*= sinf(M_PI_4);
    cv::Mat cv_I_45_45;
    
    cv::Mat posCos = cv_I_45_x*cosf(M_PI_4);
    cv::Mat posSin = cv_I_45_y*sinf(M_PI_4);
    
    cv::Mat negCos = cv_I_45_x*cosf(-M_PI_4);
    cv::Mat negSin = cv_I_45_y*sinf(-M_PI_4);
    
    cv::add(negSin, negCos, cv_I_45_45);
    
    UIImage *I_45_y_sin_n_pi4 = [CvMatUIImageConverter UIImageFromCVMat:negSin];
    
    cv::Mat cv_Ixy = [CvMatUIImageConverter cvMatFromUIImage:Ixy];
    cv::Mat cv_I_45_x_cos_n_pi4 = negCos;
    cv::Mat cv_I_45_y_sin_n_pi4 = [CvMatUIImageConverter cvMatFromUIImage:I_45_y_sin_n_pi4];
    cv::Mat cv_Ix_45;
    cv::Mat cv_Iy_45;
    cv::add(posCos, posSin, cv_I_45);
    
    cv::Mat cv_I_n45;
    cv::add(negCos, negSin, cv_I_n45);      /////// I_n45
    
    cv::Mat negSum;
    cv::Mat cv_cos_n45 = cosf(-M_PI_4)*negCos;
    cv::Mat cv_sin_n45 = sinf(-M_PI_4)*negSin;
    cv::Mat Img_45_45;
    cv::add(cv_cos_n45, cv_sin_n45, Img_45_45);
    
    cvResult = Img_45_45;
    cv::Mat absIxy = cv::abs(cv_Ixy);
    cv::Mat abs_I_45 = cv::abs(cv_I_45_x_cos_n_pi4);
    cv::Mat abs_I_n45 = cv::abs(cv_I_45_y_sin_n_pi4);
    
    cv::Mat LHS ;
    cv::add(abs_I_45, abs_I_n45, LHS);
    LHS *= 2;
    cv::Mat RHS = 4*absIxy;
    cv::Mat I_n45;
    cv::subtract(RHS, LHS, I_n45);
    cv::Mat I_n45_abs = (I_n45 <= 0);
    
    cv::Mat cv_Ix = [CvMatUIImageConverter cvMatFromUIImage:Ix];
    cv::Mat cv_Iy = [CvMatUIImageConverter cvMatFromUIImage:Iy];
    cv::Mat absIx, absIy;
    absIx = cv::abs(cv_Ix);
    absIy = cv::abs(cv_Iy);
    cv::add(absIx, absIy, LHS);
    LHS *= 4;
    
    cv::Mat cv_cxy;
    cv::Mat cv_c45;
    
    cv::Mat cv_I_45_PLUS_I_n45;
    cv::add(abs_I_45, I_n45_abs,cv_I_45_PLUS_I_n45);
    
    cv_I_45_PLUS_I_n45 *= 2;
    
    cv::subtract(cv_I_45_PLUS_I_n45, LHS, cv_c45);
    
    cv::Mat mask = (cv_c45 <= 0);
    [imageView setImage:[CvMatUIImageConverter UIImageFromCVMat:mask]];
    [imageViewC45 setImage:[CvMatUIImageConverter UIImageFromCVMat:cv_I_45_45]];
    [imageViewCxy setImage:[CvMatUIImageConverter UIImageFromCVMat:cv_c45]]; //cv_I_n45
//    [imageViewI setImage:[CvMatUIImageConverter UIImageFromCVMat:cv_I_45_45]]; //I_n45
    [imageViewI setImage:[CvMatUIImageConverter UIImageFromCVMat:cv_I_45_x]]; //I_n45
    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
