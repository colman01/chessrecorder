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
    
    UIImage *outputImage  = [[UIImage alloc] init];
    
    cv::Mat image1, image2, image3, image4;
    
    UIImage *img = [UIImage imageNamed:@"nicely.jpg"];
    
    
    
//    UIImage *img = [UIImage imageNamed:@"Chess_table.jpg"];
    
    cv::Mat grayImage = [CvMatUIImageConverter cvMatGrayFromUIImage:img];
    
    img = [CvMatUIImageConverter UIImageFromCVMat:grayImage];

    
    UIImage *gaussianImage = [gaussian imageByFilteringImage:img];
    UIImage *Ix = [derivativeXConv imageByFilteringImage:gaussianImage];
    UIImage *Iy = [derivativeYConv imageByFilteringImage:gaussianImage];
    
    
    //    UIImage *Ix_45_cos = [cosConv imageByFilteringImage:Ix];
    //    UIImage *Iy_45_sin = [sinConv imageByFilteringImage:Iy];
    
    
    //    cv::Mat cvResult = [CvMatUIImageConverter cvMatGrayFromImage:outputImage];
    cv::Mat cvResult = [CvMatUIImageConverter cvMatGrayFromUIImage:outputImage];
    //    cv::Mat cvIx_cos = [CvMatUIImageConverter cvMatGrayFromUIImage:Ix_45_cos];
    //    cv::Mat cvIy_sin = [CvMatUIImageConverter cvMatGrayFromUIImage:Iy_45_sin];
    
    cv::Mat cv_Ix_ = [CvMatUIImageConverter cvMatFromUIImage:gaussianImage];
    cv::Mat cv_Iy_ = [CvMatUIImageConverter cvMatFromUIImage:gaussianImage];
    cv::Mat cvIx_cos = cv_Ix_*cosf(M_PI_4);
    cv::Mat cvIy_sin = cv_Iy_*-sinf(M_PI_4);
    cv::Mat cv_I_45;
    cv::add(cvIx_cos, cvIy_sin, cv_I_45);
    
    UIImage *I_45 = [CvMatUIImageConverter UIImageFromCVMat:cv_I_45];
    UIImage *Ixy = [derivativeYConv imageByFilteringImage:I_45];
    //    UIImage *Ixy = [xyFilter imageByFilteringImage:I_45];
    
    UIImage *I_45_x = [derivativeXConv imageByFilteringImage:I_45];
    UIImage *I_45_y = [derivativeYConv imageByFilteringImage:I_45];
    
    cv::Mat cv_I_45_x = [CvMatUIImageConverter cvMatFromUIImage:I_45_x ]  ;
    cv::Mat cv_I_45_y = [CvMatUIImageConverter cvMatFromUIImage:I_45_y ]  ;
                       cv_I_45_x *= cosf(-M_PI_4);
                       cv_I_45_y*= sinf(M_PI_4);
                       cv::Mat cv_I_45_45;
                       cv::add(cv_I_45_x, cv_I_45_y, cv_I_45_45);
    
    //    I_45_x * cos(-pi/4)
    //    I_45_y * sin(-pi/4)
//        UIImage *I_45_x_cos_n_pi4 = [negCosConv imageByFilteringImage:I_45_x];
    //    UIImage *I_45_y_sin_n_pi4 = [negSinConv imageByFilteringImage:I_45_y];
    
    
    cv::Mat posCos = cv_Ix_*cosf(M_PI_4);
    cv::Mat posSin = cv_Iy_*sinf(M_PI_4);
    
    cv::Mat negCos = cv_Ix_*cosf(-M_PI_4);
    cv::Mat negSin = cv_Iy_*sinf(-M_PI_4);

//    UIImage *I_45_x_cos_n_pi4 = [CvMatUIImageConverter UIImageFromCVMat:negCos];
    UIImage *I_45_y_sin_n_pi4 = [CvMatUIImageConverter UIImageFromCVMat:negSin];
    
    
    
    
    cv::Mat cv_Ixy = [CvMatUIImageConverter cvMatFromUIImage:Ixy];
//    cv::Mat cv_I_45_x_cos_n_pi4 = [CvMatUIImageConverter cvMatFromUIImage:I_45_x_cos_n_pi4];
    cv::Mat cv_I_45_x_cos_n_pi4 = negCos;
    cv::Mat cv_I_45_y_sin_n_pi4 = [CvMatUIImageConverter cvMatFromUIImage:I_45_y_sin_n_pi4];
    
    //    % first derivative at 45 degrees
    //    I_45 = Ix * cos(pi/4) + Iy * sin(pi/4);
    //    I_n45 = Ix * cos(-pi/4) + Iy * sin(-pi/4);
    
    cv::Mat cv_Ix_45;
    cv::Mat cv_Iy_45;
//    cv::Mat cv_I_45;
    cv::add(posCos, posSin, cv_I_45);
    
    cv::Mat cv_I_n45;
    cv::add(negCos, negSin, cv_I_n45);
    
    //    I_45_45 = I_45_x * cos(-pi/4) + I_45_y * sin(-pi/4);
    cv::Mat negSum;
    
//    cv::add(negCos, cv_I_n45, negSum);

    cv::Mat cv_cos_n45 = cosf(-M_PI_4)*negCos;
    cv::Mat cv_sin_n45 = sinf(-M_PI_4)*negSin;
    cv::Mat Img_45_45;
    cv::add(cv_cos_n45, cv_sin_n45, Img_45_45);
    
//    cv::add(negCos, cv_I_45_y_sin_n_pi4, negSum);
    cvResult = Img_45_45;

//    cv::add(cv_I_45_x_cos_n_pi4, cv_I_45_y_sin_n_pi4, negSum);
//    cv::add(negCos, cv_I_45_y_sin_n_pi4, negSum);
//    cvResult = I_45_45;

    cv::Mat absIxy = cv::abs(cv_Ixy);
    cv::Mat abs_I_45 = cv::abs(cv_I_45_x_cos_n_pi4);
    cv::Mat abs_I_n45 = cv::abs(cv_I_45_y_sin_n_pi4);
    
    cv::Mat LHS ;
    cv::add(abs_I_45, abs_I_n45, LHS);
    LHS *= 2;
    cv::Mat RHS = 4*absIxy;
    cv::Mat I_n45;
    cv::subtract(RHS, LHS, I_n45);
    // I_n45
    // image1 = I_n45;
    
//    cv::Mat mask = I_n45 <= 0 ;
//    cv::Mat masked = cvResult.setTo(0, cvResult<0 );
//    I_n45 = I_n45.setTo(0, I_n45<= 0);
    cv::Mat mask = (I_n45 <= 0);
    
    cv::Mat mask_2 = (cv_I_45_45 <= 0);

    cv::Mat nonZeroLocations;
    //    UIImage *cvOutput = [CvMatUIImageConverter UIImageFromCVMat:masked];
    //    c45 = sigma^2 * abs(I_45_45) - sigma * (abs(Ix) + abs(Iy));
//    cv::Mat absI4545 = cv::abs(cv_I_45_45);
//    cv::Mat absI4545 = cv::abs(Img_45_45);
//    cv::Mat sigmaAbsI4545 = 4*absI4545;
    cv::Mat sigmaAbsI4545 = 4*mask;
    cv::Mat cv_Ix = [CvMatUIImageConverter cvMatFromUIImage:Ix];
    cv::Mat cv_Iy = [CvMatUIImageConverter cvMatFromUIImage:Iy];
    cv::Mat absIx, absIy;
    absIx = cv::abs(cv_Ix);
    absIy = cv::abs(cv_Iy);
    cv::add(absIx, absIy, LHS);
    LHS *= 2;
//    RHS = 4*absI4545;
        RHS = 4*mask;
    cv::Mat cv_c45;
    cv::subtract(RHS, LHS, cv_c45);
    
    image1 = cvResult;
    image2 = cv_c45;
//    UIImage *cvOutput = [CvMatUIImageConverter UIImageFromCVMat:cv_c45];
    [imageView setImage:Ix];
//    [imageViewC45 setImage:Iy];
    [imageViewC45 setImage:[CvMatUIImageConverter UIImageFromCVMat:mask_2]];
//    [imageViewCxy setImage:[CvMatUIImageConverter UIImageFromCVMat:Img_45_45]]; //cv_I_n45
    [imageViewCxy setImage:[CvMatUIImageConverter UIImageFromCVMat:mask]]; //cv_I_n45
    [imageViewI setImage:[CvMatUIImageConverter UIImageFromCVMat:cv_I_45_45]]; //I_n45
//    [imageViewI setImage:[CvMatUIImageConverter UIImageFromCVMat:cv_c45]]; //I_n45
                       
//    [imageViewI setImage:cvOutput];
    
    [imageViewI setImage:[self matlab_I_cxy:img]];
}










//% Low-pass filter the image
//G = fspecial('gaussian', round(sigma * 7)+1, sigma);
//Ig = imfilter(I, G, 'conv');
//
//derivFilter = [-1 0 1];
//
//% first derivatives
//Iy = imfilter(Ig, derivFilter', 'conv');
//              Ix = imfilter(Ig, derivFilter, 'conv');
//
//              % first derivative at 45 degrees
//              I_45 = Ix * cos(pi/4) + Iy * sin(pi/4);
//              I_n45 = Ix * cos(-pi/4) + Iy * sin(-pi/4);
//
//              % second derivative
//              Ixy = imfilter(Ix, derivFilter', 'conv');
//
//                             I_45_x = imfilter(I_45, derivFilter, 'conv');
//                             I_45_y = imfilter(I_45, derivFilter', 'conv');
//
//                                               I_45_45 = I_45_x * cos(-pi/4) + I_45_y * sin(-pi/4);
//
//                                               % suppress the outer corners
//                                               cxy = sigma^2 * abs(Ixy) - sigma * (abs(I_45) + abs(I_n45));
//                                               cxy(cxy < 0) = 0;
//                                               c45 = sigma^2 * abs(I_45_45) - sigma * (abs(Ix) + abs(Iy));
//                                               c45(c45 < 0) = 0;


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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
